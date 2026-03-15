import { useParams, Link } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { ArrowLeft } from "lucide-react";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import ProductCard from "@/components/ProductCard";
import { useQuery } from "@tanstack/react-query";
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
        <h1 className="font-display font-bold text-3xl text-foreground mb-2">{page.title}</h1>
        {page.description && <p className="text-muted-foreground mb-8">{page.description}</p>}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {products.map((p: any, i: number) => (
            <ProductCard key={p.id} product={p} index={i} />
          ))}
        </div>
        {products.length === 0 && (
          <p className="text-center text-muted-foreground py-12">Nenhum produto nesta página especial ainda.</p>
        )}
      </main>
      <SiteFooter />
    </div>
  );
};

export default SpecialPage;
