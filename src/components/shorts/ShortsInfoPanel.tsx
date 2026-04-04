import { useState, useEffect, useRef } from "react";
import { X, TrendingUp, Tag as TagIcon, Loader2, Copy, CheckCircle2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";

interface Props {
  productId: string;
  productTitle: string;
  open: boolean;
  onClose: () => void;
}

const ShortsInfoPanel = ({ productId, productTitle, open, onClose }: Props) => {
  const [history, setHistory] = useState<{price: number, date: string}[]>([]);
  const [coupons, setCoupons] = useState<{id: string, code: string, discount_value: string | number, description: string | null}[]>([]);
  const [loading, setLoading] = useState(false);
  const [copiedCoupon, setCopiedCoupon] = useState<string | null>(null);
  const panelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    setLoading(true);

    const fetchData = async () => {
      const [histRes, coupRes] = await Promise.all([
        supabase
          .from("price_history" as any)
          .select("price, created_at")
          .eq("product_id", productId)
          .order("created_at", { ascending: true }),
        supabase
          .from("coupons" as any)
          .select("*")
          .eq("active", true) // Corrigindo para a coluna correta de cupom ativo
          .limit(5)
      ]);

      if (histRes.data && Array.isArray(histRes.data)) {
        const rawHistory = histRes.data as unknown as { price: number, created_at: string }[];
        const formatted = rawHistory.map((item) => ({
          price: item.price,
          date: new Date(item.created_at).toLocaleDateString("pt-BR", { day: '2-digit', month: 'short' })
        }));
        setHistory(formatted);
      }
      
      if (coupRes.data && Array.isArray(coupRes.data)) {
        setCoupons(coupRes.data as unknown as {id: string, code: string, discount_value: string | number, description: string | null}[]);
      }
      setLoading(false);
    };

    fetchData();
  }, [open, productId]);

  const handleCopyCoupon = (code: string) => {
    navigator.clipboard.writeText(code);
    setCopiedCoupon(code);
    toast.success("Cupom copiado!");
    setTimeout(() => setCopiedCoupon(null), 2000);
  };

  const handleBackdropClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget) onClose();
  };

  const formatCurrency = (val: number) =>
    val.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.2 }}
          className="absolute inset-0 z-50 flex items-end"
          onClick={handleBackdropClick}
        >
          <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />

          <motion.div
            ref={panelRef}
            initial={{ x: "100%" }}
            animate={{ x: 0 }}
            exit={{ x: "100%" }}
            transition={{ type: "spring", damping: 28, stiffness: 300 }}
            className="relative z-10 w-full md:w-[85%] ml-auto h-full rounded-l-3xl bg-zinc-900 border-l border-white/10 flex flex-col"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Header */}
            <div className="flex items-center justify-between px-5 py-4 border-b border-white/10 shrink-0 mt-6">
              <div className="flex items-center gap-2">
                <TagIcon className="h-5 w-5 text-[hsl(24,95%,55%)]" />
                <h2 className="text-base font-semibold text-white whitespace-nowrap overflow-hidden text-ellipsis max-w-[200px]">
                  Ofertas & Preços
                </h2>
              </div>
              <button
                onClick={onClose}
                className="flex h-8 w-8 items-center justify-center rounded-full bg-white/10 text-white hover:bg-white/20 transition-colors"
                aria-label="Fechar painel"
              >
                <X className="h-4 w-4" />
              </button>
            </div>

            {/* Container scrolável */}
            <div className="flex-1 overflow-y-auto px-5 py-6 space-y-8 scrollbar-thin scrollbar-thumb-white/10">
              {loading ? (
                <div className="flex justify-center p-10">
                  <Loader2 className="h-8 w-8 animate-spin text-[hsl(24,95%,55%)]" />
                </div>
              ) : (
                <>
                  {/* Gráfico do Histórico */}
                  <div className="space-y-4">
                    <h3 className="text-sm font-medium text-white/80 flex items-center gap-2">
                      <TrendingUp className="h-4 w-4" /> Histórico de Preço
                    </h3>
                    {history.length > 1 ? (
                      <div className="w-full bg-black/20 rounded-xl p-4 border border-white/5">
                        <div className="flex items-end justify-between h-[120px] gap-2">
                          {history.map((h, idx) => {
                            // Calcula tamanho da barra na mão
                            const maxPrice = Math.max(...history.map(item => item.price));
                            const heightPercentage = Math.max((h.price / maxPrice) * 100, 10); // minimo 10%

                            return (
                              <div key={idx} className="relative flex flex-col items-center flex-1 group">
                                <div className="w-full max-w-[24px] rounded-t-sm" style={{ height: `${heightPercentage}%`, backgroundColor: "hsl(24,95%,55%)", opacity: 0.8 }} />
                                <span className="text-[9px] text-white/50 mt-1.5 whitespace-nowrap overflow-hidden text-ellipsis w-full text-center">
                                  {h.date.split('/')[0]}/{h.date.split('/')[1]}
                                </span>
                                {/* Mini tooltip na barra (puro css hover) */}
                                <div className="absolute bottom-full mb-1 opacity-0 group-hover:opacity-100 transition-opacity bg-zinc-800 text-xs px-2 py-1 rounded border border-white/10 pointer-events-none whitespace-nowrap z-10 font-medium pb-1.5">
                                  {formatCurrency(h.price)}
                                </div>
                              </div>
                            );
                          })}
                        </div>
                      </div>
                    ) : (
                      <div className="bg-black/20 rounded-xl p-6 border border-white/5 text-center">
                        <p className="text-xs text-white/40">Gráfico indisponível (poucos dados no histórico).</p>
                      </div>
                    )}
                  </div>

                  {/* Cupons disponíveis */}
                  <div className="space-y-4 pb-6">
                    <h3 className="text-sm font-medium text-white/80 flex items-center gap-2">
                      <TagIcon className="h-4 w-4" /> Cupons de Desconto
                    </h3>
                    {coupons.length > 0 ? (
                      <div className="grid grid-cols-1 gap-3">
                        {coupons.map((coupon) => (
                          <div key={coupon.id} className="relative flex flex-col p-4 rounded-xl border border-white/10 bg-gradient-to-br from-white/5 to-transparent overflow-hidden">
                            <div className="absolute top-0 right-0 p-2 opacity-10">
                              <TagIcon className="w-16 h-16" />
                            </div>
                            <div className="z-10 flex justify-between items-start mb-2">
                              <div>
                                <span className="font-bold text-lg text-[hsl(24,95%,55%)] leading-none">{coupon.discount_value}% OFF</span>
                                <p className="text-xs text-white/60 mt-1 line-clamp-1">{coupon.description || "Cupom exclusivo"}</p>
                              </div>
                            </div>
                            <div className="z-10 mt-2 flex items-center gap-2">
                              <div className="flex-1 rounded-lg border border-white/10 bg-black/40 px-3 py-2 text-xs font-mono font-medium text-white tracking-wider text-center select-all flex items-center justify-between">
                                {coupon.code}
                                <button
                                  onClick={() => handleCopyCoupon(coupon.code)}
                                  className="text-white/60 hover:text-white transition-colors p-1"
                                  title="Copiar cupom"
                                >
                                  {copiedCoupon === coupon.code ? <CheckCircle2 className="h-4 w-4 text-green-400" /> : <Copy className="h-4 w-4" />}
                                </button>
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <div className="bg-black/20 rounded-xl p-6 border border-white/5 text-center">
                        <p className="text-xs text-white/40">Nenhum cupom ativo no momento.</p>
                      </div>
                    )}
                  </div>
                </>
              )}
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default ShortsInfoPanel;
