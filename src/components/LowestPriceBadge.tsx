import { useMemo } from "react";
import { TrendingDown, Award, Calendar } from "lucide-react";
import { usePriceHistory } from "@/hooks/useProducts";

interface LowestPriceBadgeProps {
  productId: string;
  currentPrice: number;
  brandId?: string | null;
  modelId?: string | null;
}

const LowestPriceBadge = ({ productId, currentPrice, brandId, modelId }: LowestPriceBadgeProps) => {
  const { data: priceHistory = [] } = usePriceHistory(productId, brandId, modelId);

  const lowestInfo = useMemo(() => {
    if (!priceHistory || priceHistory.length === 0) return null;

    let lowest = Infinity;
    let lowestDate = "";

    for (const entry of priceHistory) {
      const price = Number((entry as any).price);
      if (price < lowest) {
        lowest = price;
        lowestDate = (entry as any).created_at;
      }
    }

    if (lowest === Infinity) return null;

    const isCurrentLowest = currentPrice <= lowest;
    const formattedDate = new Date(lowestDate).toLocaleDateString("pt-BR", {
      day: "2-digit",
      month: "short",
      year: "numeric",
    });

    return {
      lowestPrice: lowest,
      lowestDate: formattedDate,
      isCurrentLowest,
    };
  }, [priceHistory, currentPrice]);

  if (!lowestInfo) return null;

  if (lowestInfo.isCurrentLowest) {
    return (
      <div className="flex items-center gap-2 px-3 py-2 rounded-xl bg-gradient-to-r from-emerald-500/15 to-emerald-400/10 border border-emerald-500/30">
        <div className="flex items-center justify-center w-8 h-8 rounded-full bg-emerald-500/20">
          <Award className="w-4 h-4 text-emerald-500" />
        </div>
        <div>
          <p className="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider">
            🏆 Menor preço de todos os tempos!
          </p>
          <p className="text-[11px] text-emerald-600/70 dark:text-emerald-400/70">
            Este é o melhor preço já registrado para este produto
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="flex items-center gap-2 px-3 py-2 rounded-xl bg-info/10 border border-info/20">
      <div className="flex items-center justify-center w-8 h-8 rounded-full bg-info/20">
        <TrendingDown className="w-4 h-4 text-info" />
      </div>
      <div>
        <p className="text-xs font-semibold text-info">
          Menor preço histórico: R$ {lowestInfo.lowestPrice.toFixed(2).replace(".", ",")}
        </p>
        <p className="text-[11px] text-muted-foreground flex items-center gap-1">
          <Calendar className="w-3 h-3" />
          Registrado em {lowestInfo.lowestDate}
        </p>
      </div>
    </div>
  );
};

export default LowestPriceBadge;
