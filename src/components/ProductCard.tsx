import { Star, ExternalLink, BadgeCheck, Flame, Sparkles } from "lucide-react";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import type { Product } from "@/data/products";

const badgeConfig = {
  verified: { icon: BadgeCheck, label: "Verificado", className: "badge-verified" },
  hot: { icon: Flame, label: "Top Oferta", className: "badge-hot" },
  new: { icon: Sparkles, label: "Novo", className: "badge-new" },
};

const ProductCard = ({ product, index }: { product: Product; index: number }) => {
  const badge = product.badge ? badgeConfig[product.badge] : null;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: index * 0.05, duration: 0.4 }}
    >
      <Link to={`/produto/${product.id}`} className="block card-product group">
        {/* Image */}
        <div className="relative aspect-square overflow-hidden bg-secondary">
          <img
            src={product.image}
            alt={product.title}
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
          />
          {product.discount && (
            <span className="absolute top-3 left-3 btn-accent !px-2.5 !py-1 !text-xs !shadow-none">
              -{product.discount}%
            </span>
          )}
          {badge && (
            <span className={`absolute top-3 right-3 ${badge.className}`}>
              <badge.icon className="w-3 h-3" />
              {badge.label}
            </span>
          )}
        </div>

        {/* Content */}
        <div className="p-4 space-y-2">
          <p className="text-xs text-muted-foreground">{product.store}</p>
          <h3 className="font-display font-semibold text-sm text-foreground leading-snug line-clamp-2 group-hover:text-accent transition-colors">
            {product.title}
          </h3>

          {/* Rating */}
          <div className="flex items-center gap-1.5">
            <div className="flex">
              {Array.from({ length: 5 }).map((_, i) => (
                <Star key={i} className={`w-3 h-3 ${i < Math.floor(product.rating) ? "fill-warning text-warning" : "text-muted"}`} />
              ))}
            </div>
            <span className="text-xs text-muted-foreground">
              {product.rating} ({product.reviewCount.toLocaleString()})
            </span>
          </div>

          {/* Price */}
          <div className="flex items-baseline gap-2">
            <span className="font-display font-bold text-lg text-foreground">
              R$ {product.price.toFixed(2).replace(".", ",")}
            </span>
            {product.originalPrice && (
              <span className="text-xs text-muted-foreground line-through">
                R$ {product.originalPrice.toFixed(2).replace(".", ",")}
              </span>
            )}
          </div>

          {/* CTA */}
          <button className="btn-accent w-full flex items-center justify-center gap-2 mt-2 text-xs">
            <ExternalLink className="w-3.5 h-3.5" />
            Ver Oferta
          </button>
        </div>
      </Link>
    </motion.div>
  );
};

export default ProductCard;
