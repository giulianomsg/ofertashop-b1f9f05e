import { useState } from "react";
import { useParams, Link } from "react-router-dom";
import { Star, ExternalLink, ArrowLeft, BadgeCheck, Flame, AlertTriangle, ThumbsUp, Send, TrendingUp, Shield, Sparkles } from "lucide-react";
import { motion } from "framer-motion";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import ProductCard from "@/components/ProductCard";
import { useProduct, useProducts, useReviews } from "@/hooks/useProducts";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const ProductDetail = () => {
  const { id } = useParams();
  const { data: product, isLoading } = useProduct(id);
  const { data: products = [] } = useProducts();
  const { data: reviews = [] } = useReviews(id);
  const { user } = useAuth();
  const [userRating, setUserRating] = useState(0);
  const [comment, setComment] = useState("");
  const [showExpired, setShowExpired] = useState(false);
  const [reportEmail, setReportEmail] = useState("");
  const [submitting, setSubmitting] = useState(false);

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background">
        <SiteHeader />
        <div className="container mx-auto px-4 py-20 text-center">
          <div className="animate-pulse w-16 h-16 rounded-full bg-secondary mx-auto" />
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="min-h-screen bg-background">
        <SiteHeader />
        <div className="container mx-auto px-4 py-20 text-center">
          <h1 className="font-display text-2xl font-bold text-foreground">Produto não encontrado</h1>
          <Link to="/" className="btn-accent inline-block mt-4">Voltar ao Início</Link>
        </div>
      </div>
    );
  }

  const related = products.filter((p) => p.id !== product.id && p.category === product.category).slice(0, 3);
  const imageUrl = product.image_url || "/placeholder.svg";

  const handleReview = async () => {
    if (!user) { toast.error("Faça login para avaliar."); return; }
    if (userRating === 0) { toast.error("Selecione uma avaliação."); return; }
    setSubmitting(true);
    const { error } = await supabase.from("reviews").insert({
      product_id: product.id,
      user_id: user.id,
      user_name: user.user_metadata?.full_name || user.email || "Anônimo",
      rating: userRating,
      comment: comment || null,
    });
    if (error) toast.error("Erro ao enviar avaliação.");
    else {
      toast.success("Avaliação enviada!");
      setUserRating(0);
      setComment("");
    }
    setSubmitting(false);
  };

  const handleReport = async () => {
    if (!reportEmail) { toast.error("Informe seu email."); return; }
    const { error } = await supabase.from("reports").insert({
      product_id: product.id,
      reporter_email: reportEmail,
      report_type: "Oferta Expirada",
    });
    if (error) toast.error("Erro ao enviar denúncia.");
    else {
      toast.success("Denúncia enviada! Vamos verificar.");
      setShowExpired(false);
      setReportEmail("");
    }
  };

  return (
    <div className="min-h-screen bg-background">
      <SiteHeader />
      <main className="container mx-auto px-4 lg:px-8 py-6">
        <Link to="/" className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-6">
          <ArrowLeft className="w-4 h-4" /> Voltar às ofertas
        </Link>

        <div className="grid lg:grid-cols-2 gap-8 mb-12">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-card rounded-2xl border border-border overflow-hidden aspect-square"
            style={{ boxShadow: "var(--shadow-card)" }}
          >
            <img src={imageUrl} alt={product.title} className="w-full h-full object-cover" />
          </motion.div>

          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="space-y-5">
            <div>
              <p className="text-sm text-muted-foreground mb-1">{product.store} · {product.category}</p>
              <h1 className="font-display font-bold text-2xl lg:text-3xl text-foreground">{product.title}</h1>
            </div>

            <div className="flex items-center gap-3">
              <div className="flex">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Star key={i} className={`w-5 h-5 ${i < Math.floor(Number(product.rating)) ? "fill-warning text-warning" : "text-muted"}`} />
                ))}
              </div>
              <span className="font-semibold text-foreground">{product.rating}</span>
              <span className="text-sm text-muted-foreground">({product.review_count.toLocaleString()} avaliações)</span>
            </div>

            <div className="bg-secondary rounded-xl p-5 space-y-2">
              <div className="flex items-baseline gap-3">
                <span className="font-display font-bold text-3xl text-foreground">
                  R$ {Number(product.price).toFixed(2).replace(".", ",")}
                </span>
                {product.original_price && (
                  <span className="text-lg text-muted-foreground line-through">
                    R$ {Number(product.original_price).toFixed(2).replace(".", ",")}
                  </span>
                )}
              </div>
              {product.discount && (
                <span className="badge-hot">
                  <Flame className="w-3 h-3" /> Economia de {product.discount}%
                </span>
              )}
            </div>

            <div
              dangerouslySetInnerHTML={{ __html: product.description || '' }}
              className="text-muted-foreground leading-relaxed [&>p]:mb-2 [&>ul]:list-disc [&>ul]:pl-5 [&>ol]:list-decimal [&>ol]:pl-5 [&>h1]:text-xl [&>h1]:font-bold [&>h2]:text-lg [&>h2]:font-bold [&>h3]:text-base [&>h3]:font-bold [&_a]:text-accent [&_a]:underline"
            />

            <div className="flex flex-wrap gap-3">
              <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-card border border-border text-sm">
                <TrendingUp className="w-4 h-4 text-accent" />
                <span className="text-foreground font-medium">{product.clicks.toLocaleString()} cliques</span>
              </div>
              <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-card border border-border text-sm">
                <Shield className="w-4 h-4 text-success" />
                <span className="text-foreground font-medium">Confiável</span>
              </div>
              {(() => {
                const badgeConfig: Record<string, { icon: typeof BadgeCheck; label: string; color: string }> = {
                  verified: { icon: BadgeCheck, label: "Verificado", color: "text-info" },
                  hot: { icon: Flame, label: "Top Oferta", color: "text-orange-500" },
                  new: { icon: Sparkles, label: "Novo", color: "text-yellow-500" },
                };
                const predefinedBadge = product.badge ? badgeConfig[product.badge.toLowerCase()] : null;
                const customBadge = !predefinedBadge && product.badge ? { label: product.badge, color: "text-accent" } : null;
                const badgeToDisplay = predefinedBadge || customBadge;

                if (!badgeToDisplay) return null;

                const IconComponent = predefinedBadge ? predefinedBadge.icon : Flame;

                return (
                  <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-card border border-border text-sm">
                    <IconComponent className={`w-4 h-4 ${badgeToDisplay.color}`} />
                    <span className="text-foreground font-medium">{badgeToDisplay.label}</span>
                  </div>
                );
              })()}
            </div>

            <a href={product.affiliate_url} className="btn-accent flex items-center justify-center gap-2 w-full text-base py-3.5">
              <ExternalLink className="w-5 h-5" />
              Acessar Oferta
            </a>

            <button
              onClick={() => setShowExpired(!showExpired)}
              className="flex items-center gap-2 text-sm text-muted-foreground hover:text-destructive transition-colors"
            >
              <AlertTriangle className="w-4 h-4" />
              Oferta expirada?
            </button>
            {showExpired && (
              <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} className="bg-destructive/5 border border-destructive/20 rounded-xl p-4 text-sm text-foreground space-y-3">
                <p>Informe seu email para confirmar a denúncia:</p>
                <input
                  type="email"
                  value={reportEmail}
                  onChange={(e) => setReportEmail(e.target.value)}
                  placeholder="seu@email.com"
                  className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                />
                <button onClick={handleReport} className="btn-accent !text-xs">Confirmar Denúncia</button>
              </motion.div>
            )}
          </motion.div>
        </div>

        {/* Reviews */}
        <section className="mb-12">
          <h2 className="font-display font-bold text-xl text-foreground mb-6">Avaliações e Comentários</h2>

          {user && (
            <div className="bg-card rounded-xl border border-border p-5 mb-6" style={{ boxShadow: "var(--shadow-card)" }}>
              <h3 className="font-display font-semibold text-foreground mb-3">Deixe sua avaliação</h3>
              <div className="flex gap-1 mb-3">
                {Array.from({ length: 5 }).map((_, i) => (
                  <button key={i} onClick={() => setUserRating(i + 1)}>
                    <Star className={`w-6 h-6 transition-colors ${i < userRating ? "fill-warning text-warning" : "text-muted hover:text-warning"}`} />
                  </button>
                ))}
              </div>
              <textarea
                value={comment}
                onChange={(e) => setComment(e.target.value)}
                placeholder="Compartilhe sua experiência..."
                className="w-full p-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 resize-none h-24"
              />
              <button onClick={handleReview} disabled={submitting} className="btn-accent mt-3 flex items-center gap-2 text-xs disabled:opacity-50">
                <Send className="w-3.5 h-3.5" /> Enviar Avaliação
              </button>
            </div>
          )}

          {!user && (
            <div className="bg-secondary rounded-xl p-5 mb-6 text-center">
              <p className="text-sm text-muted-foreground">
                <Link to="/admin/login" className="text-accent font-medium hover:underline">Faça login</Link> para deixar uma avaliação.
              </p>
            </div>
          )}

          <div className="space-y-4">
            {reviews.map((review) => (
              <div key={review.id} className="bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-accent/10 flex items-center justify-center font-display font-bold text-sm text-accent">
                      {review.user_name[0]}
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">{review.user_name}</p>
                      <p className="text-xs text-muted-foreground">{new Date(review.created_at).toLocaleDateString("pt-BR")}</p>
                    </div>
                  </div>
                  <div className="flex">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Star key={i} className={`w-3.5 h-3.5 ${i < review.rating ? "fill-warning text-warning" : "text-muted"}`} />
                    ))}
                  </div>
                </div>
                {review.comment && <p className="text-sm text-muted-foreground mb-2">{review.comment}</p>}
                <button className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition-colors">
                  <ThumbsUp className="w-3.5 h-3.5" /> Útil ({review.helpful_count})
                </button>
              </div>
            ))}
            {reviews.length === 0 && (
              <p className="text-sm text-muted-foreground text-center py-8">Nenhuma avaliação ainda. Seja o primeiro!</p>
            )}
          </div>
        </section>

        {related.length > 0 && (
          <section>
            <h2 className="font-display font-bold text-xl text-foreground mb-6">Ofertas Relacionadas</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {related.map((p, i) => (
                <ProductCard key={p.id} product={p} index={i} />
              ))}
            </div>
          </section>
        )}
      </main>
      <SiteFooter />
    </div>
  );
};

export default ProductDetail;
