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

  // 🚀 A MÁGICA ACONTECE AQUI: Web Scraping DOM via Proxy CORS
  const handleSearch = async (offset = 0) => {
    if (!keyword.trim()) {
      toast.error("Digite uma palavra-chave para buscar.");
      return;
    }
    setSearching(true);
    try {
      // 1. Formata a URL como um navegador humano faria (a paginação do ML pula de 50 em 50)
      const formattedKeyword = encodeURIComponent(keyword.trim().replace(/\s+/g, '-'));
      const targetUrl = offset > 0
        ? `https://lista.mercadolivre.com.br/${formattedKeyword}_Desde_${offset + 1}_NoIndex_True`
        : `https://lista.mercadolivre.com.br/${formattedKeyword}`;

      // Envolvemos a URL no Proxy para evitar bloqueio de CORS do navegador
      const proxyUrl = `https://api.allorigins.win/get?url=${encodeURIComponent(targetUrl)}`;

      const proxyRes = await fetch(proxyUrl);
      if (!proxyRes.ok) throw new Error("Falha ao contatar o servidor de extração.");

      const proxyData = await proxyRes.json();
      if (!proxyData.contents) throw new Error("A página do Mercado Livre retornou vazia.");

      // 2. Transforma o texto HTML bruto em elementos pesquisáveis pelo JavaScript
      const parser = new DOMParser();
      const doc = parser.parseFromString(proxyData.contents, "text/html");

      // 3. Captura os cards de produtos. O ML usa 'ui-search-layout__item' ou 'poly-card'
      const items = doc.querySelectorAll('.ui-search-layout__item, .poly-card');
      const mappedResults: MLItem[] = [];

      items.forEach((item) => {
        // Título
        const title = item.querySelector('h2')?.textContent?.trim() || '';

        // Link e extração do ID
        const linkEl = item.querySelector('a');
        let link = linkEl?.getAttribute('href') || '';
        link = link.split('?')[0]; // Remove rastreamento da URL

        const idMatch = link.match(/MLB-?(\d+)/);
        const id = idMatch ? `MLB${idMatch[1]}` : '';

        // Preço (Pula preços com linha cortada <s> que são o preço original sem desconto)
        let priceVal = 0;
        const priceElements = item.querySelectorAll('.andes-money-amount__fraction, .price-tag-fraction');
        for (let i = 0; i < priceElements.length; i++) {
          const el = priceElements[i];
          if (!el.closest('s')) { // Se não estiver dentro de uma tag <s> (strike-through)
            priceVal = parseInt(el.textContent?.replace(/\./g, '') || '0', 10);
            break;
          }
        }

        // Imagem (Lida com o lazy-load do ML)
        const imgEl = item.querySelector('img');
        let thumbnail = imgEl?.getAttribute('data-src') || imgEl?.getAttribute('src') || '';
        // Converte imagens miniatura de carregamento para resolução um pouco melhor
        thumbnail = thumbnail.replace('I.jpg', 'F.jpg').replace('W.jpg', 'F.jpg');

        // Frete Grátis
        const textContent = item.textContent?.toLowerCase() || '';
        const shipping_free = textContent.includes('frete grátis') || textContent.includes('envio grátis');

        if (id && title && priceVal > 0) {
          // Previne duplicados que o ML injeta em carrosséis patrocinados no meio da busca
          if (!mappedResults.some(r => r.id === id)) {
            mappedResults.push({
              id,
              title,
              price: priceVal,
              original_price: null,
              currency_id: 'BRL',
              thumbnail,
              permalink: link,
              condition: 'new', // Na busca geral assumimos novo, a importação oficial corrigirá isso
              sold_quantity: 0,
              available_quantity: 99,
              seller: { id: 0, nickname: 'Vendedor ML' },
              category_id: '',
              shipping_free
            });
          }
        }
      });

      if (mappedResults.length === 0) {
        toast.warning("Nenhum produto com preço válido encontrado nesta página.");
      }

      // 4. Verifica no Supabase quais desses já foram importados
      const mlIds = mappedResults.map((r) => r.id);
      let importedSet = new Set<string>();

      if (mlIds.length > 0) {
        const { data: existingMappings } = await supabase
          .from("ml_product_mappings")
          .select("ml_item_id")
          .in("ml_item_id", mlIds);

        if (existingMappings) {
          importedSet = new Set(existingMappings.map(m => m.ml_item_id));
        }
      }

      const finalResults = mappedResults.map((r) => ({
        ...r,
        already_imported: importedSet.has(r.id),
      }));

      // Mantém os resultados anteriores se for paginação, ou substitui se for busca nova
      setResults(offset === 0 ? finalResults : [...results, ...finalResults]);
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
    if (importing.has(item.id) || imported.has(item.id)) return;

    setImporting((prev) => new Set(prev).add(item.id));
    try {
      // A importação continua usando a API oficial, pois buscar 1 produto específico 
      // por ID é permitido e nos traz a foto em alta resolução e o vendedor correto.
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

  const handleBatchSync = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("ml-batch-sync", {
        body: { userId: user?.id },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      toast.success(`Sincronização concluída! ${data.processed} processados.`);
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
        </div>
        <div className="bg-card rounded-xl border border-border p-8 text-center space-y-4" style={{ boxShadow: "var(--shadow-card)" }}>
          <div className="w-16 h-16 rounded-2xl bg-yellow-500/10 flex items-center justify-center mx-auto">
            <KeyRound className="w-8 h-8 text-yellow-500" />
          </div>
          <h3 className="font-display font-bold text-lg text-foreground">Autorização Necessária</h3>
          <p className="text-sm text-muted-foreground max-w-md mx-auto">
            A busca agora funciona com extração direta, mas para importar o estoque real em alta resolução, você precisa conectar o App.
          </p>
          <button onClick={handleStartOAuth} className="inline-flex items-center gap-2 px-6 py-3 rounded-lg bg-yellow-500 text-white font-semibold hover:bg-yellow-600 transition-colors">
            <Link2 className="w-5 h-5" /> Conectar Mercado Livre
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
          <p className="text-sm text-muted-foreground mt-1">Busque, importe e sincronize produtos livremente.</p>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-xs bg-secondary px-3 py-1.5 rounded-full text-muted-foreground">{mappingsCount} mapeados</span>
          <button onClick={handleBatchSync} disabled={syncing} className="flex items-center gap-2 text-sm px-4 py-2 rounded-lg bg-yellow-500 text-white hover:bg-yellow-600 transition-colors disabled:opacity-50">
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
              placeholder="Buscar produtos (ex: iPhone 15, tênis Nike)"
              className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-yellow-500/30"
            />
          </div>
          <button onClick={() => handleSearch(0)} disabled={searching} className="h-10 px-5 rounded-lg bg-yellow-500 text-white text-sm font-semibold hover:bg-yellow-600 disabled:opacity-50 transition-colors flex items-center justify-center gap-2">
            {searching && results.length === 0 ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />} Buscar
          </button>
        </div>
      </div>

      {results.length > 0 && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted-foreground">{results.length} resultados listados</span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            <AnimatePresence>
              {results.map((item) => {
                const isImporting = importing.has(item.id);
                const isImported = imported.has(item.id);

                return (
                  <motion.div key={item.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className={`bg-card rounded-xl border border-border overflow-hidden transition-all ${isImported ? "opacity-60" : ""}`} style={{ boxShadow: "var(--shadow-card)" }}>
                    <div className="flex gap-3 p-4">
                      <div className="w-20 h-20 rounded-lg bg-secondary overflow-hidden shrink-0">
                        {item.thumbnail ? (
                          <img src={item.thumbnail} alt={item.title} className="w-full h-full object-cover" />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center text-muted-foreground"><Package className="w-6 h-6" /></div>
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-sm text-foreground line-clamp-2 leading-tight">{item.title}</h4>
                        <div className="flex items-center gap-3 mt-2">
                          <span className="font-bold text-sm text-foreground">R$ {Number(item.price).toFixed(2).replace(".", ",")}</span>
                        </div>
                        <div className="flex items-center gap-2 mt-1.5 flex-wrap">
                          {item.shipping_free && <span className="text-xs bg-green-500/10 text-green-600 px-1.5 py-0.5 rounded">Frete grátis</span>}
                        </div>
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                      <button onClick={() => handleImport(item)} disabled={isImporting || isImported} className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors ${isImported ? "bg-green-500/10 text-green-600 cursor-default" : "bg-yellow-500 text-white hover:bg-yellow-600 disabled:opacity-50"}`}>
                        {isImported ? <><Check className="w-3.5 h-3.5" /> Importado</> : isImporting ? <><Loader2 className="w-3.5 h-3.5 animate-spin" /> Importando...</> : <><Download className="w-3.5 h-3.5" /> Importar</>}
                      </button>
                      <a href={item.permalink} target="_blank" rel="noopener noreferrer" className="h-9 w-9 rounded-lg border border-border flex items-center justify-center hover:bg-secondary transition-colors">
                        <ExternalLink className="w-3.5 h-3.5 text-muted-foreground" />
                      </a>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>

          <div className="flex justify-center mt-6">
            <button onClick={() => handleSearch(currentOffset + 50)} disabled={searching} className="px-6 py-2 rounded-lg border border-border text-sm hover:bg-secondary transition-colors disabled:opacity-50 flex items-center gap-2">
              {searching ? <><Loader2 className="w-4 h-4 animate-spin" /> Carregando...</> : "Carregar Próxima Página"}
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminMercadoLivre;