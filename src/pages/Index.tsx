import { useState } from "react";
import { SlidersHorizontal } from "lucide-react";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import FilterSidebar from "@/components/FilterSidebar";
import ProductCard from "@/components/ProductCard";
import HeroCarousel from "@/components/HeroCarousel";
import { products } from "@/data/products";

const Index = () => {
  const [selectedCategory, setSelectedCategory] = useState("Todos");
  const [mobileFilters, setMobileFilters] = useState(false);

  const filtered = selectedCategory === "Todos"
    ? products
    : products.filter((p) => p.category === selectedCategory);

  return (
    <div className="min-h-screen bg-background">
      <SiteHeader />

      <main className="container mx-auto px-4 lg:px-8 py-6">
        {/* Hero */}
        <section className="mb-8">
          <HeroCarousel />
        </section>

        {/* Mobile filter toggle */}
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
            mobileOpen={mobileFilters}
            onClose={() => setMobileFilters(false)}
          />

          {/* Product Grid */}
          <section className="flex-1">
            <div className="flex items-center justify-between mb-6">
              <h2 className="font-display font-bold text-xl text-foreground">
                {selectedCategory === "Todos" ? "Todas as Ofertas" : selectedCategory}
              </h2>
              <span className="text-sm text-muted-foreground">{filtered.length} ofertas</span>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5">
              {filtered.map((product, i) => (
                <ProductCard key={product.id} product={product} index={i} />
              ))}
            </div>
          </section>
        </div>
      </main>

      <SiteFooter />
    </div>
  );
};

export default Index;
