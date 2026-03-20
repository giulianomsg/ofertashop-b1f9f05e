import { useState } from "react";
import { Search, Download, RefreshCw, Loader2, ExternalLink, Check, Clock, AlertTriangle, Package } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";

interface ShopeeOffer {
  itemId: string;
  shopId: string;
  productName: string;
  priceMin: number;
  priceMax: number;
  imageUrl: string;
  productLink: string;
  commission: number;
  commissionRate: number;
  sales: number;
  ratingStar: number;
  shopName: string;
  offerLink: string;
  shopeeShortLink: string;
  already_imported?: boolean;
}

const AdminShopee = () => {
  const { user } = useAuth();
  const qc = useQueryClient();

  // Search state
  const [keyword, setKeyword] = useState("");
  const [searching, setSearching] = useState(false);
  const [offers, setOffers] = useState<ShopeeOffer[]>([]);
  const [pageInfo, setPageInfo] = useState<any>(null);
  const [currentPage, setCurrentPage] = useState(1);

  // Import state
  const [importing, setImporting] = useState<Set<string>>(new Set());
  const [imported, setImported] = useState<Set<string>>(new Set());

  // Batch sync state
  const [syncing, setSyncing] = useState(false);

  // Sync logs
  const { data: syncLogs = [] } = useQuery({
    queryKey: ["shopee_sync_logs"],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from("shopee_sync_logs")
        .select("*")
        .order("created_at", { ascending: false })
        .limit(20);
      if (error) throw error;
      return data;
    },
  });

  // Mapped products count
  const { data: mappingsCount = 0 } = useQuery({
    queryKey: ["shopee_mappings_count"],
    queryFn: async () => {
      const { count, error } = await (supabase as any)
        .from("shopee_product_mappings")
        .select("id", { count: "exact", head: true })
        .eq("sync_status", "active");
      if (error) throw error;
      return count || 0;
    },
  });

  const handleSearch = async (page = 1) => {
    if (!keyword.trim()) {
      toast.error("Digite uma palavra-chave para buscar.");
      return;
    }
    setSearching(true);
    try {
      const { data, error } = await supabase.functions.invoke("shopee-search-offers", {
        body: { keyword: keyword.trim(), page, limit: 20 },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      setOffers(data.offers || []);
      setPageInfo(data.pageInfo || null);
      setCurrentPage(page);

      // Mark already imported
      const alreadyImported = new Set<string>(
        (data.offers || []).filter((o: ShopeeOffer) => o.already_imported).map((o: ShopeeOffer) => String(o.itemId))
      );
      setImported(alreadyImported);
    } catch (err: any) {
      toast.error("Erro na busca: " + (err.message || "Falha"));
    } finally {
      setSearching(false);
    }
  };

  const handleImport = async (offer: ShopeeOffer) => {
    const itemId = String(offer.itemId);
    if (importing.has(itemId) || imported.has(itemId)) return;

    setImporting((prev) => new Set(prev).add(itemId));
    try {
      const { data, error } = await supabase.functions.invoke("shopee-import-product", {
        body: { offer, userId: user?.id },
      });
      if (error) throw error;
      if (data?.error) {
        if (data?.product_id) {
          toast.info("Produto já estava importado.");
          setImported((prev) => new Set(prev).add(itemId));
        } else {
          throw new Error(data.error);
        }
      } else {
        toast.success(`"${offer.productName?.slice(0, 40)}..." importado!`);
        setImported((prev) => new Set(prev).add(itemId));
        qc.invalidateQueries({ queryKey: ["products"] });
        qc.invalidateQueries({ queryKey: ["shopee_mappings_count"] });
      }
    } catch (err: any) {
      toast.error("Erro ao importar: " + (err.message || "Falha"));
    } finally {
      setImporting((prev) => {
        const s = new Set(prev);
        s.delete(itemId);
        return s;
      });
    }
  };

  const handleImportAll = async () => {
    const available = offers.filter((o) => !imported.has(String(o.itemId)));
    if (available.length === 0) {
      toast.info("Todos os produtos já foram importados.");
      return;
    }
    for (const offer of available) {
      await handleImport(offer);
    }
  };

  const handleBatchSync = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("shopee-batch-sync", {
        body: { userId: user?.id },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      toast.success(
        `Sincronização concluída! ${data.total} processados, ${data.updated} atualizados, ${data.deactivated} desativados.`
      );
      qc.invalidateQueries({ queryKey: ["shopee_sync_logs"] });
      qc.invalidateQueries({ queryKey: ["shopee_mappings_count"] });
      qc.invalidateQueries({ queryKey: ["products"] });
    } catch (err: any) {
      toast.error("Erro na sincronização: " + (err.message || "Falha"));
    } finally {
      setSyncing(false);
    }
  };

  const formatPrice = (microPrice: number) => {
    const price = microPrice / 100000;
    return price > 0 ? `R$ ${price.toFixed(2).replace(".", ",")}` : "N/A";
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="font-display font-bold text-xl text-foreground flex items-center gap-2">
            <Package className="w-5 h-5 text-accent" />
            Shopee Affiliate
          </h2>
          <p className="text-sm text-muted-foreground mt-1">
            Busque, importe e sincronize produtos da Shopee automaticamente.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-xs bg-secondary px-3 py-1.5 rounded-full text-muted-foreground">
            {mappingsCount} produtos mapeados
          </span>
          <button
            onClick={handleBatchSync}
            disabled={syncing}
            className="flex items-center gap-2 text-sm px-4 py-2 rounded-lg bg-accent text-accent-foreground hover:bg-accent/90 transition-colors disabled:opacity-50"
          >
            {syncing ? <Loader2 className="w-4 h-4 animate-spin" /> : <RefreshCw className="w-4 h-4" />}
            {syncing ? "Sincronizando..." : "Sincronizar Preços"}
          </button>
        </div>
      </div>

      {/* Search bar */}
      <div className="bg-card rounded-xl border border-border p-4" style={{ boxShadow: "var(--shadow-card)" }}>
        <div className="flex gap-2">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
            <input
              value={keyword}
              onChange={(e) => setKeyword(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleSearch(1)}
              placeholder="Buscar ofertas na Shopee... (ex: fone bluetooth, smartwatch)"
              className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
            />
          </div>
          <button
            onClick={() => handleSearch(1)}
            disabled={searching}
            className="h-10 px-5 rounded-lg bg-accent text-accent-foreground text-sm font-semibold hover:bg-accent/90 disabled:opacity-50 transition-colors flex items-center gap-2"
          >
            {searching ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />}
            Buscar
          </button>
        </div>
      </div>

      {/* Results */}
      {offers.length > 0 && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted-foreground">{offers.length} ofertas encontradas</span>
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
              {offers.map((offer) => {
                const itemId = String(offer.itemId);
                const isImporting = importing.has(itemId);
                const isImported = imported.has(itemId);

                return (
                  <motion.div
                    key={itemId}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className={`bg-card rounded-xl border border-border overflow-hidden transition-all ${isImported ? "opacity-60" : ""}`}
                    style={{ boxShadow: "var(--shadow-card)" }}
                  >
                    <div className="flex gap-3 p-4">
                      <div className="w-20 h-20 rounded-lg bg-secondary overflow-hidden shrink-0">
                        {offer.imageUrl ? (
                          <img src={offer.imageUrl} alt={offer.productName} className="w-full h-full object-cover" />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center text-muted-foreground">
                            <Package className="w-6 h-6" />
                          </div>
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-sm text-foreground line-clamp-2 leading-tight">
                          {offer.productName}
                        </h4>
                        <p className="text-xs text-muted-foreground mt-1">{offer.shopName}</p>
                        <div className="flex items-center gap-3 mt-2">
                          <span className="font-bold text-sm text-foreground">{formatPrice(offer.priceMin)}</span>
                          {offer.priceMax > offer.priceMin && (
                            <span className="text-xs text-muted-foreground line-through">
                              {formatPrice(offer.priceMax)}
                            </span>
                          )}
                        </div>
                        <div className="flex items-center gap-2 mt-1.5 flex-wrap">
                          {offer.commissionRate > 0 && (
                            <span className="text-xs bg-accent/10 text-accent px-1.5 py-0.5 rounded">
                              {Number(offer.commissionRate).toFixed(1)}% comissão
                            </span>
                          )}
                          {offer.ratingStar > 0 && (
                            <span className="text-xs text-muted-foreground">⭐ {Number(offer.ratingStar).toFixed(1)}</span>
                          )}
                          {offer.sales > 0 && (
                            <span className="text-xs text-muted-foreground">{offer.sales} vendas</span>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                      <button
                        onClick={() => handleImport(offer)}
                        disabled={isImporting || isImported}
                        className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors ${
                          isImported
                            ? "bg-success/10 text-success cursor-default"
                            : "bg-accent text-accent-foreground hover:bg-accent/90 disabled:opacity-50"
                        }`}
                      >
                        {isImported ? (
                          <>
                            <Check className="w-3.5 h-3.5" /> Importado
                          </>
                        ) : isImporting ? (
                          <>
                            <Loader2 className="w-3.5 h-3.5 animate-spin" /> Importando...
                          </>
                        ) : (
                          <>
                            <Download className="w-3.5 h-3.5" /> Importar
                          </>
                        )}
                      </button>
                      {offer.productLink && (
                        <a
                          href={offer.productLink}
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
          {pageInfo?.hasNextPage && (
            <div className="flex justify-center">
              <button
                onClick={() => handleSearch(currentPage + 1)}
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
                  <th className="text-center p-3 font-semibold text-foreground hidden md:table-cell">Desativados</th>
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
                            ? "bg-success/10 text-success"
                            : log.status === "error"
                            ? "bg-destructive/10 text-destructive"
                            : "bg-warning/10 text-warning"
                        }`}
                      >
                        {log.status === "error" && <AlertTriangle className="w-3 h-3" />}
                        {log.status}
                      </span>
                    </td>
                    <td className="p-3 text-center text-muted-foreground hidden sm:table-cell">{log.items_processed || 0}</td>
                    <td className="p-3 text-center text-muted-foreground hidden sm:table-cell">{log.items_updated || 0}</td>
                    <td className="p-3 text-center text-muted-foreground hidden md:table-cell">{log.items_deactivated || 0}</td>
                    <td className="p-3 text-right text-xs text-muted-foreground">
                      {new Date(log.created_at).toLocaleString("pt-BR", { dateStyle: "short", timeStyle: "short" })}
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

export default AdminShopee;
