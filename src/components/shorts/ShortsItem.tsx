import { useRef, useEffect, useState, useCallback } from "react";
import { ExternalLink, Volume2, VolumeX, Heart, MessageCircle, Bookmark, Play, Pause, Music } from "lucide-react";
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
// Faixas royalty-free para slideshow de fotos (SoundHelix — livres para uso)
// ---------------------------------------------------------------------------
const SLIDESHOW_TRACKS = [
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3",
  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3",
];

const pickRandomTrack = () =>
  SLIDESHOW_TRACKS[Math.floor(Math.random() * SLIDESHOW_TRACKS.length)];

// ---------------------------------------------------------------------------

const ShortsItem = ({ product, muted, onMuteChange }: Props) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const iframeRef = useRef<HTMLIFrameElement>(null);
  const audioRef = useRef<HTMLAudioElement | null>(null);
  const selectedTrackRef = useRef<string>(pickRandomTrack());
  const mutedRef = useRef(muted); // ref para acessar muted dentro do observer sem stale closure
  const { user } = useAuth();

  const [isLiked, setIsLiked] = useState(false);
  const [isSaved, setIsSaved] = useState(false);
  const [busy, setBusy] = useState(false);
  const [showComments, setShowComments] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  const [showFeedbackIcon, setShowFeedbackIcon] = useState<"play" | "pause" | null>(null);
  // Para iframes: só monta no DOM enquanto o item está visível (evita áudio em background)
  const [iframeMounted, setIframeMounted] = useState(false);
  // Chave para forçar remontagem do iframe (ex: mudar mute enquanto visível)
  const [iframeKey, setIframeKey] = useState(0);

  const videoUrl = product.video_url?.trim() ?? "";
  const hasVideo = videoUrl.length > 0;
  const videoInfo = hasVideo ? parseVideoUrl(videoUrl, muted) : { kind: "direct" as const, embedUrl: null, rawUrl: "" };
  const isEmbed = hasVideo && videoInfo.kind !== "direct";

  // Fotos para o carrossel (quando não há vídeo)
  const allImages = [
    ...(product.image_url ? [product.image_url] : []),
    ...(product.gallery_urls ?? []),
  ].filter(Boolean);
  const [slideIndex, setSlideIndex] = useState(0);
  const slideTimerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // Ref de visibilidade (sem stale closure)
  const isVisibleRef = useRef(false);

  // Mantém mutedRef sempre atualizado (sem stale closure no observer)
  useEffect(() => { mutedRef.current = muted; }, [muted]);

  // Sincroniza muted com o áudio de fundo (slideshow de fotos)
  useEffect(() => {
    if (!hasVideo && audioRef.current) {
      audioRef.current.muted = muted;
    }
  }, [muted, hasVideo]);

  // Cleanup do áudio ao desmontar o componente
  useEffect(() => {
    return () => {
      if (audioRef.current) {
        audioRef.current.pause();
        audioRef.current.src = "";
        audioRef.current = null;
      }
    };
  }, []);

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

  // IntersectionObserver: controla visibilidade
  // - iframes: monta/desmonta do DOM (garantia absoluta contra áudio em background)
  // - vídeo direto: play/pause nativo
  // - fotos: inicia/para slideshow automático
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    const videoEl = videoRef.current;

    const obs = new IntersectionObserver(
      ([entry]) => {
        isVisibleRef.current = entry.isIntersecting;

        if (!hasVideo) {
          // Slideshow de fotos + música de fundo
          if (entry.isIntersecting) {
            setSlideIndex(0);
            slideTimerRef.current = setInterval(() => {
              setSlideIndex((i) => (i + 1) % Math.max(allImages.length, 1));
            }, 3000);
            // Inicia música de fundo
            if (!audioRef.current) {
              audioRef.current = new Audio(selectedTrackRef.current);
              audioRef.current.loop = true;
              audioRef.current.muted = mutedRef.current; // usa ref para evitar stale closure
              audioRef.current.volume = 0.5;
            }
            audioRef.current.play().catch(() => {});
          } else {
            if (slideTimerRef.current) clearInterval(slideTimerRef.current);
            // Para música ao sair de tela
            audioRef.current?.pause();
          }
        } else if (isEmbed) {
          // Montar/desmontar o iframe do DOM — única forma garantida de parar áudio
          setIframeMounted(entry.isIntersecting);
        } else {
          if (!videoEl) return;
          if (entry.isIntersecting) {
            videoEl.play().catch(() => { });
            setIsPlaying(true);
          } else {
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
      if (slideTimerRef.current) clearInterval(slideTimerRef.current);
      audioRef.current?.pause();
      if (isEmbed) setIframeMounted(false);
      else videoEl?.pause();
    };
  }, [hasVideo, isEmbed, allImages.length]);

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
    // Se este item está visível e é um iframe: remonta com nova URL de muted
    if (hasVideo && isEmbed && isVisibleRef.current) {
      setIframeKey((k) => k + 1);
    }
  };

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

      {/* ── Mídia: Vídeo / Iframe / Carrossel de fotos ── */}
      {!hasVideo ? (
        // Carrossel de fotos (slideshow automático)
        allImages.length > 0 ? (
          <div className="absolute inset-0 overflow-hidden">
            {allImages.map((src, i) => (
              <img
                key={i}
                src={src}
                alt={`${product.title} - foto ${i + 1}`}
                className="absolute inset-0 h-full w-full object-cover transition-opacity duration-700"
                style={{ opacity: i === slideIndex ? 1 : 0 }}
              />
            ))}
            {/* Indicadores de slide */}
            {allImages.length > 1 && (
              <div className="absolute bottom-28 left-1/2 -translate-x-1/2 flex gap-1.5 z-20">
                {allImages.map((_, i) => (
                  <button
                    key={i}
                    onClick={() => setSlideIndex(i)}
                    className={`h-1.5 rounded-full transition-all duration-300 ${
                      i === slideIndex ? "w-5 bg-white" : "w-1.5 bg-white/40"
                    }`}
                    aria-label={`Foto ${i + 1}`}
                  />
                ))}
              </div>
            )}
          </div>
        ) : (
          <div className="absolute inset-0 bg-zinc-900 flex items-center justify-center">
            <span className="text-white/20 text-sm">Sem imagem</span>
          </div>
        )
      ) : isEmbed ? (
        // Iframe só existe no DOM enquanto visível — garante ausência de áudio em background
        iframeMounted ? (
          <iframe
            key={iframeKey}
            ref={iframeRef}
            src={parseVideoUrl(videoUrl, muted).embedUrl ?? ""}
            className="absolute inset-0 h-full w-full border-0"
            allow="autoplay; fullscreen; picture-in-picture; encrypted-media"
            allowFullScreen
            title={product.title}
          />
        ) : (
          // Poster enquanto o iframe não está montado
          product.image_url ? (
            <img
              src={product.image_url}
              alt={product.title}
              className="absolute inset-0 h-full w-full object-cover"
            />
          ) : (
            <div className="absolute inset-0 bg-zinc-900" />
          )
        )
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

      {/* Botão de mute — visível para vídeos e para fotos com música */}
      {(
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
      )}

      {/* Badge de música tocando (somente slideshow de fotos, não mutado) */}
      {!hasVideo && !muted && (
        <div className="absolute left-4 top-4 z-20 flex items-center gap-2 rounded-full px-3 py-1.5
          backdrop-blur-lg border border-white/20 bg-black/40 text-white">
          <Music className="h-3.5 w-3.5 text-purple-400 animate-pulse" />
          <span className="text-xs font-medium text-white/80">Música aleatória</span>
        </div>
      )}

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