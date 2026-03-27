import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { BarChart3, Loader2, ExternalLink, X, Trophy, TrendingDown } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";

interface PriceResult {
  platform: string;
  products: {
    id: string;
    title: string;
    price: number;
    original_price: number | null;
    store: string;
    platform: string;
    image_url: string;
    affiliate_url: string;
    isCurrent: boolean;
  }[];
  cheapestPrice: number;
}

interface PriceComparatorProps {
  productId: string;
  productTitle: string;
  open: boolean;
  onClose: () => void;
}

const PriceComparator = ({ productId, productTitle, open, onClose }: PriceComparatorProps) => {
  const [loading, setLoading] = useState(false);
  const [results, setResults] = useState<PriceResult[]>([]);
  const [cheapestPlatform, setCheapestPlatform] = useState<string | null>(null);
  const [cheapestPrice, setCheapestPrice] = useState<number | null>(null);
  const [currentProduct, setCurrentProduct] = useState<any>(null);

  const handleCompare = async () => {
    setLoading(true);
    setResults([]);
    try {
      const { data, error } = await supabase.functions.invoke("compare-prices", {
        body: { productId },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);
      setResults(data.results || []);
      setCheapestPlatform(data.cheapestPlatform);
      setCheapestPrice(data.cheapestPrice);
      setCurrentProduct(data.currentProduct);
      if (data.results?.length === 0) {
        toast.info("Nenhum produto similar encontrado em outras plataformas.");
      }
    } catch (err: any) {
      toast.error(err.message || "Erro ao comparar preços");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <BarChart3 className="w-5 h-5 text-accent" />
            Comparador de Preços
          </DialogTitle>
        </DialogHeader>

        <div className="p-3 rounded-lg bg-secondary border border-border">
          <p className="font-medium text-sm text-foreground line-clamp-2">{productTitle}</p>
          {currentProduct && (
            <p className="text-xs text-muted-foreground mt-1">
              {currentProduct.platform} • R$ {Number(currentProduct.price).toFixed(2).replace(".", ",")}
            </p>
          )}
        </div>

        <button
          onClick={handleCompare}
          disabled={loading}
          className="btn-accent w-full flex items-center justify-center gap-2 py-3"
        >
          {loading ? (
            <><Loader2 className="w-4 h-4 animate-spin" /> Comparando...</>
          ) : (
            <><BarChart3 className="w-4 h-4" /> {results.length > 0 ? "Comparar Novamente" : "Comparar Preços"}</>
          )}
        </button>

        <AnimatePresence>
          {results.length > 0 && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-4"
            >
              {/* Summary */}
              {cheapestPlatform && cheapestPrice && (
                <div className="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/20">
                  <div className="flex items-center gap-2 text-emerald-600">
                    <Trophy className="w-5 h-5" />
                    <span className="font-semibold text-sm">
                      Menor preço: R$ {cheapestPrice.toFixed(2).replace(".", ",")} na {cheapestPlatform}
                    </span>
                  </div>
                </div>
              )}

              {/* Platform groups */}
              {results.map((group, gi) => (
                <div key={gi} className="rounded-xl border border-border overflow-hidden">
                  <div className={`px-4 py-2.5 flex items-center justify-between ${gi === 0 ? "bg-emerald-500/10" : "bg-secondary"}`}>
                    <span className="font-semibold text-sm flex items-center gap-2">
                      {gi === 0 && <Trophy className="w-4 h-4 text-emerald-500" />}
                      {group.platform}
                    </span>
                    <span className="text-xs font-medium text-muted-foreground">
                      A partir de R$ {group.cheapestPrice.toFixed(2).replace(".", ",")}
                    </span>
                  </div>
                  <div className="divide-y divide-border">
                    {group.products.map((p, pi) => (
                      <div key={pi} className={`flex items-center gap-3 p-3 ${p.isCurrent ? "bg-accent/5 border-l-2 border-accent" : ""}`}>
                        {p.image_url && (
                          <img src={p.image_url} alt="" className="w-10 h-10 rounded-lg object-cover bg-secondary shrink-0" />
                        )}
                        <div className="flex-1 min-w-0">
                          <p className="text-xs text-foreground line-clamp-1">{p.title}</p>
                          <div className="flex items-center gap-2 mt-0.5">
                            <span className="text-sm font-bold text-accent">
                              R$ {p.price.toFixed(2).replace(".", ",")}
                            </span>
                            {p.original_price && (
                              <span className="text-xs text-muted-foreground line-through">
                                R$ {p.original_price.toFixed(2).replace(".", ",")}
                              </span>
                            )}
                            {p.isCurrent && (
                              <span className="text-[10px] px-1.5 py-0.5 rounded-full bg-accent/10 text-accent font-medium">Atual</span>
                            )}
                          </div>
                        </div>
                        <a href={p.affiliate_url} target="_blank" rel="noopener noreferrer" className="p-2 rounded-lg hover:bg-secondary transition-colors shrink-0">
                          <ExternalLink className="w-4 h-4 text-muted-foreground" />
                        </a>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </DialogContent>
    </Dialog>
  );
};

export default PriceComparator;
