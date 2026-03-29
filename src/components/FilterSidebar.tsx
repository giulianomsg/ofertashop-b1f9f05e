import { useState } from "react";
import { Star, ChevronDown, SlidersHorizontal, Check, Home, Tag } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Link, useLocation } from "react-router-dom";

interface FilterSidebarProps {
  hideCategory?: boolean;
  selectedCategoryId?: string;
  onCategoryChange?: (id: string) => void;
  categories?: any[];
  hidePrice?: boolean;
  priceRange?: number[];
  onPriceRangeChange?: (range: number[]) => void;
  hideRating?: boolean;
  minRating?: number;
  onMinRatingChange?: (rating: number) => void;
  availablePlatforms: { id: string, name: string }[];
  selectedPlatforms: string[];
  onPlatformToggle: (platformId: string) => void;
  onClearFilters?: () => void;
  mobileOpen?: boolean;
  onClose?: () => void;
}

const FilterSidebar = ({
  hideCategory = false,
  selectedCategoryId,
  onCategoryChange,
  categories,
  hidePrice = false,
  priceRange,
  onPriceRangeChange,
  hideRating = false,
  minRating,
  onMinRatingChange,
  availablePlatforms,
  selectedPlatforms,
  onPlatformToggle,
  onClearFilters,
  mobileOpen,
  onClose
}: FilterSidebarProps) => {
  const [openSections, setOpenSections] = useState({ category: true, price: true, rating: true, platform: true });
  const location = useLocation();

  const toggleSection = (key: keyof typeof openSections) =>
    setOpenSections((s) => ({ ...s, [key]: !s[key] }));

  const content = (
    <div className="space-y-6">
      <div className="flex items-center justify-between mb-2">
        <div className="flex items-center gap-2">
          <SlidersHorizontal className="w-4 h-4 text-accent" />
          <h3 className="font-display font-semibold text-foreground">Filtros</h3>
        </div>
        {onClearFilters && (
          <button
            onClick={onClearFilters}
            className="text-xs font-medium text-muted-foreground hover:text-foreground transition-colors bg-secondary px-2 py-1 rounded-md"
          >
            Limpar
          </button>
        )}
      </div>

      <div className="space-y-1 mb-4">
        <Link 
          to="/" 
          onClick={onClose}
          className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${location.pathname === '/' ? 'bg-accent/10 text-accent' : 'text-muted-foreground hover:bg-secondary hover:text-foreground'}`}
        >
          <Home className="w-4 h-4" /> Ofertas
        </Link>
        <Link 
          to="/cupons" 
          onClick={onClose}
          className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${location.pathname === '/cupons' ? 'bg-accent/10 text-accent' : 'text-muted-foreground hover:bg-secondary hover:text-foreground'}`}
        >
          <Tag className="w-4 h-4" /> Cupons de Desconto
        </Link>
      </div>

      <div className="h-px w-full bg-border" />

      {/* Categories */}
      {!hideCategory && categories && onCategoryChange && (
      <div>
        <button onClick={() => toggleSection("category")} className="flex items-center justify-between w-full text-sm font-semibold text-foreground mb-3">
          Categorias
          <ChevronDown className={`w-4 h-4 transition-transform ${openSections.category ? "rotate-180" : ""}`} />
        </button>
        <AnimatePresence>
          {openSections.category && (
            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden space-y-1">
              <button
                onClick={() => { onCategoryChange(""); onClose?.(); }}
                className={`w-full text-left px-3 py-2 rounded-lg text-sm transition-all ${selectedCategoryId === ""
                  ? "bg-accent/10 text-accent font-medium"
                  : "text-muted-foreground hover:bg-secondary hover:text-foreground"
                  }`}
              >
                Todas
              </button>
              {categories.map((cat) => (
                <button
                  key={cat.id}
                  onClick={() => { onCategoryChange(cat.id); onClose?.(); }}
                  className={`w-full text-left px-3 py-2 rounded-lg text-sm transition-all ${selectedCategoryId === cat.id
                    ? "bg-accent/10 text-accent font-medium"
                    : "text-muted-foreground hover:bg-secondary hover:text-foreground"
                    }`}
                >
                  {cat.name}
                </button>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>
      )}

      {/* Price */}
      {!hidePrice && priceRange && onPriceRangeChange && (
      <div>
        <button onClick={() => toggleSection("price")} className="flex items-center justify-between w-full text-sm font-semibold text-foreground mb-3">
          Faixa de Preço
          <ChevronDown className={`w-4 h-4 transition-transform ${openSections.price ? "rotate-180" : ""}`} />
        </button>
        <AnimatePresence>
          {openSections.price && (
            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden">
              <input
                type="range"
                min={0}
                max={5000}
                value={priceRange[1]}
                onChange={(e) => onPriceRangeChange([priceRange[0], Number(e.target.value)])}
                className="w-full accent-accent"
              />
              <div className="flex justify-between text-xs text-muted-foreground mt-1">
                <span>R$ {priceRange[0]}</span>
                <span>R$ {priceRange[1]}</span>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
      )}

      {/* Rating */}
      {!hideRating && minRating !== undefined && onMinRatingChange && (
      <div>
        <button onClick={() => toggleSection("rating")} className="flex items-center justify-between w-full text-sm font-semibold text-foreground mb-3">
          Avaliação Mínima
          <ChevronDown className={`w-4 h-4 transition-transform ${openSections.rating ? "rotate-180" : ""}`} />
        </button>
        <AnimatePresence>
          {openSections.rating && (
            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden space-y-2">
              {[4, 3, 2, 1, 0].map((r) => (
                <button
                  key={r}
                  onClick={() => onMinRatingChange(minRating === r ? 0 : r)}
                  className={`flex items-center gap-2 w-full px-3 py-1.5 rounded-lg text-sm transition-all ${minRating === r ? "bg-accent/10" : "hover:bg-secondary"
                    }`}
                >
                  <div className="flex">
                    {r === 0 ? (
                      <span className="text-sm">Todas as avaliações</span>
                    ) : (
                      <>
                        {Array.from({ length: 5 }).map((_, i) => (
                          <Star key={i} className={`w-3.5 h-3.5 ${i < r ? "fill-warning text-warning" : "text-muted"}`} />
                        ))}
                        <span className="text-muted-foreground ml-2">& acima</span>
                      </>
                    )}
                  </div>
                </button>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>
      )}

      {/* Platforms */}
      {availablePlatforms.length > 0 && (
        <div>
          <button onClick={() => toggleSection("platform")} className="flex items-center justify-between w-full text-sm font-semibold text-foreground mb-3">
            Plataformas
            <ChevronDown className={`w-4 h-4 transition-transform ${openSections.platform ? "rotate-180" : ""}`} />
          </button>
          <AnimatePresence>
            {openSections.platform && (
              <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden space-y-2">
                {availablePlatforms.map((platform) => (
                  <label key={platform.id} className="flex items-center gap-2 px-3 py-1.5 rounded-lg hover:bg-secondary cursor-pointer transition-colors">
                    <input
                      type="checkbox"
                      className="rounded border-border accent-accent w-4 h-4"
                      checked={selectedPlatforms.includes(platform.id)}
                      onChange={() => onPlatformToggle(platform.id)}
                    />
                    <span className="text-sm text-foreground">{platform.name}</span>
                  </label>
                ))}
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      )}
    </div>
  );

  return (
    <>
      <aside className="hidden lg:block w-64 shrink-0">
        <div className="sticky top-20 bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
          {content}
        </div>
      </aside>

      <AnimatePresence>
        {mobileOpen && (
          <>
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="fixed inset-0 bg-foreground/20 backdrop-blur-sm z-40 lg:hidden" onClick={onClose} />
            <motion.div initial={{ x: -300 }} animate={{ x: 0 }} exit={{ x: -300 }} transition={{ type: "spring", damping: 25 }} className="fixed left-0 top-0 bottom-0 w-72 bg-card z-50 p-5 overflow-y-auto lg:hidden border-r border-border">
              {content}
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </>
  );
};

export default FilterSidebar;
