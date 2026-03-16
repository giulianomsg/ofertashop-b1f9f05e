import { useState } from "react";
import { Copy, Check, ThumbsUp, ThumbsDown } from "lucide-react";
import { useCouponStats, useVoteCoupon } from "@/hooks/useEntities";
import { useAuth } from "@/hooks/useAuth";
import { useVisitorSession } from "@/hooks/useVisitorSession";
import { toast } from "sonner";

export const CouponItem = ({ coupon }: { coupon: any }) => {
  const [copied, setCopied] = useState(false);
  const { data: stats } = useCouponStats(coupon.id);
  const voteCoupon = useVoteCoupon();
  const { user } = useAuth();
  const visitorToken = useVisitorSession();
  const [hasVoted, setHasVoted] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(coupon.code);
    setCopied(true);
    toast.success("Código copiado!");
    setTimeout(() => setCopied(false), 2000);
  };

  const handleVote = async (isWorking: boolean) => {
    if (hasVoted) return;
    try {
      await voteCoupon.mutateAsync({
        couponId: coupon.id,
        isWorking,
        sessionToken: user ? user.id : visitorToken
      });
      setHasVoted(true);
      toast.success("Obrigado pelo seu feedback!");
    } catch {
      toast.error("Erro ao registrar voto.");
    }
  };

  const percentage = stats?.percentage || 0;
  const isGood = percentage >= 50;

  return (
    <div className="bg-card rounded-xl border border-border overflow-hidden flex flex-col sm:flex-row shadow-sm">
      <div className="bg-secondary p-4 flex flex-col items-center justify-center border-b sm:border-b-0 sm:border-r border-border min-w-[120px]">
        {coupon.discount_amount ? (
          <span className="font-display font-bold text-2xl text-accent">{coupon.discount_amount}</span>
        ) : (
          <span className="font-display font-bold text-lg text-foreground text-center">Cupom</span>
        )}
      </div>
      
      <div className="p-4 flex-1 flex flex-col justify-between">
        <div className="mb-4">
          <h4 className="font-semibold text-foreground text-lg mb-1">{coupon.title}</h4>
          {coupon.description && <p className="text-sm text-muted-foreground line-clamp-2">{coupon.description}</p>}
        </div>
        
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mt-auto">
          <button 
            onClick={handleCopy}
            className="flex items-center justify-between sm:justify-center gap-3 bg-secondary/50 border border-border border-dashed rounded-lg px-4 py-2 hover:bg-secondary transition-colors group"
          >
            <span className="font-mono font-bold tracking-wider text-foreground">{coupon.code}</span>
            {copied ? <Check className="w-4 h-4 text-success" /> : <Copy className="w-4 h-4 text-muted-foreground group-hover:text-foreground transition-colors" />}
          </button>
          
          <div className="flex items-center gap-3 text-sm">
            <span className="text-muted-foreground text-xs whitespace-nowrap">Funcionou?</span>
            <div className="flex items-center gap-1">
              <button 
                onClick={() => handleVote(true)} 
                disabled={hasVoted}
                className="p-1.5 rounded-md hover:bg-success/10 text-muted-foreground hover:text-success transition-colors disabled:opacity-50"
                aria-label="Sim"
              >
                <ThumbsUp className="w-4 h-4" />
              </button>
              <button 
                onClick={() => handleVote(false)} 
                disabled={hasVoted}
                className="p-1.5 rounded-md hover:bg-destructive/10 text-muted-foreground hover:text-destructive transition-colors disabled:opacity-50"
                aria-label="Não"
              >
                <ThumbsDown className="w-4 h-4" />
              </button>
            </div>
            {stats && stats.total > 0 && (
              <div className={`text-xs font-semibold px-2 py-1 rounded-full ${isGood ? 'bg-success/10 text-success' : 'bg-warning/10 text-warning'}`}>
                {percentage}% sucesso
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
