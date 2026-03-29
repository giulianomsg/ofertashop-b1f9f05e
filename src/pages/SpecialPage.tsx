import { useParams, Link } from "react-router-dom";
import { useState, useMemo } from "react";
import { Helmet } from "react-helmet-async";
import { ArrowLeft, SlidersHorizontal } from "lucide-react";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import ProductCard from "@/components/ProductCard";
import FilterSidebar from "@/components/FilterSidebar";
import { useQuery } from "@tanstack/react-query";
import { useCategories, usePlatforms } from "@/hooks/useEntities";
import { supabase } from "@/integrations/supabase/client";

const SpecialPage = () => {
  const { slug } = useParams();

  const { data: page, isLoading: pageLoading } = useQuery({
    queryKey: ["special_page", slug],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("special_pages")
        .select("*")
        .eq("slug", slug!)
        .eq("active", true)
        .maybeSingle();
      if (error) throw error;
      return data;
    },
    enabled: !!slug,
  });

  const { data: products = [] } = useQuery({
    queryKey: ["special_page_products", page?.id],
    queryFn: async () => {
      if (!page?.id) return [];
      const { data, error } = await supabase
        .from("special_page_products")
        .select("product_id, products(*)")
        .eq("special_page_id", page.id);
      if (error) throw error;
      return data?.map((d: any) => d.products).filter(Boolean) || [];
    },
    enabled: !!page?.id,
  });

  const { data: categories = [] } = useCategories();
  const { data: platforms = [] } = usePlatforms();

  const [selectedCategoryId, setSelectedCategoryId] = useState("");
  const [priceRange, setPriceRange] = useState([0, 5000]);
  const [minRating, setMinRating] = useState(0);
  const [selectedPlatforms, setSelectedPlatforms] = useState<string[]>([]);
  const [mobileFilters, setMobileFilters] = useState(false);

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

  const filtered = products.filter((p: any) => {
    const categoryMatch = selectedCategoryId === "" || p.category_id === selectedCategoryId;
    const priceMatch = p.price >= priceRange[0] && p.price <= priceRange[1];
    const ratingMatch = p.rating >= minRating;
    const platformMatch = selectedPlatforms.length === 0 || selectedPlatforms.includes(p.platform_id);
    return categoryMatch && priceMatch && ratingMatch && platformMatch;
  });

  if (pageLoading) {
    return (
      <div className="min-h-screen bg-background">
        <SiteHeader />
        <div className="container mx-auto px-4 py-20 text-center">
          <div className="animate-pulse w-16 h-16 rounded-full bg-secondary mx-auto" />
        </div>
      </div>
    );
  }

  if (!page) {
    return (
      <div className="min-h-screen bg-background">
        <SiteHeader />
        <div className="container mx-auto px-4 py-20 text-center">
          <h1 className="font-display text-2xl font-bold text-foreground">Página não encontrada</h1>
          <Link to="/" className="btn-accent inline-block mt-4">Voltar ao Início</Link>
        </div>
        <SiteFooter />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <Helmet>
        <title>{page.title} | OfertaShop</title>
        <meta name="description" content={page.description || `Confira as melhores ofertas de ${page.title} no OfertaShop`} />
        <meta property="og:title" content={`${page.title} | OfertaShop`} />
        <meta property="og:description" content={page.description || `Ofertas especiais de ${page.title}`} />
      </Helmet>
      <SiteHeader />
      <main className="container mx-auto px-4 lg:px-8 py-6">
        <Link to="/" className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-6">
          <ArrowLeft className="w-4 h-4" /> Voltar
        </Link>
        
        <div className="lg:hidden mb-4">
          <button
            onClick={() => setMobileFilters(true)}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-card border border-border text-sm font-medium text-foreground relative z-10"
            style={{ boxShadow: "var(--shadow-card)" }}
          >
            <SlidersHorizontal className="w-4 h-4" />
            Filtros
          </button>
        </div>

        <div className="flex gap-4 lg:gap-8 items-start">
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
          
          <section className="flex-1 w-full max-w-full overflow-hidden">
            <h1 className="font-display font-bold text-3xl text-foreground mb-2">{page.title}</h1>
            {page.description && <p className="text-muted-foreground mb-8">{page.description}</p>}
            
            <div className="flex items-center justify-between mb-6">
              <span className="text-sm font-semibold text-accent bg-accent/10 px-3 py-1 rounded-full w-fit">
                {filtered.length} ofertas
              </span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5 w-full">
              {filtered.map((p: any, i: number) => (
                <ProductCard key={p.id} product={p} index={i} />
              ))}
            </div>
            {filtered.length === 0 && (
              <p className="text-center text-muted-foreground py-12">Nenhum produto atende aos filtros atuais.</p>
            )}
          </section>
        </div>
      </main>
      <SiteFooter />
    </div>
  );
};

export default SpecialPage;
