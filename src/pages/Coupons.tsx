import { useState, useMemo } from "react";
import { SlidersHorizontal } from "lucide-react";
import { Helmet } from "react-helmet-async";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import FilterSidebar from "@/components/FilterSidebar";
import { CouponItem } from "@/components/CouponItem";
import { useGeneralActiveCoupons } from "@/hooks/useEntities";
import { usePlatforms } from "@/hooks/useEntities";

const Coupons = () => {
  const { data: allCoupons = [], isLoading } = useGeneralActiveCoupons();
  const { data: platforms = [] } = usePlatforms();
  const [selectedPlatforms, setSelectedPlatforms] = useState<string[]>([]);
  const [mobileFilters, setMobileFilters] = useState(false);

  const availablePlatforms = useMemo(() => {
    const pIds = allCoupons.map((c: any) => c.platform_id).filter(Boolean);
    const uniqueIds = [...new Set(pIds)];
    return uniqueIds
      .map(id => platforms.find((pl: any) => pl.id === id))
      .filter(Boolean)
      .sort((a, b) => a!.name.localeCompare(b!.name));
  }, [allCoupons, platforms]);

  const handlePlatformToggle = (platformId: string) => {
    setSelectedPlatforms(prev =>
      prev.includes(platformId) ? prev.filter(id => id !== platformId) : [...prev, platformId]
    );
  };

  const handleClearFilters = () => {
    setSelectedPlatforms([]);
  };

  const filtered = allCoupons.filter((c: any) => {
    const platformMatch = selectedPlatforms.length === 0 || selectedPlatforms.includes(c.platform_id);
    return platformMatch;
  });

  return (
    <div className="min-h-screen bg-background">
      <Helmet>
        <title>Cupons de Desconto | OfertaShop</title>
        <meta name="description" content="Aproveite os melhores cupons de desconto e ofertas especiais do OfertaShop." />
      </Helmet>

      <SiteHeader />

      <main className="container mx-auto px-4 lg:px-8 py-6">
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
            hideCategory
            hidePrice
            hideRating
            availablePlatforms={availablePlatforms as any}
            selectedPlatforms={selectedPlatforms}
            onPlatformToggle={handlePlatformToggle}
            onClearFilters={handleClearFilters}
            mobileOpen={mobileFilters}
            onClose={() => setMobileFilters(false)}
          />

          <section className="flex-1 w-full max-w-full overflow-hidden">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-6">
              <h1 className="font-display font-bold text-2xl md:text-3xl text-foreground">
                Cupons de Desconto
              </h1>
              <span className="text-sm font-semibold text-accent bg-accent/10 px-3 py-1 rounded-full w-fit">
                {filtered.length} cupons ativos
              </span>
            </div>

            {isLoading ? (
              <div className="grid grid-cols-1 xl:grid-cols-2 gap-5 w-full">
                {Array.from({ length: 4 }).map((_, i) => (
                  <div key={i} className="bg-card rounded-xl border border-border animate-pulse h-40 w-full" />
                ))}
              </div>
            ) : filtered.length === 0 ? (
              <div className="text-center bg-card border border-border rounded-xl py-16 px-4">
                <p className="text-muted-foreground text-lg">Nenhum cupom disponível no momento para as plataformas selecionadas.</p>
                <button onClick={handleClearFilters} className="mt-4 text-accent font-semibold hover:underline">Limpar filtros</button>
              </div>
            ) : (
              <div className="grid grid-cols-1 xl:grid-cols-2 gap-5 w-full">
                {filtered.map((coupon: any) => (
                  <CouponItem key={coupon.id} coupon={coupon} />
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

export default Coupons;
