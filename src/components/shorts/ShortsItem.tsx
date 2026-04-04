import { useRef, useEffect, useState } from "react";
import { ExternalLink, Volume2, VolumeX, Heart, MessageCircle, Bookmark } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import type { ShortProduct } from "@/hooks/useOfertaShorts";

interface Props {
  product: ShortProduct;
}

const ShortsItem = ({ product }: Props) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  const [muted, setMuted] = useState(true);
  const [isLiked, setIsLiked] = useState(false);
  const [isSaved, setIsSaved] = useState(false);

  // Autoplay/pause based on visibility
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    const obs = new IntersectionObserver(
      ([entry]) => {
        const video = videoRef.current;
        if (!video) return;
        if (entry.isIntersecting) {
          video.play().catch(() => { });
        } else {
          video.pause();
        }
      },
      { threshold: 0.7 }
    );

    obs.observe(el);
    return () => obs.disconnect();
  }, []);

  const formattedPrice = (v: number) =>
    v.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });

  // Funções de Interação (UI Otimista)
  const handleLike = () => {
    setIsLiked((prev) => !prev);
    // TODO: Disparar mutation para o Supabase (tabela de curtidas)
  };

  const handleSave = () => {
    setIsSaved((prev) => !prev);
    // TODO: Disparar mutation para o Supabase (tabela de favoritos/wishlist)
  };

  const handleCommentClick = () => {
    // Redireciona para a página do produto (assumindo a rota padrão do seu projeto)
    navigate(`/produto/${product.id}`);
  };

  return (
    <div
      ref={containerRef}
      className="relative h-[100dvh] w-full snap-start flex-shrink-0 overflow-hidden bg-black"
    >
      {/* Video */}
      <video
        ref={videoRef}
        src={product.video_url ?? ""}
        poster={product.image_url ?? undefined}
        className="absolute inset-0 h-full w-full object-cover"
        loop
        muted={muted}
        playsInline
        preload="metadata"
      />

      {/* Gradient base for readability */}
      <div className="pointer-events-none absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent dark:from-black/70" />

      {/* Mute toggle – glassmorphism */}
      <button
        onClick={() => setMuted((m) => !m)}
        className="absolute right-4 top-4 z-20 flex h-10 w-10 items-center justify-center rounded-full
          backdrop-blur-lg border transition-colors duration-300
          bg-white/10 dark:bg-black/40 border-white/20 dark:border-white/10
          text-white hover:bg-white/20 dark:hover:bg-black/50"
        aria-label={muted ? "Ativar som" : "Desativar som"}
      >
        {muted ? <VolumeX className="h-5 w-5" /> : <Volume2 className="h-5 w-5" />}
      </button>

      {/* Action Bar Lateral (Curtir, Comentar, Salvar) */}
      <div className="absolute right-4 bottom-32 z-20 flex flex-col gap-6 items-center">
        {/* Like */}
        <button onClick={handleLike} className="group flex flex-col items-center gap-1">
          <div className="flex h-12 w-12 items-center justify-center rounded-full backdrop-blur-lg border transition-all duration-300 bg-white/10 dark:bg-black/40 border-white/20 dark:border-white/10 text-white group-hover:bg-white/20 dark:group-hover:bg-black/50">
            <Heart className={`h-6 w-6 transition-transform ${isLiked ? 'fill-red-500 text-red-500 scale-110' : 'scale-100'}`} />
          </div>
        </button>

        {/* Comment */}
        <button onClick={handleCommentClick} className="group flex flex-col items-center gap-1">
          <div className="flex h-12 w-12 items-center justify-center rounded-full backdrop-blur-lg border transition-colors duration-300 bg-white/10 dark:bg-black/40 border-white/20 dark:border-white/10 text-white group-hover:bg-white/20 dark:group-hover:bg-black/50">
            <MessageCircle className="h-6 w-6" />
          </div>
        </button>

        {/* Save/Bookmark */}
        <button onClick={handleSave} className="group flex flex-col items-center gap-1">
          <div className="flex h-12 w-12 items-center justify-center rounded-full backdrop-blur-lg border transition-all duration-300 bg-white/10 dark:bg-black/40 border-white/20 dark:border-white/10 text-white group-hover:bg-white/20 dark:group-hover:bg-black/50">
            <Bookmark className={`h-6 w-6 transition-transform ${isSaved ? 'fill-yellow-400 text-yellow-400 scale-110' : 'scale-100'}`} />
          </div>
        </button>
      </div>

      {/* Product info overlay – glassmorphism */}
      <div
        className="absolute bottom-4 left-4 right-4 z-10 rounded-2xl p-4 transition-colors duration-300
          backdrop-blur-lg border
          bg-white/10 dark:bg-black/40 border-white/20 dark:border-white/10"
      >
        <h3 className="line-clamp-2 text-base font-semibold leading-snug text-white dark:text-white">
          {product.title}
        </h3>

        <div className="mt-2 flex items-baseline gap-2">
          <span className="text-lg font-bold text-primary text-green-400">
            {formattedPrice(product.price)}
          </span>
          {product.original_price && product.original_price > product.price && (
            <span className="text-sm text-white/60 line-through">
              {formattedPrice(product.original_price)}
            </span>
          )}
        </div>

        <Button
          asChild
          className="mt-3 w-full gap-2 text-md font-bold"
          size="default"
        >
          <a href={product.affiliate_url} target="_blank" rel="noopener noreferrer">
            Comprar Agora
            <ExternalLink className="h-5 w-5" />
          </a>
        </Button>
      </div>
    </div>
  );
};

export default ShortsItem;