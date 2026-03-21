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

  // OAuth state
  const [oauthConnected, setOauthConnected] = useState<boolean | null>(null);
  const [checkingAuth, setCheckingAuth] = useState(true);

  // Search state
  const [keyword, setKeyword] = useState("");
  const [searching, setSearching] = useState(false);
  const [results, setResults] = useState<MLItem[]>([]);
  const [paging, setPaging] = useState<any>(null);
  const [currentOffset, setCurrentOffset] = useState(0);

  // Import state
  const [importing, setImporting] = useState<Set<string>>(new Set());
  const [imported, setImported] = useState<Set<string>>(new Set());

  // Sync state
  const [syncing, setSyncing] = useState(false);

  // Sync logs
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

  // Mapped products count
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

  // Check if OAuth is connected
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

  // Handle OAuth callback code from URL
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const code = params.get("code");
    if (code) {
      handleOAuthCallback(code);
      // Clean URL
      window.history.replaceState({}, "", window.location.pathname);
    }
  }, []);

  const handleOAuthCallback = async (code: string) => {
    try {
      const redirectUri = `${window.location.origin}/admin/mercadolivre`;
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
    const redirectUri = import.meta.env.VITE_ML_REDIRECT_URI || `${window.location.origin}/admin/mercadolivre`;
    
    if (!appId) {
      toast.error("ML_APP_ID não configurado. Adicione VITE_ML_APP_ID nas variáveis de ambiente.");
      return;
    }

    const authUrl = `https://auth.mercadolivre.com.br/authorization?response_type=code&client_id=${appId}&redirect_uri=${encodeURIComponent(redirectUri)}`;
    window.location.href = authUrl;
  };

  const handleSearch = async (offset = 0) => {
    if (!keyword.trim()) {
      toast.error("Digite uma palavra-chave para buscar.");
      return;
    }
    setSearching(true);
    try {
      const { data, error } = await supabase.functions.invoke("ml-search-products", {
        body: { keyword: keyword.trim(), offset, limit: 20 },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      setResults(data.results || []);
      setPaging(data.paging || null);
      setCurrentOffset(offset);

      const alreadyImported = new Set<string>(
        (data.results || []).filter((r: MLItem) => r.already_imported).map((r: MLItem) => r.id)
      );
      setImported(alreadyImported);
    } catch (err: any) {
      toast.error("Erro na busca: " + (err.message || "Falha"));
    } finally {
      setSearching(false);
    }
  };

  const handleImport = async (item: MLItem) => {
    if (importing.has(item.id) || imported.has(item.id)) return;

    setImporting((prev) => new Set(prev).add(item.id));
    try {
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
    const available = results.filter((r) => !imported.has(r.id));
    if (available.length === 0) {
      toast.info("Todos os produtos já foram importados.");
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

  // OAuth not connected state
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
          <p className="text-xs text-muted-foreground">
            Certifique-se de ter configurado <code className="bg-secondary px-1 py-0.5 rounded">VITE_ML_APP_ID</code> e os secrets da Edge Function.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
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

      {/* Search bar */}
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

      {/* Results */}
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

                return (
                  <motion.div
                    key={item.id}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className={`bg-card rounded-xl border border-border overflow-hidden transition-all ${isImported ? "opacity-60" : ""}`}
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
                          {item.sold_quantity > 0 && (
                            <span className="text-xs text-muted-foreground">{item.sold_quantity} vendidos</span>
                          )}
                          {item.shipping_free && (
                            <span className="text-xs bg-green-500/10 text-green-600 px-1.5 py-0.5 rounded">Frete grátis</span>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                      <button
                        onClick={() => handleImport(item)}
                        disabled={isImporting || isImported}
                        className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors ${
                          isImported
                            ? "bg-green-500/10 text-green-600 cursor-default"
                            : "bg-yellow-500 text-white hover:bg-yellow-600 disabled:opacity-50"
                        }`}
                      >
                        {isImported ? (
                          <><Check className="w-3.5 h-3.5" /> Importado</>
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

          {/* Pagination */}
          {paging && currentOffset + 20 < (paging.total || 0) && (
            <div className="flex justify-center">
              <button
                onClick={() => handleSearch(currentOffset + 20)}
                disabled={searching}
                className="px-6 py-2 rounded-lg border border-border text-sm hover:bg-secondary transition-colors disabled:opacity-50"
              >
                {searching ? "Carregando..." : "Carregar mais"}
              </button>
            </div>
          )}
        </div>
      )}

      {/* Sync Logs */}
      {syncLogs.length > 0 && (
        <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
          <div className="p-4 border-b border-border">
            <h3 className="font-display font-semibold text-foreground flex items-center gap-2">
              <Clock className="w-4 h-4 text-muted-foreground" />
              Histórico de Sincronizações
            </h3>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border bg-secondary">
                  <th className="text-left p-3 font-semibold text-foreground">Tipo</th>
                  <th className="text-center p-3 font-semibold text-foreground">Status</th>
                  <th className="text-center p-3 font-semibold text-foreground hidden sm:table-cell">Processados</th>
                  <th className="text-center p-3 font-semibold text-foreground hidden sm:table-cell">Atualizados</th>
                  <th className="text-right p-3 font-semibold text-foreground">Data</th>
                </tr>
              </thead>
              <tbody>
                {syncLogs.map((log: any) => (
                  <tr key={log.id} className="border-b border-border last:border-0 hover:bg-secondary/50">
                    <td className="p-3 capitalize text-foreground">{log.sync_type?.replace("_", " ")}</td>
                    <td className="p-3 text-center">
                      <span
                        className={`inline-flex items-center gap-1 text-xs px-2 py-0.5 rounded-full ${
                          log.status === "success"
                            ? "bg-green-500/10 text-green-600"
                            : log.status === "error"
                            ? "bg-destructive/10 text-destructive"
                            : "bg-yellow-500/10 text-yellow-600"
                        }`}
                      >
                        {log.status === "success" ? <Check className="w-3 h-3" /> : <AlertTriangle className="w-3 h-3" />}
                        {log.status}
                      </span>
                    </td>
                    <td className="p-3 text-center text-muted-foreground hidden sm:table-cell">{log.items_processed}</td>
                    <td className="p-3 text-center text-muted-foreground hidden sm:table-cell">{log.items_updated}</td>
                    <td className="p-3 text-right text-muted-foreground">
                      {log.created_at ? new Date(log.created_at).toLocaleString("pt-BR") : "-"}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminMercadoLivre;
