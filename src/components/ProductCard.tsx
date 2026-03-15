import { Star, ExternalLink, BadgeCheck, Flame, Sparkles, Heart } from "lucide-react";
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import type { Product } from "@/data/products";
import { usePlatforms, useWishlist, useToggleWishlist } from "@/hooks/useEntities";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";

const badgeConfig: Record<string, { icon: typeof BadgeCheck; label: string; className: string }> = {
  verified: { icon: BadgeCheck, label: "Verificado", className: "badge-verified" },
  hot: { icon: Flame, label: "Top Oferta", className: "badge-hot" },
  new: { icon: Sparkles, label: "Novo", className: "badge-new" },
};

const ProductCard = ({ product, index }: { product: Product; index: number }) => {
  const predefinedBadge = product.badge ? badgeConfig[product.badge.toLowerCase()] : null;
  const customBadge = !predefinedBadge && product.badge ? { label: product.badge, className: "badge-hot" } : null;
  const badge = predefinedBadge || customBadge;
  const { data: platforms = [] } = usePlatforms();
  const { user } = useAuth();
  const navigate = useNavigate();
  const { data: wishlistIds = [] } = useWishlist(user?.id);
  const toggleWishlist = useToggleWishlist();

  const isWished = wishlistIds.includes(product.id);

  const platform = (product as any).platform_id
    ? platforms.find((p) => p.id === (product as any).platform_id)
    : null;

  const handleWishlistClick = (e: React.MouseEvent) => {
    e.preventDefault();
    if (!user) {
      toast.error("Faça login para adicionar à lista de desejos.");
      navigate("/login");
      return;
    }
    toggleWishlist.mutate({ userId: user.id, productId: product.id, isWished });
  };

  const imageUrl = product.image_url || "/placeholder.svg";

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05, duration: 0.4 }}
    >
      <Link to={`/produto/${product.id}`} className="block card-product group">
        <div className="relative aspect-square overflow-hidden bg-secondary">
          <img
            src={imageUrl}
            alt={product.title}
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
          />
          {product.discount && (
            <span className="absolute top-3 left-3 btn-accent !px-2.5 !py-1 !text-xs !shadow-none">
              -{product.discount}%
            </span>
          )}
          <button 
            onClick={handleWishlistClick}
            className={`absolute top-3 left-3 z-10 p-2 rounded-full backdrop-blur-md transition-all ${isWished ? 'bg-accent/90 text-white' : 'bg-background/80 text-foreground hover:bg-background'} ${product.discount ? 'mt-8' : ''}`}
            aria-label="Adicionar aos favoritos"
          >
            <Heart className={`w-4 h-4 ${isWished ? 'fill-current' : ''}`} />
          </button>
          {badge && (
            <span className={`absolute top-3 right-3 ${badge.className}`}>
              {predefinedBadge && <predefinedBadge.icon className="w-3 h-3" />}
              {badge.label}
            </span>
          )}
          {/* Platform logo badge */}
          {platform?.logo_url && (
            <div className="absolute bottom-2 left-2 w-7 h-7 rounded-md bg-card/90 backdrop-blur-sm border border-border flex items-center justify-center">
              <img src={platform.logo_url} alt={platform.name} className="w-5 h-5 object-contain" />
            </div>
          )}
        </div>

        <div className="p-4 space-y-2">
          <div className="flex items-center gap-1.5">
            {platform ? (
              <div className="flex items-center gap-1">
                {platform.logo_url && <img src={platform.logo_url} alt={platform.name} className="w-3.5 h-3.5 object-contain" />}
                <p className="text-xs text-muted-foreground">{platform.name}</p>
              </div>
            ) : (
              <p className="text-xs text-muted-foreground">{product.store}</p>
            )}
          </div>
          <h3 className="font-display font-semibold text-sm text-foreground leading-snug line-clamp-2 group-hover:text-accent transition-colors">
            {product.title}
          </h3>

          <div className="flex items-center gap-1.5">
            <div className="flex">
              {Array.from({ length: 5 }).map((_, i) => (
                <Star key={i} className={`w-3 h-3 ${i < Math.floor(Number(product.rating)) ? "fill-warning text-warning" : "text-muted"}`} />
              ))}
            </div>
            <span className="text-xs text-muted-foreground">
              {product.rating} ({product.review_count.toLocaleString()})
            </span>
          </div>

          <div className="flex items-baseline gap-2">
            <span className="font-display font-bold text-lg text-foreground">
              R$ {Number(product.price).toFixed(2).replace(".", ",")}
            </span>
            {product.original_price && (
              <span className="text-xs text-muted-foreground line-through">
                R$ {Number(product.original_price).toFixed(2).replace(".", ",")}
              </span>
            )}
          </div>

          <button className="btn-accent w-full flex items-center justify-center gap-2 mt-2 text-xs" aria-label={`Ver oferta de ${product.title}`}>
            <ExternalLink className="w-3.5 h-3.5" />
            Ver Oferta
          </button>
        </div>
      </Link>
    </motion.div>
  );
};

export default ProductCard;
