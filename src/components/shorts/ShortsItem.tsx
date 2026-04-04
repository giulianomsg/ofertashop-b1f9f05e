import { useRef, useEffect, useState } from "react";
import { ExternalLink, Volume2, VolumeX } from "lucide-react";
import { Button } from "@/components/ui/button";
import type { ShortProduct } from "@/hooks/useOfertaShorts";

interface Props {
  product: ShortProduct;
}

const ShortsItem = ({ product }: Props) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const [muted, setMuted] = useState(true);

  // Autoplay/pause based on visibility
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;

    const obs = new IntersectionObserver(
      ([entry]) => {
        const video = videoRef.current;
        if (!video) return;
        if (entry.isIntersecting) {
          video.play().catch(() => {});
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
          <span className="text-lg font-bold text-emerald-400">
            {formattedPrice(product.price)}
          </span>
          {product.original_price && product.original_price > product.price && (
            <span className="text-sm text-white/60 line-through">
              {formattedPrice(product.original_price)}
            </span>
          )}
          {product.discount_percentage && product.discount_percentage > 0 && (
            <span className="ml-auto rounded-full bg-emerald-500/20 px-2 py-0.5 text-xs font-medium text-emerald-300">
              -{Math.round(product.discount_percentage)}%
            </span>
          )}
        </div>

        <Button
          asChild
          className="mt-3 w-full gap-2"
          size="sm"
        >
          <a href={product.affiliate_url} target="_blank" rel="noopener noreferrer">
            Comprar Agora
            <ExternalLink className="h-4 w-4" />
          </a>
        </Button>
      </div>
    </div>
  );
};

export default ShortsItem;
