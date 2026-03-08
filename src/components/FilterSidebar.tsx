import { useState } from "react";
import { Star, ChevronDown, SlidersHorizontal } from "lucide-react";
import { categories } from "@/data/products";
import { motion, AnimatePresence } from "framer-motion";

interface FilterSidebarProps {
  selectedCategory: string;
  onCategoryChange: (cat: string) => void;
  mobileOpen?: boolean;
  onClose?: () => void;
}

const FilterSidebar = ({ selectedCategory, onCategoryChange, mobileOpen, onClose }: FilterSidebarProps) => {
  const [priceRange, setPriceRange] = useState([0, 500]);
  const [minRating, setMinRating] = useState(0);
  const [openSections, setOpenSections] = useState({ category: true, price: true, rating: true, store: false });

  const toggleSection = (key: keyof typeof openSections) =>
    setOpenSections((s) => ({ ...s, [key]: !s[key] }));

  const stores = ["TechStore", "WearTech", "AudioShop", "GameZone", "UrbanGear", "PowerUp"];

  const content = (
    <div className="space-y-6">
      <div className="flex items-center gap-2 mb-2">
        <SlidersHorizontal className="w-4 h-4 text-accent" />
        <h3 className="font-display font-semibold text-foreground">Filtros</h3>
      </div>

      {/* Categories */}
      <div>
        <button onClick={() => toggleSection("category")} className="flex items-center justify-between w-full text-sm font-semibold text-foreground mb-3">
          Categorias
          <ChevronDown className={`w-4 h-4 transition-transform ${openSections.category ? "rotate-180" : ""}`} />
        </button>
        <AnimatePresence>
          {openSections.category && (
            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden space-y-1">
              {categories.map((cat) => (
                <button
                  key={cat}
                  onClick={() => { onCategoryChange(cat); onClose?.(); }}
                  className={`w-full text-left px-3 py-2 rounded-lg text-sm transition-all ${
                    selectedCategory === cat
                      ? "bg-accent/10 text-accent font-medium"
                      : "text-muted-foreground hover:bg-secondary hover:text-foreground"
                  }`}
                >
                  {cat}
                </button>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Price */}
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
                max={1000}
                value={priceRange[1]}
                onChange={(e) => setPriceRange([priceRange[0], Number(e.target.value)])}
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

      {/* Rating */}
      <div>
        <button onClick={() => toggleSection("rating")} className="flex items-center justify-between w-full text-sm font-semibold text-foreground mb-3">
          Avaliação Mínima
          <ChevronDown className={`w-4 h-4 transition-transform ${openSections.rating ? "rotate-180" : ""}`} />
        </button>
        <AnimatePresence>
          {openSections.rating && (
            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden space-y-2">
              {[4, 3, 2, 1].map((r) => (
                <button
                  key={r}
                  onClick={() => setMinRating(r)}
                  className={`flex items-center gap-2 w-full px-3 py-1.5 rounded-lg text-sm transition-all ${
                    minRating === r ? "bg-accent/10" : "hover:bg-secondary"
                  }`}
                >
                  <div className="flex">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Star key={i} className={`w-3.5 h-3.5 ${i < r ? "fill-warning text-warning" : "text-muted"}`} />
                    ))}
                  </div>
                  <span className="text-muted-foreground">& acima</span>
                </button>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Stores */}
      <div>
        <button onClick={() => toggleSection("store")} className="flex items-center justify-between w-full text-sm font-semibold text-foreground mb-3">
          Loja
          <ChevronDown className={`w-4 h-4 transition-transform ${openSections.store ? "rotate-180" : ""}`} />
        </button>
        <AnimatePresence>
          {openSections.store && (
            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden space-y-2">
              {stores.map((store) => (
                <label key={store} className="flex items-center gap-2 px-3 py-1.5 rounded-lg hover:bg-secondary cursor-pointer transition-colors">
                  <input type="checkbox" className="rounded border-border accent-accent w-4 h-4" />
                  <span className="text-sm text-foreground">{store}</span>
                </label>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );

  return (
    <>
      {/* Desktop */}
      <aside className="hidden lg:block w-64 shrink-0">
        <div className="sticky top-20 bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
          {content}
        </div>
      </aside>

      {/* Mobile overlay */}
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
