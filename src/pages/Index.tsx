import { useState, useMemo, useEffect } from "react";
import { SlidersHorizontal, ChevronLeft, ChevronRight } from "lucide-react";
import { useSearchParams } from "react-router-dom";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import FilterSidebar from "@/components/FilterSidebar";
import ProductCard from "@/components/ProductCard";
import HeroCarousel from "@/components/HeroCarousel";
import { useProducts } from "@/hooks/useProducts";
import { useCategories, usePlatforms } from "@/hooks/useEntities";

/**
 * NOTA DE DÍVIDA TÉCNICA:
 * A paginação atual é client-side (slice do array local), o que significa
 * que toda a coleção de produtos é carregada de uma vez via useProducts().
 * Para cenários com milhares de produtos, migrar para paginação server-side
 * utilizando os modificadores .range() do Supabase no hook useProducts.
 */
const ITEMS_PER_PAGE = 12;

const Index = () => {
  const [searchParams] = useSearchParams();
  const query = searchParams.get("q") || "";

  const [selectedCategoryId, setSelectedCategoryId] = useState("");
  const [priceRange, setPriceRange] = useState([0, 5000]);
  const [minRating, setMinRating] = useState(0);
  const [selectedPlatforms, setSelectedPlatforms] = useState<string[]>([]);
  const [mobileFilters, setMobileFilters] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const { data: products = [], isLoading } = useProducts();
  const { data: categories = [] } = useCategories();
  const { data: platforms = [] } = usePlatforms();

  const availablePlatforms = useMemo(() => {
    const pIds = products.map((p: any) => p.platform_id).filter(Boolean);
    const uniqueIds = [...new Set(pIds)];
    return uniqueIds
      .map(id => platforms.find((pl: any) => pl.id === id))
      .filter(Boolean)
      .sort((a, b) => a!.name.localeCompare(b!.name));
  }, [products, platforms]);

  const handlePlatformToggle = (platformId: string) => {
    setSelectedPlatforms(prev =>
      prev.includes(platformId) ? prev.filter(id => id !== platformId) : [...prev, platformId]
    );
  };

  const handleClearFilters = () => {
    setSelectedCategoryId("");
    setPriceRange([0, 5000]);
    setMinRating(0);
    setSelectedPlatforms([]);
  };

  // Reset pagination when filters or search change
  useEffect(() => {
    setCurrentPage(1);
  }, [query, selectedCategoryId, priceRange, minRating, selectedPlatforms]);

  const filtered = products.filter((p) => {
    const matchesSearch = query === "" || p.title.toLowerCase().includes(query.toLowerCase()) || (p.description && p.description.toLowerCase().includes(query.toLowerCase()));
    const categoryMatch = selectedCategoryId === "" || (p as any).category_id === selectedCategoryId;
    const priceMatch = p.price >= priceRange[0] && p.price <= priceRange[1];
    const ratingMatch = p.rating >= minRating;
    const platformMatch = selectedPlatforms.length === 0 || selectedPlatforms.includes((p as any).platform_id);
    return matchesSearch && categoryMatch && priceMatch && ratingMatch && platformMatch;
  });

  const totalPages = Math.ceil(filtered.length / ITEMS_PER_PAGE);
  const paginatedProducts = filtered.slice(
    (currentPage - 1) * ITEMS_PER_PAGE,
    currentPage * ITEMS_PER_PAGE
  );

  // Generate page numbers to display (max 5 visible at a time)
  const getPageNumbers = () => {
    const pages: number[] = [];
    let start = Math.max(1, currentPage - 2);
    let end = Math.min(totalPages, start + 4);
    if (end - start < 4) start = Math.max(1, end - 4);
    for (let i = start; i <= end; i++) pages.push(i);
    return pages;
  };

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
            selectedCategoryId={selectedCategoryId}
            onCategoryChange={setSelectedCategoryId}
            categories={categories}
            priceRange={priceRange}
            onPriceRangeChange={setPriceRange}
            minRating={minRating}
            onMinRatingChange={setMinRating}
            availablePlatforms={availablePlatforms as any}
            selectedPlatforms={selectedPlatforms}
            onPlatformToggle={handlePlatformToggle}
            onClearFilters={handleClearFilters}
            mobileOpen={mobileFilters}
            onClose={() => setMobileFilters(false)}
          />

          <section className="flex-1">
            <div className="flex items-center justify-between mb-6">
              <h2 className="font-display font-bold text-xl text-foreground">
                {selectedCategoryId === "" ? "Todas as Ofertas" : categories.find(c => c.id === selectedCategoryId)?.name}
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
              <>
                <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5">
                  {paginatedProducts.map((product, i) => (
                    <ProductCard key={product.id} product={product} index={(currentPage - 1) * ITEMS_PER_PAGE + i} />
                  ))}
                </div>

                {/* Pagination Controls */}
                {totalPages > 1 && (
                  <nav className="flex items-center justify-center gap-1.5 mt-10" aria-label="Paginação">
                    <button
                      onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                      disabled={currentPage === 1}
                      className="inline-flex items-center gap-1.5 px-3 py-2 rounded-lg border border-border bg-card text-sm font-medium text-foreground hover:bg-secondary transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
                      aria-label="Página anterior"
                    >
                      <ChevronLeft className="w-4 h-4" />
                      <span className="hidden sm:inline">Anterior</span>
                    </button>

                    {getPageNumbers()[0] > 1 && (
                      <>
                        <button
                          onClick={() => setCurrentPage(1)}
                          className="w-10 h-10 rounded-lg border border-border bg-card text-sm font-medium text-foreground hover:bg-secondary transition-colors"
                        >
                          1
                        </button>
                        {getPageNumbers()[0] > 2 && (
                          <span className="w-10 h-10 flex items-center justify-center text-sm text-muted-foreground">…</span>
                        )}
                      </>
                    )}

                    {getPageNumbers().map(page => (
                      <button
                        key={page}
                        onClick={() => setCurrentPage(page)}
                        className={`w-10 h-10 rounded-lg text-sm font-medium transition-colors ${
                          page === currentPage
                            ? "bg-accent text-accent-foreground shadow-sm"
                            : "border border-border bg-card text-foreground hover:bg-secondary"
                        }`}
                        aria-current={page === currentPage ? "page" : undefined}
                        aria-label={`Página ${page}`}
                      >
                        {page}
                      </button>
                    ))}

                    {getPageNumbers()[getPageNumbers().length - 1] < totalPages && (
                      <>
                        {getPageNumbers()[getPageNumbers().length - 1] < totalPages - 1 && (
                          <span className="w-10 h-10 flex items-center justify-center text-sm text-muted-foreground">…</span>
                        )}
                        <button
                          onClick={() => setCurrentPage(totalPages)}
                          className="w-10 h-10 rounded-lg border border-border bg-card text-sm font-medium text-foreground hover:bg-secondary transition-colors"
                        >
                          {totalPages}
                        </button>
                      </>
                    )}

                    <button
                      onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                      disabled={currentPage === totalPages}
                      className="inline-flex items-center gap-1.5 px-3 py-2 rounded-lg border border-border bg-card text-sm font-medium text-foreground hover:bg-secondary transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
                      aria-label="Próxima página"
                    >
                      <span className="hidden sm:inline">Próxima</span>
                      <ChevronRight className="w-4 h-4" />
                    </button>
                  </nav>
                )}
              </>
            )}
          </section>
        </div>
      </main>

      <SiteFooter />
    </div>
  );
};

export default Index;
