import { useState, useMemo, useEffect } from "react";
import { SlidersHorizontal } from "lucide-react";
import { useSearchParams } from "react-router-dom";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import FilterSidebar from "@/components/FilterSidebar";
import ProductCard from "@/components/ProductCard";
import HeroCarousel from "@/components/HeroCarousel";
import { useProducts } from "@/hooks/useProducts";

const Index = () => {
  const [searchParams] = useSearchParams();
  const query = searchParams.get("q") || "";

  const [selectedCategory, setSelectedCategory] = useState("Todos");
  const [priceRange, setPriceRange] = useState([0, 5000]);
  const [minRating, setMinRating] = useState(0);
  const [selectedStores, setSelectedStores] = useState<string[]>([]);
  const [mobileFilters, setMobileFilters] = useState(false);
  const { data: products = [], isLoading } = useProducts();

  const availableStores = useMemo(() => {
    const stores = products.map(p => p.store).filter(Boolean);
    return [...new Set(stores)].sort();
  }, [products]);

  const handleStoreToggle = (store: string) => {
    setSelectedStores(prev =>
      prev.includes(store) ? prev.filter(s => s !== store) : [...prev, store]
    );
  };

  const handleClearFilters = () => {
    setSelectedCategory("Todos");
    setPriceRange([0, 5000]);
    setMinRating(0);
    setSelectedStores([]);
  };

  const filtered = products.filter((p) => {
    const matchesSearch = query === "" || p.title.toLowerCase().includes(query.toLowerCase()) || (p.description && p.description.toLowerCase().includes(query.toLowerCase()));
    const categoryMatch = selectedCategory === "Todos" || p.category === selectedCategory;
    const priceMatch = p.price >= priceRange[0] && p.price <= priceRange[1];
    const ratingMatch = p.rating >= minRating;
    const storeMatch = selectedStores.length === 0 || selectedStores.includes(p.store);
    return matchesSearch && categoryMatch && priceMatch && ratingMatch && storeMatch;
  });

  return (
    <div className="min-h-screen bg-background">
      <SiteHeader />

      <main className="container mx-auto px-4 lg:px-8 py-6">
        <section className="mb-8">
          <HeroCarousel />
        </section>

        <div className="lg:hidden mb-4">
          <button
            onClick={() => setMobileFilters(true)}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-card border border-border text-sm font-medium text-foreground"
            style={{ boxShadow: "var(--shadow-card)" }}
          >
            <SlidersHorizontal className="w-4 h-4" />
            Filtros
          </button>
        </div>

        <div className="flex gap-8">
          <FilterSidebar
            selectedCategory={selectedCategory}
            onCategoryChange={setSelectedCategory}
            priceRange={priceRange}
            onPriceRangeChange={setPriceRange}
            minRating={minRating}
            onMinRatingChange={setMinRating}
            availableStores={availableStores}
            selectedStores={selectedStores}
            onStoreToggle={handleStoreToggle}
            onClearFilters={handleClearFilters}
            mobileOpen={mobileFilters}
            onClose={() => setMobileFilters(false)}
          />

          <section className="flex-1">
            <div className="flex items-center justify-between mb-6">
              <h2 className="font-display font-bold text-xl text-foreground">
                {selectedCategory === "Todos" ? "Todas as Ofertas" : selectedCategory}
              </h2>
              <span className="text-sm text-muted-foreground">{filtered.length} ofertas</span>
            </div>
            {isLoading ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5">
                {Array.from({ length: 6 }).map((_, i) => (
                  <div key={i} className="bg-card rounded-xl border border-border animate-pulse aspect-[3/4]" />
                ))}
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5">
                {filtered.map((product, i) => (
                  <ProductCard key={product.id} product={product} index={i} />
                ))}
              </div>
            )}
          </section>
        </div>
      </main>

      <SiteFooter />
    </div>
  );
};

export default Index;
