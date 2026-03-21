import { useState, useEffect } from "react";
import { Search, Download, RefreshCw, Loader2, ExternalLink, Check, Package } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";

interface MLItem {
  id: string; title: string; price: number; original_price: number | null;
  currency_id: string; thumbnail: string; permalink: string; condition: string;
  sold_quantity: number; available_quantity: number; seller: { id: number; nickname: string };
  category_id: string; shipping_free: boolean; already_imported?: boolean;
}

const AdminMercadoLivre = () => {
  const { user } = useAuth();
  const qc = useQueryClient();

  // RECUPERAR ESTADO DA MEMÓRIA DA SESSÃO
  const [keyword, setKeyword] = useState(() => sessionStorage.getItem('ml_keyword') || "");
  const [results, setResults] = useState<MLItem[]>(() => {
    const saved = sessionStorage.getItem('ml_results');
    return saved ? JSON.parse(saved) : [];
  });
  const [currentOffset, setCurrentOffset] = useState(() => parseInt(sessionStorage.getItem('ml_offset') || "0"));

  const [searching, setSearching] = useState(false);
  const [importing, setImporting] = useState<Set<string>>(new Set());
  const [imported, setImported] = useState<Set<string>>(() => {
    const saved = sessionStorage.getItem('ml_imported');
    return saved ? new Set(JSON.parse(saved)) : new Set();
  });
  const [syncing, setSyncing] = useState(false);

  // SALVAR ESTADO SEMPRE QUE HOUVER MUDANÇA
  useEffect(() => {
    sessionStorage.setItem('ml_keyword', keyword);
    sessionStorage.setItem('ml_results', JSON.stringify(results));
    sessionStorage.setItem('ml_offset', currentOffset.toString());
    sessionStorage.setItem('ml_imported', JSON.stringify(Array.from(imported)));
  }, [keyword, results, currentOffset, imported]);

  const { data: mappingsCount = 0 } = useQuery({
    queryKey: ["ml_mappings_count"],
    queryFn: async () => {
      const { count } = await supabase.from("ml_product_mappings").select("id", { count: "exact", head: true });
      return count || 0;
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

  const handleBatchSync = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("ml-batch-sync", { body: { userId: user?.id } });
      if (error || data?.error) throw error || new Error(data?.error);
      toast.success(`Sincronização concluída!`);
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
        <div className="flex items-center gap-2">
          <span className="text-xs bg-secondary px-3 py-1.5 rounded-full text-muted-foreground">{mappingsCount} mapeados</span>
          <button onClick={handleBatchSync} disabled={syncing} className="flex items-center gap-2 text-sm px-4 py-2 rounded-lg bg-yellow-500 text-white hover:bg-yellow-600 disabled:opacity-50">
            {syncing ? <Loader2 className="w-4 h-4 animate-spin" /> : <RefreshCw className="w-4 h-4" />} Sincronizar Preços
          </button>
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
                        <div className="font-bold text-sm mt-2">R$ {Number(item.price).toFixed(2).replace(".", ",")}</div>
                        {item.shipping_free && <span className="text-xs bg-green-500/10 text-green-600 px-1.5 py-0.5 rounded mt-1 inline-block">Frete grátis</span>}
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
    </div>
  );
};

export default AdminMercadoLivre;