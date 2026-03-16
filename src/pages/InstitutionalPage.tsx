import { useParams, Link } from "react-router-dom";
import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import { ArrowLeft } from "lucide-react";
import { Helmet } from "react-helmet-async";

const InstitutionalPage = () => {
  const { slug } = useParams();
  const [page, setPage] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchPage = async () => {
      if (!slug) return;
      setLoading(true);
      const { data } = await supabase
        .from("institutional_pages" as any)
        .select("*")
        .eq("slug", slug)
        .eq("active", true)
        .maybeSingle();
      setPage(data);
      setLoading(false);
    };
    fetchPage();
  }, [slug]);

  if (loading) {
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
      <div className="min-h-screen bg-background flex flex-col">
        <SiteHeader />
        <div className="flex-1 container mx-auto px-4 py-20 text-center flex flex-col justify-center items-center">
          <h1 className="font-display text-2xl font-bold text-foreground">Página não encontrada</h1>
          <p className="text-muted-foreground mt-2 mb-6">A página que você procura não existe ou foi removida.</p>
          <Link to="/" className="btn-accent">Voltar ao Início</Link>
        </div>
        <SiteFooter />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background flex flex-col">
      <Helmet>
        <title>{page.title} | OfertaShop</title>
      </Helmet>
      <SiteHeader />
      <main className="flex-1 container mx-auto px-4 lg:px-8 py-10">
        <Link to="/" className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-8">
          <ArrowLeft className="w-4 h-4" /> Voltar ao Início
        </Link>
        <div className="max-w-3xl mx-auto bg-card rounded-2xl border border-border p-8 md:p-12 shadow-sm">
          <h1 className="font-display font-bold text-3xl md:text-4xl text-foreground mb-8 text-center">{page.title}</h1>
          <div 
            className="prose prose-sm md:prose-base dark:prose-invert max-w-none 
              prose-headings:font-display prose-a:text-accent hover:prose-a:text-accent/80
              prose-img:rounded-xl prose-hr:border-border"
            dangerouslySetInnerHTML={{ __html: page.content_html || '' }} 
          />
        </div>
      </main>
      <SiteFooter />
    </div>
  );
};

export default InstitutionalPage;
