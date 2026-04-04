import { useRef, useEffect, useState, useCallback } from "react";
import { ExternalLink, Volume2, VolumeX, Heart, MessageCircle, Bookmark, Play, Pause } from "lucide-react";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import type { ShortProduct } from "@/hooks/useOfertaShorts";
import ShortsCommentPanel from "@/components/shorts/ShortsCommentPanel";

interface Props {
  product: ShortProduct;
  muted: boolean;
  onMuteChange: (muted: boolean) => void;
}

// ---------------------------------------------------------------------------
// Helpers para detectar e construir URL de embed
// ---------------------------------------------------------------------------

type VideoKind = "youtube" | "vimeo" | "direct";

interface VideoInfo {
  kind: VideoKind;
  /** URL de embed pronta para uso no iframe (YouTube/Vimeo) */
  embedUrl: string | null;
  /** URL bruta original para o <video> */
  rawUrl: string;
}

function parseVideoUrl(url: string, muted: boolean): VideoInfo {
  const raw = url.trim();

  // YouTube: watch?v=, youtu.be/, /shorts/, /embed/
  const ytPatterns = [
    /(?:youtube\.com\/(?:watch\?v=|shorts\/|embed\/))([A-Za-z0-9_-]{11})/,
    /(?:youtu\.be\/)([A-Za-z0-9_-]{11})/,
  ];
  for (const pattern of ytPatterns) {
    const m = raw.match(pattern);
    if (m) {
      const id = m[1];
      const muteParam = muted ? 1 : 0;
      // enablejsapi=1 obrigatório para postMessage (pausar via JS)
      const embedUrl = `https://www.youtube.com/embed/${id}?autoplay=1&loop=1&playlist=${id}&mute=${muteParam}&playsinline=1&rel=0&modestbranding=1&controls=1&enablejsapi=1`;
      return { kind: "youtube", embedUrl, rawUrl: raw };
    }
  }

  // Vimeo
  const vimeoMatch = raw.match(/vimeo\.com\/(\d+)/);
  if (vimeoMatch) {
    const id = vimeoMatch[1];
    const muteParam = muted ? "1" : "0";
    const embedUrl = `https://player.vimeo.com/video/${id}?autoplay=1&loop=1&muted=${muteParam}&background=0`;
    return { kind: "vimeo", embedUrl, rawUrl: raw };
  }

  // Vídeo direto (mp4, webm, etc.)
  return { kind: "direct", embedUrl: null, rawUrl: raw };
}

// ---------------------------------------------------------------------------

const ShortsItem = ({ product, muted, onMuteChange }: Props) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const iframeRef = useRef<HTMLIFrameElement>(null);
  const { user } = useAuth();

  const [isLiked, setIsLiked] = useState(false);
  const [isSaved, setIsSaved] = useState(false);
  const [busy, setBusy] = useState(false);
  const [showComments, setShowComments] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  const [showFeedbackIcon, setShowFeedbackIcon] = useState<"play" | "pause" | null>(null);
  // Força reload do iframe quando muted muda (para passar novo parâmetro na URL)
  const [iframeKey, setIframeKey] = useState(0);

  const videoUrl = product.video_url ?? "";
  const videoInfo = parseVideoUrl(videoUrl, muted);
  const isEmbed = videoInfo.kind !== "direct";

  // Refs para controle fino (sem stale closures)
  const isVisibleRef = useRef(false);   // está em tela agora?
  const mutedRef = useRef(muted);       // valor atual de muted sem closure stale
  const iframeLoadedMutedRef = useRef(muted); // muted usado no último load do iframe

  // Mantém mutedRef sincronizado com o prop
  useEffect(() => { mutedRef.current = muted; }, [muted]);

  // Fetch initial liked/saved state when user is logged in
  useEffect(() => {
    if (!user) { setIsLiked(false); setIsSaved(false); return; }
    let cancelled = false;

    const check = async () => {
      const [likeRes, wishRes] = await Promise.all([
        supabase.from("product_likes").select("id").eq("user_id", user.id).eq("product_id", product.id).maybeSingle(),
        supabase.from("wishlists").select("id").eq("user_id", user.id).eq("product_id", product.id).maybeSingle(),
      ]);
      if (cancelled) return;
      setIsLiked(!!likeRes.data);
      setIsSaved(!!wishRes.data);
    };
    check();
    return () => { cancelled = true; };
  }, [user, product.id]);

  // Helpers para controlar playback de iframes via postMessage
  const pauseIframe = useCallback(() => {
    const iframe = iframeRef.current;
    if (!iframe?.contentWindow) return;
    if (videoInfo.kind === "youtube") {
      iframe.contentWindow.postMessage(
        JSON.stringify({ event: "command", func: "pauseVideo", args: [] }),
        "*"
      );
    } else if (videoInfo.kind === "vimeo") {
      iframe.contentWindow.postMessage(
        JSON.stringify({ method: "pause" }),
        "*"
      );
    }
  }, [videoInfo.kind]);

  const playIframe = useCallback(() => {
    const iframe = iframeRef.current;
    if (!iframe?.contentWindow) return;
    if (videoInfo.kind === "youtube") {
      iframe.contentWindow.postMessage(
        JSON.stringify({ event: "command", func: "playVideo", args: [] }),
        "*"
      );
    } else if (videoInfo.kind === "vimeo") {
      iframe.contentWindow.postMessage(
        JSON.stringify({ method: "play" }),
        "*"
      );
    }
  }, [videoInfo.kind]);

  // IntersectionObserver unificado: controla vídeo direto E iframes
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    const videoEl = videoRef.current; // captura local para cleanup

    const obs = new IntersectionObserver(
      ([entry]) => {
        if (isEmbed) {
          if (entry.isIntersecting) {
            isVisibleRef.current = true;
            // Se a preferência de mute mudou enquanto estava fora de tela,
            // recarrega o iframe com a URL correta (só para este item)
            if (iframeLoadedMutedRef.current !== mutedRef.current) {
              iframeLoadedMutedRef.current = mutedRef.current;
              setIframeKey((k) => k + 1);
            } else {
              playIframe();
            }
          } else {
            isVisibleRef.current = false;
            pauseIframe();
          }
        } else {
          if (!videoEl) return;
          if (entry.isIntersecting) {
            isVisibleRef.current = true;
            videoEl.play().catch(() => { });
            setIsPlaying(true);
          } else {
            isVisibleRef.current = false;
            videoEl.pause();
            setIsPlaying(false);
          }
        }
      },
      { threshold: 0.5 }
    );

    obs.observe(el);
    return () => {
      obs.disconnect();
      if (isEmbed) pauseIframe();
      else videoEl?.pause();
    };
  }, [isEmbed, pauseIframe, playIframe]);

  // Tap/clique para play/pause (somente vídeo direto)
  const feedbackTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const handleVideoTap = useCallback(() => {
    const video = videoRef.current;
    if (!video) return;
    if (video.paused) {
      video.play().catch(() => {});
      setIsPlaying(true);
      setShowFeedbackIcon("play");
    } else {
      video.pause();
      setIsPlaying(false);
      setShowFeedbackIcon("pause");
    }
    // Esconde o ícone após 700ms
    if (feedbackTimerRef.current) clearTimeout(feedbackTimerRef.current);
    feedbackTimerRef.current = setTimeout(() => setShowFeedbackIcon(null), 700);
  }, []);

  const formattedPrice = (v: number) =>
    v.toLocaleString("pt-BR", { style: "currency", currency: "BRL" });

  const requireAuth = useCallback(() => {
    if (!user) { toast.error("Faça login para realizar esta ação"); return true; }
    return false;
  }, [user]);

  const handleLike = useCallback(async () => {
    if (requireAuth() || busy) return;
    setBusy(true);
    const liked = isLiked;
    setIsLiked(!liked);
    try {
      if (liked) {
        await supabase.from("product_likes").delete().eq("user_id", user!.id).eq("product_id", product.id);
      } else {
        await supabase.from("product_likes").insert({ user_id: user!.id, product_id: product.id });
      }
    } catch { setIsLiked(liked); }
    setBusy(false);
  }, [isLiked, user, product.id, busy, requireAuth]);

  const handleSave = useCallback(async () => {
    if (requireAuth() || busy) return;
    setBusy(true);
    const saved = isSaved;
    setIsSaved(!saved);
    try {
      if (saved) {
        await supabase.from("wishlists").delete().eq("user_id", user!.id).eq("product_id", product.id);
      } else {
        await supabase.from("wishlists").insert({ user_id: user!.id, product_id: product.id, price_when_favorited: product.price });
      }
    } catch { setIsSaved(saved); }
    setBusy(false);
  }, [isSaved, user, product.id, product.price, busy, requireAuth]);

  const handleCommentClick = () => {
    setShowComments(true);
  };

  const handleToggleMute = () => {
    const newMuted = !muted;
    onMuteChange(newMuted); // propaga para o feed (afeta próximos vídeos)
    // Se este item é um iframe e está visível, recarrega imediatamente com o novo mute
    if (isEmbed && isVisibleRef.current) {
      iframeLoadedMutedRef.current = newMuted;
      setIframeKey((k) => k + 1);
    }
  };

  // URL do embed final (recalculada quando muted muda, triggering iframeKey)
  const currentEmbedUrl = parseVideoUrl(videoUrl, muted).embedUrl ?? "";

  return (
    <div
      ref={containerRef}
      className="relative h-[100dvh] w-full snap-start flex-shrink-0 overflow-hidden bg-black"
    >
      {/* Comments panel */}
      <ShortsCommentPanel
        productId={product.id}
        productTitle={product.title}
        open={showComments}
        onClose={() => setShowComments(false)}
      />

      {/* ── Vídeo / iframe ── */}
      {isEmbed ? (
        <iframe
          key={iframeKey}
          ref={iframeRef}
          src={currentEmbedUrl}
          className="absolute inset-0 h-full w-full border-0"
          allow="autoplay; fullscreen; picture-in-picture; encrypted-media"
          allowFullScreen
          title={product.title}
        />
      ) : (
        <>
          <video
            ref={videoRef}
            src={videoInfo.rawUrl}
            poster={product.image_url ?? undefined}
            className="absolute inset-0 h-full w-full object-cover"
            loop
            muted={muted}
            playsInline
            preload="metadata"
          />
          {/* Área de toque para play/pause */}
          <button
            onClick={handleVideoTap}
            className="absolute inset-0 z-10 w-full h-full cursor-pointer bg-transparent"
            aria-label={isPlaying ? "Pausar vídeo" : "Reproduzir vídeo"}
          />
          {/* Ícone de feedback animado */}
          {showFeedbackIcon && (
            <div
              key={showFeedbackIcon}
              className="absolute inset-0 z-20 flex items-center justify-center pointer-events-none"
            >
              <div
                className="flex h-20 w-20 items-center justify-center rounded-full bg-black/50 backdrop-blur-md"
                style={{ animation: "shorts-feedback 0.6s ease-out forwards" }}
              >
                {showFeedbackIcon === "play"
                  ? <Play className="h-10 w-10 fill-white text-white" />
                  : <Pause className="h-10 w-10 fill-white text-white" />
                }
              </div>
            </div>
          )}
        </>
      )}

      {/* Gradient base for readability */}
      <div className="pointer-events-none absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent dark:from-black/70" />

      {/* Mute toggle – glassmorphism */}
      <button
        onClick={handleToggleMute}
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