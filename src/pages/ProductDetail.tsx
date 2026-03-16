import { useState, useEffect } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { Star, ExternalLink, ArrowLeft, BadgeCheck, Flame, AlertTriangle, ThumbsUp, Send, TrendingUp, Shield, Sparkles, Share2, Facebook, Twitter, Check, Heart, Bookmark, User as UserIcon } from "lucide-react";
import { motion } from "framer-motion";
import { Helmet } from "react-helmet-async";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import ProductCard from "@/components/ProductCard";
import { useProduct, useProducts, useReviews, usePriceHistory } from "@/hooks/useProducts";
import { usePlatforms, useProductLikes, useUserLiked, useToggleLike, useWishlist, useToggleWishlist, useCategories, useActiveCoupons } from "@/hooks/useEntities";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { useVisitorSession } from "@/hooks/useVisitorSession";
import { Carousel, CarouselContent, CarouselItem, CarouselNext, CarouselPrevious, type CarouselApi } from "@/components/ui/carousel";
import { useRef, useMemo } from "react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, ResponsiveContainer } from "recharts";
import { CouponItem } from "@/components/CouponItem";

const getVideoEmbedUrl = (url: string) => {
  const ytMatch = url.match(/(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([\w-]+)/);
  if (ytMatch) return `https://www.youtube.com/embed/${ytMatch[1]}`;
  const vimeoMatch = url.match(/vimeo\.com\/(\d+)/);
  if (vimeoMatch) return `https://player.vimeo.com/video/${vimeoMatch[1]}`;
  return null;
};

const ProductDetail = () => {
  const { id } = useParams();
  const { data: product, isLoading } = useProduct(id);

  const [api, setApi] = useState<CarouselApi>();
  const [current, setCurrent] = useState(0);
  const videoRef = useRef<HTMLVideoElement>(null);

  const { data: products = [] } = useProducts();
  const { data: categories = [] } = useCategories();
  const { data: reviews = [] } = useReviews(id);
  const { data: platforms = [] } = usePlatforms();
  const { user } = useAuth();
  const { data: likesData } = useProductLikes(id);
  const { data: userLiked = false } = useUserLiked(user?.id, id);
  const toggleLike = useToggleLike();
  const { data: wishlistIds = [] } = useWishlist(user?.id);
  const toggleWishlist = useToggleWishlist();
  const navigate = useNavigate();
  const visitorToken = useVisitorSession();

  const productAny = product as any;
  const { data: priceHistory = [] } = usePriceHistory(productAny?.brand_id, productAny?.model_id);
  const { data: coupons = [] } = useActiveCoupons(productAny?.platform_id);

  const [trustVotes, setTrustVotes] = useState({ sim: 0, nao: 0 });
  const [hasVotedTrust, setHasVotedTrust] = useState<boolean | null>(null); // null = no vote, true = sim, false = nao
  const [localClicks, setLocalClicks] = useState<number>(0);

  const [userRating, setUserRating] = useState(0);
  const [comment, setComment] = useState("");
  const [showExpired, setShowExpired] = useState(false);
  const [reportEmail, setReportEmail] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [copied, setCopied] = useState(false);

  const isWished = wishlistIds.includes(id || "");

  useEffect(() => {
    if (!api) return;

    setCurrent(api.selectedScrollSnap());

    api.on("select", () => {
      setCurrent(api.selectedScrollSnap());
    });
  }, [api]);

  useEffect(() => {
    if (product) {
      setLocalClicks(product.clicks);
    }
  }, [product]);

  useEffect(() => {
    if (!videoRef.current) return;
    
    // If the video slide is active (usually the last slide if there's a video)
    const videoIndex = product?.gallery_urls ? (product.image_url ? 1 : 0) + product.gallery_urls.length : (product?.image_url ? 1 : 0);
    
    if (current === videoIndex) {
      videoRef.current.play().catch(() => {});
    } else {
      videoRef.current.pause();
    }
  }, [current, product]);

  useEffect(() => {
    if (!product) return;
    const fetchVotes = async () => {
      if (!product) return;
      
      const { data: allVotes } = await (supabase as any).from('product_trust_votes')
        .select('is_trusted')
        .eq('product_id', product.id);
        
      if (allVotes) {
        const sim = allVotes.filter((v: any) => v.is_trusted !== false).length;
        const nao = allVotes.filter((v: any) => v.is_trusted === false).length;
        setTrustVotes({ sim, nao });
      }

      if (user) {
        const { data } = await (supabase as any).from('product_trust_votes')
          .select('is_trusted')
          .eq('product_id', product.id)
          .eq('user_id', user.id)
          .maybeSingle();
        if (data) setHasVotedTrust(data.is_trusted !== false);
      }
    };
    fetchVotes();
  }, [product, user]);

  const chartData = useMemo(() => {
    return priceHistory.map((ph: any) => ({
      date: new Date(ph.created_at).toLocaleDateString("pt-BR"),
      price: Number(ph.price),
      loja: ph.products?.store || "Desconhecido",
    }));
  }, [priceHistory]);

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background">
        <SiteHeader />
        <div className="container mx-auto px-4 py-20 text-center">
          <div className="animate-pulse w-16 h-16 rounded-full bg-secondary mx-auto" />
        </div>
      </div>
    );
  }

  if (!product) {
    return (
      <div className="min-h-screen bg-background">
        <SiteHeader />
        <div className="container mx-auto px-4 py-20 text-center">
          <h1 className="font-display text-2xl font-bold text-foreground">Produto não encontrado</h1>
          <Link to="/" className="btn-accent inline-block mt-4">Voltar ao Início</Link>
        </div>
      </div>
    );
  }

  const related = products.filter((p) => p.id !== product.id && p.category_id === product.category_id).slice(0, 3);
  const imageUrl = product.image_url || "/placeholder.svg";
  const categoryName = categories.find(c => c.id === product.category_id)?.name || "Outros";
  const plainDescription = product.description ? product.description.replace(/<[^>]+>/g, '').trim() : "Confira esta oferta incrível no OfertaShop!";
  const currentUrl = typeof window !== 'undefined' ? window.location.href : '';
  const defaultImage = "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1200&auto=format&fit=crop";
  const ogImage = product.image_url || (product.gallery_urls && product.gallery_urls.length > 0 ? product.gallery_urls[0] : defaultImage);
  const shareUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/og-proxy?productId=${id}`;

  const videoUrl = (product as any).video_url;
  const embedUrl = videoUrl ? getVideoEmbedUrl(videoUrl) : null;
  const isMp4 = videoUrl && videoUrl.toLowerCase().endsWith(".mp4");
  const allImages = [product.image_url || "/placeholder.svg", ...(product.gallery_urls || [])];

  // Price comparison: same brand_id + model_id, different platform
  const comparisons = productAny?.brand_id && productAny?.model_id
    ? products.filter((p: any) => p.id !== product.id && p.brand_id === productAny.brand_id && p.model_id === productAny.model_id && p.platform_id !== productAny.platform_id)
    : [];

  const platform = productAny?.platform_id ? platforms.find((p) => p.id === productAny.platform_id) : null;

  const handleLike = () => {
    if (!user) { 
      toast.error("Faça login para curtir."); 
      navigate("/login");
      return; 
    }
    toggleLike.mutate({ userId: user.id, productId: product.id, isLiked: userLiked });
  };

  const handleWishlist = () => {
    if (!user) { 
      toast.error("Faça login para adicionar à lista de desejos."); 
      navigate("/login");
      return; 
    }
    toggleWishlist.mutate({ userId: user.id, productId: product.id, isWished });
  };

  const handleTrustVote = async (isTrusted: boolean) => {
    if (!user) {
      toast.error("Faça login para avaliar a confiança da oferta.");
      navigate("/login");
      return;
    }

    if (hasVotedTrust === isTrusted) {
      // Undo vote
      setTrustVotes(prev => ({
        sim: isTrusted ? prev.sim - 1 : prev.sim,
        nao: !isTrusted ? prev.nao - 1 : prev.nao
      }));
      setHasVotedTrust(null);
      try {
        await (supabase as any).from('product_trust_votes')
          .delete()
          .eq('product_id', product.id)
          .eq('user_id', user.id);
      } catch (e) {}
      return;
    } else if (hasVotedTrust !== null) {
      // Change vote
      setTrustVotes(prev => ({
        sim: isTrusted ? prev.sim + 1 : prev.sim - 1,
        nao: !isTrusted ? prev.nao + 1 : prev.nao - 1
      }));
      setHasVotedTrust(isTrusted);
      try {
        await (supabase as any).from('product_trust_votes')
          .update({ is_trusted: isTrusted })
          .eq('product_id', product.id)
          .eq('user_id', user.id);
      } catch (e) {}
      return;
    }

    // New vote
    setTrustVotes(prev => ({ 
      sim: isTrusted ? prev.sim + 1 : prev.sim, 
      nao: !isTrusted ? prev.nao + 1 : prev.nao 
    }));
    setHasVotedTrust(isTrusted);
    try {
      const insertData = {
        product_id: product.id,
        is_trusted: isTrusted,
        user_id: user.id
      };
      await (supabase as any).from('product_trust_votes').insert(insertData);
    } catch (e) {}
  };

  const handleAccessOffer = async () => {
    setLocalClicks(prev => prev + 1);
    try {
      const insertData = {
        product_id: product.id,
        ...(user ? { user_id: user.id } : { session_token: visitorToken })
      };
      await (supabase as any).from('product_clicks').insert(insertData);
    } catch (e) {
      setLocalClicks(prev => Math.max(0, prev - 1));
    }
  };

  const handleShare = (platform: "whatsapp" | "facebook" | "twitter" | "copy") => {
    const text = `Confira esta oferta incrível: ${product.title}`;
    switch (platform) {
      case "whatsapp": window.open(`https://api.whatsapp.com/send?text=${encodeURIComponent(text + " - " + shareUrl)}`, "_blank"); break;
      case "facebook": window.open(`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl)}`, "_blank"); break;
      case "twitter": window.open(`https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(shareUrl)}`, "_blank"); break;
      case "copy":
        navigator.clipboard.writeText(shareUrl);
        setCopied(true);
        toast.success("Link copiado!");
        setTimeout(() => setCopied(false), 2000);
        break;
    }
  };

  const handleReview = async () => {
    if (!user) { 
      toast.error("Faça login para avaliar."); 
      navigate("/login");
      return; 
    }
    if (userRating === 0) { toast.error("Selecione uma avaliação."); return; }
    setSubmitting(true);
    const { error } = await supabase.from("reviews").insert({
      product_id: product.id, user_id: user.id,
      user_name: user.user_metadata?.full_name || user.email || "Anônimo",
      rating: userRating, comment: comment || null,
    });
    if (error) toast.error("Erro ao enviar avaliação.");
    else { toast.success("Avaliação enviada!"); setUserRating(0); setComment(""); }
    setSubmitting(false);
  };

  const handleReport = async () => {
    if (!reportEmail) { toast.error("Informe seu email."); return; }
    const { error } = await supabase.from("reports").insert({ product_id: product.id, reporter_email: reportEmail, report_type: "Oferta Expirada" });
    if (error) toast.error("Erro ao enviar denúncia.");
    else { toast.success("Denúncia enviada!"); setShowExpired(false); setReportEmail(""); }
  };

  return (
    <div className="min-h-screen bg-background">
      <Helmet>
        <title>{product.title} | OfertaShop</title>
        <meta name="description" content={plainDescription.substring(0, 160)} />
        <meta property="og:type" content="product" />
        <meta property="og:url" content={currentUrl} />
        <meta property="og:title" content={product.title} />
        <meta property="og:description" content={plainDescription} />
        <meta property="og:image" content={ogImage} />
        <meta property="twitter:card" content="summary_large_image" />
        <meta property="twitter:url" content={currentUrl} />
        <meta property="twitter:title" content={product.title} />
        <meta property="twitter:description" content={plainDescription} />
        <meta property="twitter:image" content={ogImage} />
      </Helmet>

      <SiteHeader />
      <main className="container mx-auto px-4 lg:px-8 py-6">
        <Link to="/" className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors mb-6">
          <ArrowLeft className="w-4 h-4" /> Voltar às ofertas
        </Link>

        <div className="flex flex-col md:flex-row gap-8 mb-12 max-w-full overflow-hidden">
          <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} className="space-y-4 w-full md:w-1/2 max-w-full overflow-hidden">
            <Carousel setApi={setApi} className="w-full">
              <CarouselContent>
                {allImages.map((url, i) => (
                  <CarouselItem key={i}>
                    <div className="bg-card rounded-2xl border border-border overflow-hidden aspect-square flex items-center justify-center p-2" style={{ boxShadow: "var(--shadow-card)" }}>
                      <img src={url} alt={`${product.title} - Imagem ${i + 1}`} className="w-full h-full object-contain rounded-xl" />
                    </div>
                  </CarouselItem>
                ))}
                {videoUrl && (
                  <CarouselItem>
                    <div className="bg-card rounded-2xl border border-border overflow-hidden aspect-square flex items-center justify-center p-4 bg-black" style={{ boxShadow: "var(--shadow-card)" }}>
                      {embedUrl ? (
                        <iframe src={embedUrl} className="w-full h-full rounded-xl" allowFullScreen allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" title="Vídeo do produto" />
                      ) : isMp4 ? (
                        <video ref={videoRef} src={videoUrl} controls className="w-full h-full object-contain rounded-xl" />
                      ) : (
                        <a href={videoUrl} target="_blank" rel="noopener noreferrer" className="btn-accent" aria-label="Abrir vídeo">
                          <ExternalLink className="w-5 h-5 mr-2" /> Assistir Vídeo Adicional
                        </a>
                      )}
                    </div>
                  </CarouselItem>
                )}
              </CarouselContent>
              <div className="hidden sm:block">
                <CarouselPrevious className="absolute left-4 top-1/2 -translate-y-1/2 bg-background/80 hover:bg-background border-border backdrop-blur-sm" />
                <CarouselNext className="absolute right-4 top-1/2 -translate-y-1/2 bg-background/80 hover:bg-background border-border backdrop-blur-sm" />
              </div>
            </Carousel>
            
            {/* Thumbnails */}
            {(allImages.length > 1 || videoUrl) && (
              <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-none snap-x">
                {allImages.map((url, i) => (
                  <button 
                    key={i} 
                    onClick={() => api?.scrollTo(i)}
                    className={`relative w-20 h-20 shrink-0 rounded-lg overflow-hidden border-2 transition-all snap-start ${current === i ? "border-accent ring-2 ring-accent/30" : "border-transparent opacity-70 hover:opacity-100"}`}
                  >
                    <img src={url} alt={`Amostra ${i + 1}`} className="w-full h-full object-cover" />
                  </button>
                ))}
                {videoUrl && (
                  <button 
                    onClick={() => api?.scrollTo(allImages.length)}
                    className={`relative w-20 h-20 shrink-0 rounded-lg overflow-hidden border-2 bg-black flex items-center justify-center transition-all snap-start ${current === allImages.length ? "border-accent ring-2 ring-accent/30" : "border-transparent opacity-70 hover:opacity-100"}`}
                  >
                    <div className="w-8 h-8 rounded-full bg-accent/80 flex items-center justify-center">
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="white" xmlns="http://www.w3.org/2000/svg">
                        <path d="M5 3L19 12L5 21V3Z" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                      </svg>
                    </div>
                  </button>
                )}
              </div>
            )}
          </motion.div>

          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} className="space-y-5 w-full md:w-1/2">
            <div>
              <div className="flex items-center gap-2 mb-1">
                {platform?.logo_url && <img src={platform.logo_url} alt={platform.name} className="w-4 h-4 object-contain" />}
                <p className="text-sm text-muted-foreground">{platform?.name || product.store} · {categoryName}</p>
              </div>
              <h1 className="font-display font-bold text-2xl lg:text-3xl text-foreground">{product.title}</h1>
            </div>

            <div className="flex items-center gap-3">
              <div className="flex">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Star key={i} className={`w-5 h-5 ${i < Math.floor(Number(product.rating)) ? "fill-warning text-warning" : "text-muted"}`} />
                ))}
              </div>
              <span className="font-semibold text-foreground">{product.rating}</span>
              <span className="text-sm text-muted-foreground">({product.review_count.toLocaleString()} avaliações)</span>
            </div>

            <div className="bg-secondary rounded-xl p-5 space-y-2">
              <div className="flex items-baseline gap-3">
                <span className="font-display font-bold text-3xl text-foreground">R$ {Number(product.price).toFixed(2).replace(".", ",")}</span>
                {product.original_price && (
                  <span className="text-lg text-muted-foreground line-through">R$ {Number(product.original_price).toFixed(2).replace(".", ",")}</span>
                )}
              </div>
              {product.discount && (
                <span className="badge-hot"><Flame className="w-3 h-3" /> Economia de {product.discount}%</span>
              )}
            </div>

            <div dangerouslySetInnerHTML={{ __html: product.description || '' }} className="text-muted-foreground leading-relaxed [&>p]:mb-2 [&>ul]:list-disc [&>ul]:pl-5 [&>ol]:list-decimal [&>ol]:pl-5 [&>h1]:text-xl [&>h1]:font-bold [&>h2]:text-lg [&>h2]:font-bold [&>h3]:text-base [&>h3]:font-bold [&_a]:text-accent [&_a]:underline" />

            {/* Like, Wishlist, Info badges */}
            <div className="flex flex-wrap gap-3">
              <button onClick={handleLike} className={`flex items-center gap-2 px-3 py-2 rounded-lg border text-sm transition-colors ${userLiked ? "bg-accent/10 border-accent/30 text-accent" : "bg-card border-border text-foreground hover:bg-secondary"}`} aria-label="Curtir produto">
                <ThumbsUp className={`w-4 h-4 ${userLiked ? "fill-current" : ""}`} />
                <span className="font-medium">{likesData?.count || 0}</span>
              </button>
              <button onClick={handleWishlist} className={`flex items-center gap-2 px-3 py-2 rounded-lg border text-sm transition-colors ${isWished ? "bg-destructive/10 border-destructive/30 text-destructive" : "bg-card border-border text-foreground hover:bg-secondary"}`} aria-label="Adicionar à lista de desejos">
                <Heart className={`w-4 h-4 ${isWished ? "fill-current" : ""}`} />
                <span className="font-medium">{isWished ? "Salvo" : "Salvar"}</span>
              </button>
              <div className="flex items-center gap-2 px-3 py-2 rounded-lg bg-card border border-border text-sm">
                <TrendingUp className="w-4 h-4 text-accent" />
                <span className="text-foreground font-medium">{localClicks.toLocaleString()} cliques</span>
              </div>
            </div>

            <div className="bg-card border border-border rounded-xl p-4">
              <div className="flex items-center justify-between mb-3">
                <h3 className="font-semibold text-sm flex items-center gap-2">
                  <Shield className="w-4 h-4 text-success" /> É confiável?
                </h3>
                {trustVotes.sim + trustVotes.nao > 0 && (
                  <span className="text-xs text-muted-foreground">{Math.round((trustVotes.sim / (trustVotes.sim + trustVotes.nao)) * 100)}% confiam</span>
                )}
              </div>
              {trustVotes.sim + trustVotes.nao > 0 && (
                <div className="h-2 w-full bg-secondary rounded-full overflow-hidden mb-3">
                  <div className="h-full bg-success transition-all duration-500" style={{ width: `${(trustVotes.sim / (trustVotes.sim + trustVotes.nao)) * 100}%` }} />
                </div>
              )}
              <div className="flex gap-2">
                <button 
                  onClick={() => handleTrustVote(true)} 
                  className={`flex-1 py-1.5 rounded-lg text-xs font-medium transition-colors ${hasVotedTrust === true ? "bg-success text-success-foreground" : "bg-secondary text-foreground hover:bg-success/20 hover:text-success"}`}
                >
                  Sim ({trustVotes.sim})
                </button>
                <button 
                  onClick={() => handleTrustVote(false)} 
                  className={`flex-1 py-1.5 rounded-lg text-xs font-medium transition-colors ${hasVotedTrust === false ? "bg-destructive text-destructive-foreground" : "bg-secondary text-foreground hover:bg-destructive/20 hover:text-destructive"}`}
                >
                  Não ({trustVotes.nao})
                </button>
              </div>
            </div>

            <a href={product.affiliate_url} target="_blank" rel="noopener noreferrer" onClick={handleAccessOffer} className="btn-accent flex items-center justify-center gap-2 w-full text-base py-3.5" aria-label="Acessar oferta">
              <ExternalLink className="w-5 h-5" /> Acessar Oferta
            </a>

            {/* Share buttons */}
            <div className="flex items-center gap-2 pt-2">
              <span className="text-sm text-muted-foreground mr-2 font-medium flex items-center gap-1.5"><Share2 className="w-4 h-4" /> Partilhar:</span>
              <button onClick={() => handleShare("whatsapp")} className="w-9 h-9 flex items-center justify-center rounded-full bg-[#25D366]/10 text-[#25D366] hover:bg-[#25D366]/20 transition-colors" aria-label="Partilhar no WhatsApp">
                <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round" strokeLinejoin="round"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg>
              </button>
              <button onClick={() => handleShare("facebook")} className="w-9 h-9 flex items-center justify-center rounded-full bg-[#1877F2]/10 text-[#1877F2] hover:bg-[#1877F2]/20 transition-colors" aria-label="Partilhar no Facebook">
                <Facebook className="w-[18px] h-[18px]" />
              </button>
              <button onClick={() => handleShare("twitter")} className="w-9 h-9 flex items-center justify-center rounded-full bg-[#1DA1F2]/10 text-[#0f1419] dark:text-white hover:bg-[#1DA1F2]/20 transition-colors" aria-label="Partilhar no X (Twitter)">
                <Twitter className="w-[18px] h-[18px]" />
              </button>
              <button onClick={() => handleShare("copy")} className="w-9 h-9 flex items-center justify-center rounded-full bg-secondary text-foreground hover:bg-secondary/80 transition-colors ml-auto" aria-label="Copiar link">
                {copied ? <Check className="w-[18px] h-[18px] text-success" /> : <ExternalLink className="w-[18px] h-[18px]" />}
              </button>
            </div>

            <button onClick={() => setShowExpired(!showExpired)} className="flex items-center gap-2 text-sm text-muted-foreground hover:text-destructive transition-colors" aria-label="Reportar oferta expirada">
              <AlertTriangle className="w-4 h-4" /> Oferta expirada?
            </button>
            {showExpired && (
              <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} className="bg-destructive/5 border border-destructive/20 rounded-xl p-4 text-sm text-foreground space-y-3">
                <p>Informe seu email para confirmar a denúncia:</p>
                <input type="email" value={reportEmail} onChange={(e) => setReportEmail(e.target.value)} placeholder="seu@email.com" className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" aria-label="Email para denúncia" />
                <button onClick={handleReport} className="btn-accent !text-xs" aria-label="Confirmar denúncia">Confirmar Denúncia</button>
              </motion.div>
            )}
          </motion.div>
        </div>

        {/* Price Comparison */}
        {comparisons.length > 0 && (
          <section className="mb-12">
            <h2 className="font-display font-bold text-xl text-foreground mb-6">Comparar preços em outras lojas</h2>
            <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-border bg-secondary">
                    <th className="text-left p-4 font-semibold text-foreground">Plataforma</th>
                    <th className="text-left p-4 font-semibold text-foreground">Loja</th>
                    <th className="text-right p-4 font-semibold text-foreground">Preço</th>
                    <th className="text-right p-4 font-semibold text-foreground"></th>
                  </tr>
                </thead>
                <tbody>
                  {comparisons.map((comp: any) => {
                    const compPlatform = platforms.find((p) => p.id === comp.platform_id);
                    return (
                      <tr key={comp.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                        <td className="p-4">
                          <div className="flex items-center gap-2">
                            {compPlatform?.logo_url && <img src={compPlatform.logo_url} alt={compPlatform.name} className="w-5 h-5 object-contain" />}
                            <span className="text-foreground">{compPlatform?.name || "—"}</span>
                          </div>
                        </td>
                        <td className="p-4 text-muted-foreground">{comp.store}</td>
                        <td className="p-4 text-right font-semibold text-foreground">R$ {Number(comp.price).toFixed(2).replace(".", ",")}</td>
                        <td className="p-4 text-right">
                          <a href={comp.affiliate_url} target="_blank" rel="noopener noreferrer" className="btn-accent !text-xs !px-3 !py-1.5 inline-flex items-center gap-1" aria-label={`Ver oferta em ${compPlatform?.name}`}>
                            <ExternalLink className="w-3 h-3" /> Ver Oferta
                          </a>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </section>
        )}

        {/* Coupons */}
        {coupons.length > 0 && (
          <section className="mb-12">
            <h2 className="font-display font-bold text-xl text-foreground mb-6">Cupons de Desconto ({platform?.name || 'Loja'})</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {coupons.map((coupon: any) => (
                <CouponItem key={coupon.id} coupon={coupon} />
              ))}
            </div>
          </section>
        )}

        {/* Price History Chart */}
        {chartData.length > 0 && (
          <section className="mb-12">
            <h2 className="font-display font-bold text-xl text-foreground mb-6">Histórico de Preços</h2>
            <div className="bg-card rounded-xl border border-border p-6 h-[400px]" style={{ boxShadow: "var(--shadow-card)" }}>
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={chartData} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="hsl(var(--border))" />
                  <XAxis dataKey="date" stroke="hsl(var(--muted-foreground))" fontSize={12} tickLine={false} axisLine={false} />
                  <YAxis 
                    stroke="hsl(var(--muted-foreground))" 
                    fontSize={12} 
                    tickLine={false} 
                    axisLine={false} 
                    tickFormatter={(value) => `R$${value}`}
                    domain={['auto', 'auto']}
                  />
                  <RechartsTooltip
                    content={({ active, payload, label }: any) => {
                      if (active && payload && payload.length) {
                        return (
                          <div className="bg-card border border-border p-3 rounded-lg shadow-xl text-sm">
                            <p className="font-semibold text-foreground mb-2">{label}</p>
                            {payload.map((entry: any, index: number) => (
                              <div key={index} className="flex flex-col mb-1 last:mb-0">
                                <span className="text-xs text-muted-foreground">{entry.payload.loja}</span>
                                <span className="font-bold text-accent">R$ {entry.value.toFixed(2).replace(".", ",")}</span>
                              </div>
                            ))}
                          </div>
                        );
                      }
                      return null;
                    }}
                  />
                  <Line 
                    type="monotone" 
                    dataKey="price" 
                    stroke="hsl(var(--accent))" 
                    strokeWidth={3}
                    dot={{ fill: "hsl(var(--accent))", strokeWidth: 2, r: 4 }}
                    activeDot={{ r: 6, fill: "hsl(var(--accent))" }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </section>
        )}

        {/* Reviews */}
        <section className="mb-12">
          <h2 className="font-display font-bold text-xl text-foreground mb-6">Avaliações e Comentários</h2>
          {user && (
            <div className="bg-card rounded-xl border border-border p-5 mb-6" style={{ boxShadow: "var(--shadow-card)" }}>
              <h3 className="font-display font-semibold text-foreground mb-3">Deixe sua avaliação</h3>
              <div className="flex gap-1 mb-3">
                {Array.from({ length: 5 }).map((_, i) => (
                  <button key={i} onClick={() => setUserRating(i + 1)} aria-label={`${i + 1} estrela${i > 0 ? "s" : ""}`}>
                    <Star className={`w-6 h-6 transition-colors ${i < userRating ? "fill-warning text-warning" : "text-muted hover:text-warning"}`} />
                  </button>
                ))}
              </div>
              <textarea value={comment} onChange={(e) => setComment(e.target.value)} placeholder="Compartilhe sua experiência..." className="w-full p-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 resize-none h-24" aria-label="Comentário da avaliação" />
              <button onClick={handleReview} disabled={submitting} className="btn-accent mt-3 flex items-center gap-2 text-xs disabled:opacity-50" aria-label="Enviar avaliação">
                <Send className="w-3.5 h-3.5" /> Enviar Avaliação
              </button>
            </div>
          )}
          {!user && (
            <div className="bg-secondary rounded-xl p-5 mb-6 text-center">
              <p className="text-sm text-muted-foreground">
                <Link to="/admin/login" className="text-accent font-medium hover:underline">Faça login</Link> para deixar uma avaliação.
              </p>
            </div>
          )}
          <div className="space-y-4">
            {reviews.map((review) => (
              <div key={review.id} className="bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-accent/10 flex items-center justify-center font-display font-bold text-sm text-accent">{review.user_name[0]}</div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">{review.user_name}</p>
                      <p className="text-xs text-muted-foreground">{new Date(review.created_at).toLocaleDateString("pt-BR")}</p>
                    </div>
                  </div>
                  <div className="flex">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Star key={i} className={`w-3.5 h-3.5 ${i < review.rating ? "fill-warning text-warning" : "text-muted"}`} />
                    ))}
                  </div>
                </div>
                {review.comment && <p className="text-sm text-muted-foreground mb-2">{review.comment}</p>}
                <button className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition-colors" aria-label="Marcar como útil">
                  <ThumbsUp className="w-3.5 h-3.5" /> Útil ({review.helpful_count})
                </button>
              </div>
            ))}
            {reviews.length === 0 && (
              <p className="text-sm text-muted-foreground text-center py-8">Nenhuma avaliação ainda. Seja o primeiro!</p>
            )}
          </div>
        </section>

        {related.length > 0 && (
          <section>
            <h2 className="font-display font-bold text-xl text-foreground mb-6">Ofertas Relacionadas</h2>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {related.map((p, i) => (
                <ProductCard key={p.id} product={p} index={i} />
              ))}
            </div>
          </section>
        )}
      </main>
      <SiteFooter />
    </div>
  );
};

export default ProductDetail;
