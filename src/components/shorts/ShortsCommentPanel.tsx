import { useState, useEffect, useRef } from "react";
import { X, Star, Send, MessageCircle, Loader2, UserCircle2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";
import { motion, AnimatePresence } from "framer-motion";

interface Review {
  id: string;
  user_name: string;
  rating: number;
  comment: string | null;
  created_at: string;
}

interface Props {
  productId: string;
  productTitle: string;
  open: boolean;
  onClose: () => void;
}

const ShortsCommentPanel = ({ productId, productTitle, open, onClose }: Props) => {
  const { user } = useAuth();
  const [reviews, setReviews] = useState<Review[]>([]);
  const [loadingReviews, setLoadingReviews] = useState(false);
  const [userRating, setUserRating] = useState(0);
  const [comment, setComment] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const panelRef = useRef<HTMLDivElement>(null);

  // Fetch reviews when panel opens
  useEffect(() => {
    if (!open) return;
    setLoadingReviews(true);
    supabase
      .from("reviews")
      .select("id, user_name, rating, comment, created_at")
      .eq("product_id", productId)
      .order("created_at", { ascending: false })
      .then(({ data, error }) => {
        if (!error && data) setReviews(data as Review[]);
        setLoadingReviews(false);
      });
  }, [open, productId]);

  const handleSubmit = async () => {
    if (!user) {
      toast.error("Faça login para comentar");
      return;
    }
    if (userRating === 0) {
      toast.error("Selecione pelo menos uma estrela");
      return;
    }
    setSubmitting(true);
    const { data, error } = await supabase
      .from("reviews")
      .insert({
        product_id: productId,
        user_id: user.id,
        user_name: user.user_metadata?.full_name || user.email || "Anônimo",
        rating: userRating,
        comment: comment.trim() || null,
      })
      .select("id, user_name, rating, comment, created_at")
      .single();

    if (error) {
      toast.error("Erro ao enviar comentário.");
    } else {
      toast.success("Comentário enviado!");
      setReviews((prev) => [data as Review, ...prev]);
      setUserRating(0);
      setComment("");
    }
    setSubmitting(false);
  };

  // Close on backdrop click
  const handleBackdropClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget) onClose();
  };

  const formatDate = (iso: string) =>
    new Date(iso).toLocaleDateString("pt-BR", { day: "2-digit", month: "short", year: "numeric" });

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.2 }}
          className="absolute inset-0 z-40 flex items-end"
          onClick={handleBackdropClick}
        >
          {/* Backdrop */}
          <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" />

          {/* Panel */}
          <motion.div
            ref={panelRef}
            initial={{ y: "100%" }}
            animate={{ y: 0 }}
            exit={{ y: "100%" }}
            transition={{ type: "spring", damping: 28, stiffness: 300 }}
            className="relative z-10 w-full rounded-t-3xl bg-zinc-950/95 border-t border-white/10 flex flex-col"
            style={{ maxHeight: "75dvh" }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* Handle bar */}
            <div className="flex justify-center pt-3 pb-1">
              <div className="w-10 h-1 rounded-full bg-white/20" />
            </div>

            {/* Header */}
            <div className="flex items-center justify-between px-5 pb-4 pt-2 border-b border-white/10">
              <div className="flex items-center gap-2">
                <MessageCircle className="h-4 w-4 text-white/60" />
                <h2 className="text-sm font-semibold text-white truncate max-w-[220px]">
                  {productTitle}
                </h2>
              </div>
              <button
                onClick={onClose}
                className="flex h-8 w-8 items-center justify-center rounded-full bg-white/10 text-white hover:bg-white/20 transition-colors"
                aria-label="Fechar comentários"
              >
                <X className="h-4 w-4" />
              </button>
            </div>

            {/* Reviews list */}
            <div className="flex-1 overflow-y-auto px-5 py-4 space-y-4 scrollbar-thin scrollbar-thumb-white/10">
              {loadingReviews ? (
                <div className="flex justify-center py-10">
                  <Loader2 className="h-6 w-6 animate-spin text-white/40" />
                </div>
              ) : reviews.length === 0 ? (
                <div className="flex flex-col items-center gap-2 py-10 text-white/40">
                  <MessageCircle className="h-8 w-8" />
                  <p className="text-sm">Nenhum comentário ainda. Seja o primeiro!</p>
                </div>
              ) : (
                reviews.map((r) => (
                  <div
                    key={r.id}
                    className="flex gap-3 rounded-2xl bg-white/5 border border-white/10 p-4"
                  >
                    <UserCircle2 className="h-8 w-8 shrink-0 text-white/30 mt-0.5" />
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between gap-2 flex-wrap">
                        <span className="text-xs font-semibold text-white truncate">
                          {r.user_name}
                        </span>
                        <span className="text-[10px] text-white/40 shrink-0">
                          {formatDate(r.created_at)}
                        </span>
                      </div>
                      {/* Stars */}
                      <div className="flex gap-0.5 mt-1 mb-1.5">
                        {Array.from({ length: 5 }).map((_, i) => (
                          <Star
                            key={i}
                            className={`h-3 w-3 ${
                              i < r.rating
                                ? "fill-yellow-400 text-yellow-400"
                                : "text-white/20"
                            }`}
                          />
                        ))}
                      </div>
                      {r.comment && (
                        <p className="text-sm text-white/70 leading-relaxed break-words">
                          {r.comment}
                        </p>
                      )}
                    </div>
                  </div>
                ))
              )}
            </div>

            {/* Comment Form */}
            <div className="px-5 py-4 border-t border-white/10 bg-zinc-950/80">
              {user ? (
                <div className="space-y-3">
                  {/* Star selector */}
                  <div className="flex items-center gap-1">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <button
                        key={i}
                        onClick={() => setUserRating(i + 1)}
                        aria-label={`${i + 1} estrela${i > 0 ? "s" : ""}`}
                      >
                        <Star
                          className={`h-6 w-6 transition-colors ${
                            i < userRating
                              ? "fill-yellow-400 text-yellow-400"
                              : "text-white/30 hover:text-yellow-400"
                          }`}
                        />
                      </button>
                    ))}
                    {userRating > 0 && (
                      <button
                        onClick={() => setUserRating(0)}
                        className="ml-2 text-[10px] text-white/30 hover:text-white/60 transition-colors"
                      >
                        Limpar
                      </button>
                    )}
                  </div>

                  {/* Textarea + Send */}
                  <div className="flex gap-2">
                    <textarea
                      value={comment}
                      onChange={(e) => setComment(e.target.value)}
                      placeholder="Compartilhe sua experiência…"
                      rows={2}
                      className="flex-1 resize-none rounded-xl bg-white/10 border border-white/10 px-3 py-2 text-sm text-white placeholder:text-white/30 focus:outline-none focus:ring-1 focus:ring-white/20"
                    />
                    <button
                      onClick={handleSubmit}
                      disabled={submitting}
                      className="flex h-10 w-10 shrink-0 items-center justify-center self-end rounded-xl bg-indigo-500 hover:bg-indigo-400 transition-colors disabled:opacity-50"
                      aria-label="Enviar comentário"
                    >
                      {submitting ? (
                        <Loader2 className="h-4 w-4 animate-spin text-white" />
                      ) : (
                        <Send className="h-4 w-4 text-white" />
                      )}
                    </button>
                  </div>
                </div>
              ) : (
                <p className="text-sm text-white/40 text-center py-1">
                  <span className="text-indigo-400 cursor-pointer" onClick={() => toast.info("Faça login para comentar")}>
                    Faça login
                  </span>{" "}
                  para deixar um comentário.
                </p>
              )}
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default ShortsCommentPanel;
