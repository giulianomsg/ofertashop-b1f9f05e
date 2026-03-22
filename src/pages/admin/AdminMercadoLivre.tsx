import { useState, useEffect } from "react";
import { Search, Download, RefreshCw, Loader2, ExternalLink, Check, Package } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";

interface MLItem {
  id: string; title: string; price: number; original_price: number | null;
  currency_id: string; thumbnail: string; permalink: string; condition: string;
  sold_quantity: number; available_quantity: number; seller: { id: number | string; nickname: string };
  category_id: string; shipping_free: boolean; already_imported?: boolean;
  description?: string; rating?: number; reviewCount?: number;
}
/* ... logic remains exactly the same ... */
const AdminMercadoLivre = () => {
  const { user } = useAuth();
  const qc = useQueryClient();

  // Estados Limpos (Sem cache do navegador, a pedido)
  const [keyword, setKeyword] = useState("");
  const [results, setResults] = useState<MLItem[]>([]);
  const [currentOffset, setCurrentOffset] = useState(0);

  const [searching, setSearching] = useState(false);
  const [importing, setImporting] = useState<Set<string>>(new Set());
  const [imported, setImported] = useState<Set<string>>(new Set());
  const [syncing, setSyncing] = useState(false);
  const [authorizing, setAuthorizing] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const code = params.get("code");
    if (code) {
      setAuthorizing(true);
      // Remove code from URL
      window.history.replaceState({}, document.title, window.location.pathname);
      supabase.functions.invoke("ml-auth", {
        body: { code, redirect_uri: window.location.origin + window.location.pathname }
      }).then(({ data, error }) => {
        setAuthorizing(false);
        if (error || !data?.success) {
          toast.error("Erro na Autorização", { description: error?.message || data?.error });
        } else {
          toast.success("Sucesso!", { description: "Autorização do Mercado Livre renovada." });
        }
      });
    }
  }, [toast]);

  const { data: mappingsCount = 0 } = useQuery({
    queryKey: ["ml_mappings_count"],
    queryFn: async () => {
      const { count } = await supabase.from("ml_product_mappings").select("id", { count: "exact", head: true });
      return count || 0;
    },
  });

  const { data: mappingsList = [], isLoading: loadingMappings } = useQuery({
    queryKey: ["ml_mappings_list"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("ml_product_mappings")
        .select("*, products(id, title, price, badge, image_url, is_active)")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

  const handleSearch = async (offset = 0) => {
    if (!keyword.trim()) return toast.error("Digite uma palavra-chave.");

    // Se for uma busca nova, zera os resultados anteriores
    if (offset === 0) setResults([]);
    setSearching(true);

    try {
      const { data, error } = await supabase.functions.invoke("ml-search-products", {
        body: { keyword: keyword.trim(), offset },
      });

      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      const items = data.results || [];
      if (items.length === 0) toast.warning("Nenhum produto encontrado.");

      setResults(offset === 0 ? items : [...results, ...items]);
      setCurrentOffset(offset);

      const newlyImported = new Set(imported);
      items.forEach((item: MLItem) => { if (item.already_imported) newlyImported.add(item.id); });
      setImported(newlyImported);

    } catch (err: any) {
      toast.error(err.message || "A busca falhou.");
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
      if (data?.error && !data.product_id) throw new Error(data.error);

      toast.success(`"${item.title?.slice(0, 30)}..." importado!`);
      setImported((prev) => new Set(prev).add(item.id));
      qc.invalidateQueries({ queryKey: ["products"] });
      qc.invalidateQueries({ queryKey: ["ml_mappings_count"] });
    } catch (err: any) {
      toast.error("Erro ao importar: " + (err.message || "Falha"));
    } finally {
      setImporting((prev) => { const s = new Set(prev); s.delete(item.id); return s; });
    }
  };

  const handleOAuthRedirect = async () => {
    try {
      setAuthorizing(true);
      const redirectUri = window.location.origin + window.location.pathname;
      const { data, error } = await supabase.functions.invoke("ml-auth", {
        body: { action: "auth_url", redirect_uri: redirectUri }
      });
      if (error) throw error;
      if (data?.url) {
        window.location.href = data.url;
      }
    } catch (error: any) {
      console.error(error);
      toast.error("Erro", { description: "Não foi possível gerar a URL de autorização." });
      setAuthorizing(false);
    }
  };

  const handleSyncAll = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("ml-batch-sync", { body: { userId: user?.id } });
      if (error || data?.error) throw error || new Error(data?.error);
      toast.success(`Sincronização concluída!`);
      
      if (data?.debug_trace) {
        console.group("=== ML BATCH SYNC DEBUG TRACE ===");
        console.log(data.debug_trace);
        console.groupEnd();
      }

      qc.invalidateQueries({ queryKey: ["ml_mappings_list"] });
    } catch (err: any) {
      toast.error("Erro na sincronização.");
    } finally {
      setSyncing(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="font-display font-bold text-xl text-foreground flex items-center gap-2">
            <Package className="w-5 h-5 text-yellow-500" /> Mercado Livre
          </h2>
          <p className="text-sm text-muted-foreground mt-1">Busque e importe via API de extração cacheada.</p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs bg-secondary px-3 py-1.5 rounded-full text-muted-foreground">{mappingsCount} mapeados</span>
          <div className="flex gap-2 w-full md:w-auto">
            {mappingsCount > 0 && (
              <Button variant="outline" onClick={handleSyncAll} disabled={syncing}>
                {syncing ? <RefreshCw className="mr-2 h-4 w-4 animate-spin" /> : <RefreshCw className="mr-2 h-4 w-4" />}
                Sincronizar Preços
              </Button>
            )}
            <Button variant="outline" onClick={handleOAuthRedirect} disabled={authorizing}>
              {authorizing ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <ExternalLink className="mr-2 h-4 w-4" />}
              Renovar Autorização API
            </Button>
          </div>
        </div>
      </div>

      <div className="bg-card rounded-xl border border-border p-4 shadow-sm">
        <div className="flex gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
            <input
              value={keyword}
              onChange={(e) => setKeyword(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleSearch(0)}
              placeholder="Ex: Tênis Nike, iPhone 15"
              className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm focus:ring-2 focus:ring-yellow-500/30 outline-none"
            />
          </div>
          <button onClick={() => handleSearch(0)} disabled={searching} className="h-10 px-5 rounded-lg bg-yellow-500 text-white font-semibold hover:bg-yellow-600 disabled:opacity-50 flex items-center gap-2">
            {searching && results.length === 0 ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />} Buscar
          </button>
        </div>
      </div>

      {results.length > 0 && (
        <div className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            <AnimatePresence>
              {results.map((item) => {
                const isImporting = importing.has(item.id);
                const isImported = imported.has(item.id);

                return (
                  <motion.div key={item.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className={`bg-card rounded-xl border border-border overflow-hidden ${isImported ? "opacity-60" : ""}`}>
                    <div className="flex gap-3 p-4">
                      <div className="w-20 h-20 rounded-lg bg-secondary shrink-0">
                        {item.thumbnail && <img src={item.thumbnail} className="w-full h-full object-cover rounded-lg" />}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-sm line-clamp-2">{item.title}</h4>
                        <div className="font-bold text-sm mt-1.5">R$ {Number(item.price).toFixed(2).replace(".", ",")}</div>
                        
                        <div className="text-xs text-muted-foreground mt-1.5 flex flex-wrap gap-1.5">
                          {item.seller?.nickname && item.seller.nickname !== "Vendedor Local" && (
                            <span className="bg-secondary px-1.5 py-0.5 rounded border shadow-sm break-all">{item.seller.nickname}</span>
                          )}
                          {item.condition === 'new' ? (
                            <span className="bg-blue-500/10 text-blue-600 px-1.5 py-0.5 rounded border border-blue-500/20">Novo</span>
                          ) : item.condition === 'used' ? (
                            <span className="bg-orange-500/10 text-orange-600 px-1.5 py-0.5 rounded border border-orange-500/20">Usado</span>
                          ) : item.condition === 'refurbished' ? (
                            <span className="bg-purple-500/10 text-purple-600 px-1.5 py-0.5 rounded border border-purple-500/20">Recondicionado</span>
                          ) : null}
                          {item.sold_quantity > 0 && (
                            <span className="bg-secondary px-1.5 py-0.5 rounded border shadow-sm">{item.sold_quantity}+ vend.</span>
                          )}
                          {item.rating ? (
                            <span className="bg-yellow-500/10 text-yellow-600 px-1.5 py-0.5 rounded border border-yellow-500/20 flex items-center gap-1">
                              ⭐ {item.rating} {item.reviewCount ? `(${item.reviewCount})` : ''}
                            </span>
                          ) : null}
                        </div>

                        {item.description && (
                          <p className="text-xs text-muted-foreground mt-2 line-clamp-2" title={item.description}>
                            {item.description}
                          </p>
                        )}

                        {item.shipping_free && (
                           <span className="text-xs bg-green-500/10 text-green-600 px-1.5 py-0.5 rounded mt-2 inline-block border border-green-500/20">
                             Frete grátis
                           </span>
                        )}
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                      <button onClick={() => handleImport(item)} disabled={isImporting || isImported} className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 ${isImported ? "bg-green-500/10 text-green-600" : "bg-yellow-500 text-white hover:bg-yellow-600 disabled:opacity-50"}`}>
                        {isImported ? <><Check className="w-3.5 h-3.5" /> Importado</> : isImporting ? <><Loader2 className="w-3.5 h-3.5 animate-spin" /> Importando</> : <><Download className="w-3.5 h-3.5" /> Importar</>}
                      </button>
                      <a href={item.permalink} target="_blank" className="h-9 w-9 border rounded-lg flex items-center justify-center hover:bg-secondary"><ExternalLink className="w-3.5 h-3.5" /></a>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>
          <div className="flex justify-center mt-6">
            <button onClick={() => handleSearch(currentOffset + 50)} disabled={searching} className="px-6 py-2 border rounded-lg hover:bg-secondary flex gap-2">
              {searching ? <><Loader2 className="w-4 h-4 animate-spin" /> Carregando...</> : "Carregar Próxima Página"}
            </button>
          </div>
        </div>
      )}

      {mappingsList.length > 0 && !searching && results.length === 0 && (
        <div className="mt-8">
          <h3 className="font-display font-bold text-lg mb-4 text-foreground">Produtos Sincronizados ({mappingsCount})</h3>
          <div className="bg-card rounded-xl border border-border shadow-sm divide-y divide-border">
            {mappingsList.map((m: any) => (
              <div key={m.id} className="flex flex-col sm:flex-row gap-4 p-4 items-start sm:items-center hover:bg-secondary/40 transition-colors">
                 <div className="w-14 h-14 bg-secondary rounded-lg shrink-0 border">
                   {m.products?.image_url && <img src={m.products.image_url} className="w-full h-full object-cover rounded-lg" />}
                 </div>
                 <div className="flex-1 min-w-0">
                   <p className="text-sm font-medium line-clamp-2">{m.products?.title}</p>
                   <div className="flex flex-wrap gap-2 text-xs text-muted-foreground mt-1.5 items-center">
                     <span className="font-mono bg-blue-500/10 text-blue-600 px-1.5 py-0.5 rounded border border-blue-500/20">ID: {m.ml_item_id}</span>
                     <span className="bg-secondary px-1.5 py-0.5 rounded border">Status ML: {m.ml_status}</span>
                     {m.ml_sold_quantity > 0 && <span className="bg-secondary px-1.5 py-0.5 rounded border">Vendeu: {m.ml_sold_quantity}</span>}
                     {m.ml_condition && <span className="uppercase bg-secondary px-1.5 py-0.5 rounded border">{m.ml_condition}</span>}
                   </div>
                 </div>
                 <div className="text-right w-full sm:w-auto flex sm:flex-col justify-between sm:justify-center items-center sm:items-end gap-2">
                   <div className="text-sm font-bold">R$ {Number(m.products?.price || m.ml_current_price).toFixed(2).replace('.', ',')}</div>
                   {m.products?.is_active ? <span className="text-xs font-medium text-green-600 bg-green-500/10 px-2 py-0.5 rounded border border-green-500/20">Site Ativo</span> : <span className="text-xs font-medium text-red-600 bg-red-500/10 px-2 py-0.5 rounded border border-red-500/20">Site Inativo</span>}
                 </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminMercadoLivre;