import { useEffect, useRef, useCallback } from "react";
import { useOfertaShorts } from "@/hooks/useOfertaShorts";
import ShortsItem from "@/components/shorts/ShortsItem";
import { Loader2, ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";

const OfertaShortsFeed = () => {
  const { items, loading, hasMore, fetchNext } = useOfertaShorts();
  const sentinelRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  // Initial fetch
  useEffect(() => {
    fetchNext();
  }, [fetchNext]);

  // Infinite scroll via IntersectionObserver on sentinel
  const observerRef = useRef<IntersectionObserver | null>(null);
  const sentinelCallback = useCallback(
    (node: HTMLDivElement | null) => {
      if (observerRef.current) observerRef.current.disconnect();
      if (!node) return;
      observerRef.current = new IntersectionObserver(
        ([entry]) => {
          if (entry.isIntersecting && hasMore && !loading) {
            fetchNext();
          }
        },
        { threshold: 0.1 }
      );
      observerRef.current.observe(node);
    },
    [hasMore, loading, fetchNext]
  );

  return (
    <div className="relative h-[100dvh] w-full overflow-y-scroll snap-y snap-mandatory bg-black">
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
        <ShortsItem key={product.id} product={product} />
      ))}

      {/* Sentinel / loader */}
      <div
        ref={sentinelCallback}
        className="flex h-20 snap-start items-center justify-center"
      >
        {loading && (
          <Loader2 className="h-6 w-6 animate-spin text-white/60" />
        )}
        {!hasMore && items.length > 0 && (
          <p className="text-sm text-white/40">Fim dos shorts 🎬</p>
        )}
        {!hasMore && items.length === 0 && !loading && (
          <p className="text-sm text-white/40">Nenhum vídeo disponível</p>
        )}
      </div>
    </div>
  );
};

export default OfertaShortsFeed;
