import { useEffect, useRef, useCallback, useState } from "react";
import { useOfertaShorts } from "@/hooks/useOfertaShorts";
import ShortsItem from "@/components/shorts/ShortsItem";
import { Loader2, ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";

const OfertaShortsFeed = () => {
  const { items, loading, hasMore, isEmpty, fetchNext } = useOfertaShorts();
  const containerScrollRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();
  const hasFetchedOnce = useRef(false);
  // Preferência de mute compartilhada entre todos os itens
  const [muted, setMuted] = useState(true);

  // Rola suavemente para o próximo item (chamado ao final de cada vídeo/slideshow)
  const scrollToNext = useCallback(() => {
    const container = containerScrollRef.current;
    if (!container) return;
    container.scrollBy({ top: window.innerHeight, behavior: "smooth" });
  }, []);

  // Initial fetch + reset scroll to top
  useEffect(() => {
    if (hasFetchedOnce.current) return;
    hasFetchedOnce.current = true;
    fetchNext().then?.(() => {
      // after items render, snap back to top
      requestAnimationFrame(() => {
        if (containerScrollRef.current) {
          containerScrollRef.current.scrollTop = 0;
        }
      });
    });
    // fallback: always reset scroll after a short delay
    const t = setTimeout(() => {
      if (containerScrollRef.current) {
        containerScrollRef.current.scrollTop = 0;
      }
    }, 150);
    return () => clearTimeout(t);
  }, [fetchNext]);

  // Loop infinito via IntersectionObserver no sentinel
  const observerRef = useRef<IntersectionObserver | null>(null);
  const sentinelCallback = useCallback(
    (node: HTMLDivElement | null) => {
      if (observerRef.current) observerRef.current.disconnect();
      if (!node) return;
      observerRef.current = new IntersectionObserver(
        ([entry]) => {
          if (entry.isIntersecting && !loading) {
            fetchNext();
          }
        },
        { threshold: 0.1 }
      );
      observerRef.current.observe(node);
    },
    [loading, fetchNext]
  );

  return (
    <div
      ref={containerScrollRef}
      className="relative h-[100dvh] w-full overflow-y-scroll snap-y snap-mandatory bg-black"
    >
      {/* Back button – glassmorphism */}
      <button
        onClick={() => navigate(-1)}
        className="fixed left-4 top-4 z-30 flex h-10 w-10 items-center justify-center rounded-full
          backdrop-blur-lg border transition-colors duration-300
          bg-white/10 dark:bg-black/40 border-white/20 dark:border-white/10
          text-white hover:bg-white/20 dark:hover:bg-black/50"
        aria-label="Voltar"
      >
        <ArrowLeft className="h-5 w-5" />
      </button>

      {items.map((product) => (
        <ShortsItem
          key={product._key}
          product={product}
          muted={muted}
          onMuteChange={setMuted}
          onEnd={scrollToNext}
        />
      ))}

      {/* Sentinel — sempre ativo para disparar o loop ao chegar ao fim */}
      <div
        ref={sentinelCallback}
        className="flex h-20 snap-start items-center justify-center"
      >
        {loading && (
          <Loader2 className="h-6 w-6 animate-spin text-white/60" />
        )}
        {isEmpty && !loading && (
          <p className="text-sm text-white/40">Nenhum produto disponível</p>
        )}
      </div>
    </div>
  );
};

export default OfertaShortsFeed;
