import { useState } from "react";
import { useParams, Link } from "react-router-dom";
import { Star, ExternalLink, ArrowLeft, BadgeCheck, Flame, AlertTriangle, ThumbsUp, Send, TrendingUp, Shield } from "lucide-react";
import { motion } from "framer-motion";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import ProductCard from "@/components/ProductCard";
import { products } from "@/data/products";

const reviews = [
  { id: 1, user: "Maria S.", rating: 5, date: "2026-03-01", text: "Produto excelente! Chegou antes do prazo e a qualidade superou minhas expectativas.", helpful: 12 },
  { id: 2, user: "Carlos R.", rating: 4, date: "2026-02-28", text: "Muito bom pelo preço. Recomendo para quem busca custo-benefício.", helpful: 8 },
  { id: 3, user: "Ana P.", rating: 5, date: "2026-02-25", text: "Já é minha segunda compra. Confiável e de ótima qualidade!", helpful: 15 },
];

const ProductDetail = () => {
  const { id } = useParams();
  const product = products.find((p) => p.id === id);
  const [userRating, setUserRating] = useState(0);
  const [comment, setComment] = useState("");
  const [showExpired, setShowExpired] = useState(false);

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

  const related = products.filter((p) => p.id !== product.id).slice(0, 3);

  return (
    <div className="min-h-screen bg-background">
      <SiteHeader />
      <main className="container mx-auto px-4 lg:px-8 py-6">
        {/* Breadcrumb */}
        <Link to="/" className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-6">
          <ArrowLeft className="w-4 h-4" /> Voltar às ofertas
        </Link>

        <div className="grid lg:grid-cols-2 gap-8 mb-12">
          {/* Image */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-card rounded-2xl border border-border overflow-hidden aspect-square"
            style={{ boxShadow: "var(--shadow-card)" }}
          >
            <img src={product.image} alt={product.title} className="w-full h-full object-cover" />
          </motion.div>

          {/* Info */}
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="space-y-5">
            <div>
              <p className="text-sm text-muted-foreground mb-1">{product.store} · {product.category}</p>
              <h1 className="font-display font-bold text-2xl lg:text-3xl text-foreground">{product.title}</h1>
            </div>

            {/* Rating */}
            <div className="flex items-center gap-3">
              <div className="flex">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Star key={i} className={`w-5 h-5 ${i < Math.floor(product.rating) ? "fill-warning text-warning" : "text-muted"}`} />
                ))}
              </div>
              <span className="font-semibold text-foreground">{product.rating}</span>
              <span className="text-sm text-muted-foreground">({product.reviewCount.toLocaleString()} avaliações)</span>
            </div>

            {/* Price */}
            <div className="bg-secondary rounded-xl p-5 space-y-2">
              <div className="flex items-baseline gap-3">
                <span className="font-display font-bold text-3xl text-foreground">
                  R$ {product.price.toFixed(2).replace(".", ",")}
                </span>
                {product.originalPrice && (
                  <span className="text-lg text-muted-foreground line-through">
                    R$ {product.originalPrice.toFixed(2).replace(".", ",")}
                  </span>
                )}
              </div>
              {product.discount && (
                <span className="badge-hot">
                  <Flame className="w-3 h-3" /> Economia de {product.discount}%
                </span>
              )}
            </div>

            {/* Description */}
            <p className="text-muted-foreground leading-relaxed">{product.description}</p>

            {/* Reputation */}
            <div className="flex flex-wrap gap-3">
              <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-card border border-border text-sm">
                <TrendingUp className="w-4 h-4 text-accent" />
                <span className="text-foreground font-medium">{product.clicks.toLocaleString()} cliques</span>
              </div>
              <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-card border border-border text-sm">
                <Shield className="w-4 h-4 text-success" />
                <span className="text-foreground font-medium">Confiável</span>
              </div>
              {product.badge === "verified" && (
                <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-card border border-border text-sm">
                  <BadgeCheck className="w-4 h-4 text-info" />
                  <span className="text-foreground font-medium">Verificado</span>
                </div>
              )}
            </div>

            {/* CTA */}
            <a href={product.affiliateUrl} className="btn-accent flex items-center justify-center gap-2 w-full text-base py-3.5">
              <ExternalLink className="w-5 h-5" />
              Acessar Oferta
            </a>

            {/* Report */}
            <button
              onClick={() => setShowExpired(!showExpired)}
              className="flex items-center gap-2 text-sm text-muted-foreground hover:text-destructive transition-colors"
            >
              <AlertTriangle className="w-4 h-4" />
              Oferta expirada?
            </button>
            {showExpired && (
              <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} className="bg-destructive/5 border border-destructive/20 rounded-xl p-4 text-sm text-foreground">
                <p className="mb-2">Obrigado por reportar! Vamos verificar esta oferta.</p>
                <button className="btn-accent !text-xs">Confirmar Denúncia</button>
              </motion.div>
            )}
          </motion.div>
        </div>

        {/* Reviews */}
        <section className="mb-12">
          <h2 className="font-display font-bold text-xl text-foreground mb-6">Avaliações e Comentários</h2>
          
          {/* Form */}
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
            <button className="btn-accent mt-3 flex items-center gap-2 text-xs">
              <Send className="w-3.5 h-3.5" /> Enviar Avaliação
            </button>
          </div>

          {/* Reviews list */}
          <div className="space-y-4">
            {reviews.map((review) => (
              <div key={review.id} className="bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-accent/10 flex items-center justify-center font-display font-bold text-sm text-accent">
                      {review.user[0]}
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">{review.user}</p>
                      <p className="text-xs text-muted-foreground">{review.date}</p>
                    </div>
                  </div>
                  <div className="flex">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Star key={i} className={`w-3.5 h-3.5 ${i < review.rating ? "fill-warning text-warning" : "text-muted"}`} />
                    ))}
                  </div>
                </div>
                <p className="text-sm text-muted-foreground mb-2">{review.text}</p>
                <button className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition-colors">
                  <ThumbsUp className="w-3.5 h-3.5" /> Útil ({review.helpful})
                </button>
              </div>
            ))}
          </div>
        </section>

        {/* Related */}
        <section>
          <h2 className="font-display font-bold text-xl text-foreground mb-6">Ofertas Relacionadas</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {related.map((p, i) => (
              <ProductCard key={p.id} product={p} index={i} />
            ))}
          </div>
        </section>
      </main>
      <SiteFooter />
    </div>
  );
};

export default ProductDetail;
