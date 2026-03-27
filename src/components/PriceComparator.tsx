import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { BarChart3, Loader2, ExternalLink, Trophy, Sparkles, ThumbsUp, ThumbsDown, Lightbulb } from "lucide-react";
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

interface AIAnalysis {
  is_good_deal: boolean;
  verdict: string;
  recommendation: string;
  best_platform: string;
  savings_tip: string;
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
  const [aiAnalysis, setAiAnalysis] = useState<AIAnalysis | null>(null);

  const handleCompare = async () => {
    setLoading(true);
    setResults([]);
    setAiAnalysis(null);
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
      setAiAnalysis(data.aiAnalysis || null);
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
            <><Loader2 className="w-4 h-4 animate-spin" /> Analisando com IA...</>
          ) : (
            <><Sparkles className="w-4 h-4" /> {results.length > 0 ? "Comparar Novamente" : "Comparar Preços com IA"}</>
          )}
        </button>

        <AnimatePresence>
          {(results.length > 0 || aiAnalysis) && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-4"
            >
              {/* AI Analysis Card */}
              {aiAnalysis && (
                <motion.div
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  className={`p-4 rounded-xl border ${
                    aiAnalysis.is_good_deal
                      ? "bg-emerald-500/10 border-emerald-500/20"
                      : "bg-amber-500/10 border-amber-500/20"
                  }`}
                >
                  <div className="flex items-start gap-3">
                    <div className={`p-2 rounded-lg shrink-0 ${aiAnalysis.is_good_deal ? "bg-emerald-500/20" : "bg-amber-500/20"}`}>
                      {aiAnalysis.is_good_deal
                        ? <ThumbsUp className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
                        : <ThumbsDown className="w-5 h-5 text-amber-600 dark:text-amber-400" />
                      }
                    </div>
                    <div className="space-y-2 flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <Sparkles className="w-3.5 h-3.5 text-accent shrink-0" />
                        <p className={`text-sm font-bold ${aiAnalysis.is_good_deal ? "text-emerald-700 dark:text-emerald-300" : "text-amber-700 dark:text-amber-300"}`}>
                          {aiAnalysis.verdict}
                        </p>
                      </div>
                      <p className="text-xs text-foreground/80 leading-relaxed">{aiAnalysis.recommendation}</p>
                      {aiAnalysis.savings_tip && (
                        <div className="flex items-start gap-1.5 mt-1">
                          <Lightbulb className="w-3.5 h-3.5 text-accent shrink-0 mt-0.5" />
                          <p className="text-[11px] text-muted-foreground italic">{aiAnalysis.savings_tip}</p>
                        </div>
                      )}
                    </div>
                  </div>
                </motion.div>
              )}

              {/* Cheapest summary */}
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
