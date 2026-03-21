import { useState, useEffect } from "react";
import { Search, Download, RefreshCw, Loader2, ExternalLink, Check, Clock, Package, X, Link2, AlertTriangle, KeyRound } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";

interface MLItem {
  id: string;
  title: string;
  price: number;
  original_price: number | null;
  currency_id: string;
  thumbnail: string;
  permalink: string;
  condition: string;
  sold_quantity: number;
  available_quantity: number;
  seller: { id: number; nickname: string };
  category_id: string;
  shipping_free: boolean;
  already_imported?: boolean;
}

const AdminMercadoLivre = () => {
  const { user } = useAuth();
  const qc = useQueryClient();

  const [oauthConnected, setOauthConnected] = useState<boolean | null>(null);
  const [checkingAuth, setCheckingAuth] = useState(true);

  const [keyword, setKeyword] = useState("");
  const [searching, setSearching] = useState(false);
  const [results, setResults] = useState<MLItem[]>([]);
  const [paging, setPaging] = useState<any>(null);
  const [currentOffset, setCurrentOffset] = useState(0);

  const [importing, setImporting] = useState<Set<string>>(new Set());
  const [imported, setImported] = useState<Set<string>>(new Set());
  const [syncing, setSyncing] = useState(false);

  const { data: syncLogs = [] } = useQuery({
    queryKey: ["ml_sync_logs"],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from("ml_sync_logs")
        .select("*")
        .order("created_at", { ascending: false })
        .limit(20);
      if (error) throw error;
      return data;
    },
  });

  const { data: mappingsCount = 0 } = useQuery({
    queryKey: ["ml_mappings_count"],
    queryFn: async () => {
      const { count, error } = await (supabase as any)
        .from("ml_product_mappings")
        .select("id", { count: "exact", head: true })
        .eq("sync_status", "active");
      if (error) throw error;
      return count || 0;
    },
  });

  useEffect(() => {
    const checkAuth = async () => {
      setCheckingAuth(true);
      try {
        const { data, error } = await (supabase as any)
          .from("ml_tokens")
          .select("id, expires_at")
          .order("updated_at", { ascending: false })
          .limit(1)
          .maybeSingle();
        setOauthConnected(!!data && !error);
      } catch {
        setOauthConnected(false);
      } finally {
        setCheckingAuth(false);
      }
    };
    checkAuth();
  }, []);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const code = params.get("code");
    if (code) {
      handleOAuthCallback(code);
      window.history.replaceState({}, "", window.location.pathname);
    }
  }, []);

  const handleOAuthCallback = async (code: string) => {
    try {
      const redirectUri = import.meta.env.VITE_ML_REDIRECT_URI || (window.location.origin + "/admin/mercadolivre");
      const { data, error } = await supabase.functions.invoke("ml-oauth-callback", {
        body: { code, userId: user?.id, redirect_uri: redirectUri },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      toast.success("Mercado Livre conectado com sucesso!");
      setOauthConnected(true);
    } catch (err: any) {
      toast.error("Erro ao conectar: " + (err.message || "Falha"));
    }
  };

  const handleStartOAuth = () => {
    const appId = import.meta.env.VITE_ML_APP_ID;
    const redirectUri = import.meta.env.VITE_ML_REDIRECT_URI || (window.location.origin + "/admin/mercadolivre");

    if (!appId) {
      toast.error("ML_APP_ID não configurado. Adicione VITE_ML_APP_ID nas variáveis de ambiente.");
      return;
    }

    const authUrl = `https://auth.mercadolivre.com.br/authorization?response_type=code&client_id=${appId}&redirect_uri=${encodeURIComponent(redirectUri)}`;
    window.location.href = authUrl;
  };

  // SOLUÇÃO DEFINITIVA: Busca via Proxy CORS Público (AllOrigins)
  const handleSearch = async (offset = 0) => {
    if (!keyword.trim()) {
      toast.error("Digite uma palavra-chave para buscar.");
      return;
    }
    setSearching(true);
    try {
      // 1. Monta a URL oficial de Anúncios e a envolve no Proxy para contornar WAF e CORS
      const targetUrl = `https://api.mercadolibre.com/sites/MLB/search?q=${encodeURIComponent(keyword.trim())}&offset=${offset}&limit=20`;
      const proxyUrl = `https://api.allorigins.win/get?url=${encodeURIComponent(targetUrl)}`;

      const proxyRes = await fetch(proxyUrl);
      if (!proxyRes.ok) throw new Error("Falha ao acessar o serviço de busca (Proxy).");

      const proxyData = await proxyRes.json();
      if (!proxyData.contents) throw new Error("Resposta vazia da API do Mercado Livre.");

      // O conteúdo real da API vem como string dentro de 'contents'
      const searchData = JSON.parse(proxyData.contents);

      if (searchData.error || searchData.status === 403) {
        throw new Error(searchData.message || "A busca foi bloqueada pelo Mercado Livre.");
      }

      const items = searchData.results || [];

      // 2. Mapeamento direto (já que /sites/MLB/search traz os dados completos e precisos)
      const mappedResults: MLItem[] = items.map((item: any) => ({
        id: item.id,
        title: item.title,
        price: item.price || 0,
        original_price: item.original_price,
        currency_id: item.currency_id || "BRL",
        thumbnail: item.thumbnail?.replace("http://", "https://") || "",
        permalink: item.permalink || "",
        condition: item.condition || "new",
        sold_quantity: item.sold_quantity || 0,
        available_quantity: item.available_quantity || 1,
        seller: { id: item.seller?.id || 0, nickname: item.seller?.nickname || "Vendedor ML" },
        category_id: item.category_id || "",
        shipping_free: item.shipping?.free_shipping || false,
      }));

      // 3. Consulta rápida ao Supabase apenas para saber quais IDs já foram importados
      const mlIds = mappedResults.map((r) => r.id);
      let importedSet = new Set<string>();

      if (mlIds.length > 0) {
        const { data: existingMappings, error: dbError } = await supabase
          .from("ml_product_mappings")
          .select("ml_item_id")
          .in("ml_item_id", mlIds);

        if (!dbError && existingMappings) {
          importedSet = new Set(existingMappings.map(m => m.ml_item_id));
        }
      }

      // 4. Consolida o estado e exibe na tela
      const finalResults = mappedResults.map((r) => ({
        ...r,
        already_imported: importedSet.has(r.id),
      }));

      setResults(finalResults);
      setPaging(searchData.paging || null);
      setCurrentOffset(offset);

      setImported(prev => {
        const newSet = new Set(prev);
        importedSet.forEach(id => newSet.add(id));
        return newSet;
      });

    } catch (err: any) {
      console.error(err);
      toast.error("Erro na busca: " + (err.message || "Falha"));
    } finally {
      setSearching(false);
    }
  };

  const handleImport = async (item: MLItem) => {
    // Agora todo item será um anúncio válido com preço > 0
    if (importing.has(item.id) || imported.has(item.id) || item.price === 0) return;

    setImporting((prev) => new Set(prev).add(item.id));
    try {
      // A importação via Edge Function continua segura, pois a busca direta pelo ID do item é permitida
      const { data, error } = await supabase.functions.invoke("ml-import-product", {
        body: { item, userId: user?.id },
      });
      if (error) throw error;
      if (data?.error) {
        if (data?.product_id) {
          toast.info("Produto já estava importado.");
          setImported((prev) => new Set(prev).add(item.id));
        } else {
          throw new Error(data.error);
        }
      } else {
        toast.success(`"${item.title?.slice(0, 40)}..." importado!`);
        setImported((prev) => new Set(prev).add(item.id));
        qc.invalidateQueries({ queryKey: ["products"] });
        qc.invalidateQueries({ queryKey: ["ml_mappings_count"] });
      }
    } catch (err: any) {
      toast.error("Erro ao importar: " + (err.message || "Falha"));
    } finally {
      setImporting((prev) => {
        const s = new Set(prev);
        s.delete(item.id);
        return s;
      });
    }
  };

  const handleImportAll = async () => {
    const available = results.filter((r) => !imported.has(r.id) && r.price > 0);
    if (available.length === 0) {
      toast.info("Nenhum produto válido disponível para importar.");
      return;
    }
    for (const item of available) {
      await handleImport(item);
    }
  };

  const handleBatchSync = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("ml-batch-sync", {
        body: { userId: user?.id },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      toast.success(
        `Sincronização concluída! ${data.processed} processados, ${data.updated} atualizados, ${data.deactivated} desativados.`
      );
      qc.invalidateQueries({ queryKey: ["ml_sync_logs"] });
      qc.invalidateQueries({ queryKey: ["ml_mappings_count"] });
      qc.invalidateQueries({ queryKey: ["products"] });
    } catch (err: any) {
      toast.error("Erro na sincronização: " + (err.message || "Falha"));
    } finally {
      setSyncing(false);
    }
  };

  if (checkingAuth) {
    return (
      <div className="flex items-center justify-center py-20">
        <Loader2 className="w-8 h-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (!oauthConnected) {
    return (
      <div className="space-y-6">
        <div>
          <h2 className="font-display font-bold text-xl text-foreground flex items-center gap-2">
            <Package className="w-5 h-5 text-yellow-500" />
            Mercado Livre
          </h2>
          <p className="text-sm text-muted-foreground mt-1">
            Conecte sua conta do Mercado Livre para buscar e importar produtos.
          </p>
        </div>

        <div className="bg-card rounded-xl border border-border p-8 text-center space-y-4" style={{ boxShadow: "var(--shadow-card)" }}>
          <div className="w-16 h-16 rounded-2xl bg-yellow-500/10 flex items-center justify-center mx-auto">
            <KeyRound className="w-8 h-8 text-yellow-500" />
          </div>
          <h3 className="font-display font-bold text-lg text-foreground">Autorização Necessária</h3>
          <p className="text-sm text-muted-foreground max-w-md mx-auto">
            Para buscar e importar produtos do Mercado Livre, você precisa autorizar o acesso via OAuth.
            Clique no botão abaixo para iniciar o processo.
          </p>
          <button
            onClick={handleStartOAuth}
            className="inline-flex items-center gap-2 px-6 py-3 rounded-lg bg-yellow-500 text-white font-semibold hover:bg-yellow-600 transition-colors"
          >
            <Link2 className="w-5 h-5" />
            Conectar Mercado Livre
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="font-display font-bold text-xl text-foreground flex items-center gap-2">
            <Package className="w-5 h-5 text-yellow-500" />
            Mercado Livre
          </h2>
          <p className="text-sm text-muted-foreground mt-1">
            Busque, importe e sincronize produtos do Mercado Livre.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-xs bg-secondary px-3 py-1.5 rounded-full text-muted-foreground">
            {mappingsCount} produtos mapeados
          </span>
          <button
            onClick={handleBatchSync}
            disabled={syncing}
            className="flex items-center gap-2 text-sm px-4 py-2 rounded-lg bg-yellow-500 text-white hover:bg-yellow-600 transition-colors disabled:opacity-50"
          >
            {syncing ? <Loader2 className="w-4 h-4 animate-spin" /> : <RefreshCw className="w-4 h-4" />}
            {syncing ? "Sincronizando..." : "Sincronizar Preços"}
          </button>
        </div>
      </div>

      <div className="bg-card rounded-xl border border-border p-4" style={{ boxShadow: "var(--shadow-card)" }}>
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
            <input
              value={keyword}
              onChange={(e) => setKeyword(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleSearch(0)}
              placeholder="Buscar produtos no Mercado Livre... (ex: iPhone 15, tênis Nike)"
              className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-yellow-500/30"
            />
          </div>
          <button
            onClick={() => handleSearch(0)}
            disabled={searching}
            className="h-10 px-5 rounded-lg bg-yellow-500 text-white text-sm font-semibold hover:bg-yellow-600 disabled:opacity-50 transition-colors flex items-center justify-center gap-2"
          >
            {searching ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />}
            Buscar
          </button>
        </div>
      </div>

      {results.length > 0 && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted-foreground">
              {paging?.total || results.length} resultados encontrados
            </span>
            <button
              onClick={handleImportAll}
              className="text-sm px-3 py-1.5 rounded-lg border border-border hover:bg-secondary transition-colors flex items-center gap-1.5"
            >
              <Download className="w-3.5 h-3.5" />
              Importar Todos
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            <AnimatePresence>
              {results.map((item) => {
                const isImporting = importing.has(item.id);
                const isImported = imported.has(item.id);
                const hasOffer = item.price > 0;

                return (
                  <motion.div
                    key={item.id}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className={`bg-card rounded-xl border border-border overflow-hidden transition-all ${isImported || !hasOffer ? "opacity-60" : ""}`}
                    style={{ boxShadow: "var(--shadow-card)" }}
                  >
                    <div className="flex gap-3 p-4">
                      <div className="w-20 h-20 rounded-lg bg-secondary overflow-hidden shrink-0">
                        {item.thumbnail ? (
                          <img src={item.thumbnail} alt={item.title} className="w-full h-full object-cover" />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center text-muted-foreground">
                            <Package className="w-6 h-6" />
                          </div>
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-sm text-foreground line-clamp-2 leading-tight">
                          {item.title}
                        </h4>
                        <p className="text-xs text-muted-foreground mt-1">{item.seller?.nickname}</p>
                        <div className="flex items-center gap-3 mt-2">
                          <span className="font-bold text-sm text-foreground">
                            R$ {Number(item.price).toFixed(2).replace(".", ",")}
                          </span>
                          {item.original_price && item.original_price > item.price && (
                            <span className="text-xs text-muted-foreground line-through">
                              R$ {Number(item.original_price).toFixed(2).replace(".", ",")}
                            </span>
                          )}
                        </div>
                        <div className="flex items-center gap-2 mt-1.5 flex-wrap">
                          {item.condition && (
                            <span className="text-xs bg-yellow-500/10 text-yellow-600 px-1.5 py-0.5 rounded">
                              {item.condition === "new" ? "Novo" : "Usado"}
                            </span>
                          )}
                          {!hasOffer && (
                            <span className="text-xs bg-red-500/10 text-red-600 px-1.5 py-0.5 rounded font-medium">
                              Sem Anúncio Ativo
                            </span>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                      <button
                        onClick={() => handleImport(item)}
                        disabled={isImporting || isImported || !hasOffer}
                        className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors ${isImported
                            ? "bg-green-500/10 text-green-600 cursor-default"
                            : !hasOffer
                              ? "bg-secondary text-muted-foreground cursor-not-allowed"
                              : "bg-yellow-500 text-white hover:bg-yellow-600 disabled:opacity-50"
                          }`}
                      >
                        {isImported ? (
                          <><Check className="w-3.5 h-3.5" /> Importado</>
                        ) : !hasOffer ? (
                          <><X className="w-3.5 h-3.5" /> Indisponível</>
                        ) : isImporting ? (
                          <><Loader2 className="w-3.5 h-3.5 animate-spin" /> Importando...</>
                        ) : (
                          <><Download className="w-3.5 h-3.5" /> Importar</>
                        )}
                      </button>
                      {item.permalink && (
                        <a
                          href={item.permalink}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="h-9 w-9 rounded-lg border border-border flex items-center justify-center hover:bg-secondary transition-colors"
                        >
                          <ExternalLink className="w-3.5 h-3.5 text-muted-foreground" />
                        </a>
                      )}
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminMercadoLivre;