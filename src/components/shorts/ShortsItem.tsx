import { useRef, useEffect, useState, useCallback } from "react";
import { ExternalLink, Volume2, VolumeX, Heart, MessageCircle, Bookmark, Play, Pause, Music, Share2, TrendingUp } from "lucide-react";

import { toast } from "sonner";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import type { ShortProduct } from "@/hooks/useOfertaShorts";
import ShortsCommentPanel from "@/components/shorts/ShortsCommentPanel";
import ShortsInfoPanel from "@/components/shorts/ShortsInfoPanel";

interface Props {
  product: ShortProduct;
  muted: boolean;
  onMuteChange: (muted: boolean) => void;
  onEnd: () => void; // chamado quando o vídeo/slideshow termina
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
      // enablejsapi=1 obrigatório para postMessage (detectar fim do vídeo)
      // Sem loop=1 para que o vídeo termine e dispare o auto-advance
      const embedUrl = `https://www.youtube.com/embed/${id}?autoplay=1&mute=${muteParam}&playsinline=1&rel=0&modestbranding=1&controls=1&enablejsapi=1`;
      return { kind: "youtube", embedUrl, rawUrl: raw };
    }
  }

  // Vimeo
  const vimeoMatch = raw.match(/vimeo\.com\/(\d+)/);
  if (vimeoMatch) {
    const id = vimeoMatch[1];
    const muteParam = muted ? "1" : "0";
    // Sem loop para que o vídeo termine e dispare o auto-advance
    const embedUrl = `https://player.vimeo.com/video/${id}?autoplay=1&muted=${muteParam}&background=0`;
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

const ShortsItem = ({ product, muted, onMuteChange, onEnd }: Props) => {
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
  const [showInfo, setShowInfo] = useState(false);
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
  // Ref para onEnd (evita stale closure nos listeners)
  const onEndRef = useRef(onEnd);
  useEffect(() => { onEndRef.current = onEnd; }, [onEnd]);

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

  // Pausa música e vídeo quando a página/aba fica invisível (ex: tela desligada ou mudança de aba)
  useEffect(() => {
    const handleVisibilityChange = () => {
      if (document.hidden) {
        if (!hasVideo && audioRef.current) audioRef.current.pause();
        else if (hasVideo && !isEmbed && videoRef.current) {
          videoRef.current.pause();
          setIsPlaying(false);
        } 
        else if (hasVideo && isEmbed) setIframeMounted(false);
      } else {
        if (isVisibleRef.current) {
          if (!hasVideo && audioRef.current && isPlaying) {
            audioRef.current.play().catch(() => {});
          } else if (hasVideo && !isEmbed && videoRef.current && isPlaying) {
            videoRef.current.play().catch(() => {});
          } else if (hasVideo && isEmbed) {
            setIframeMounted(true);
          }
        }
      }
    };

    document.addEventListener("visibilitychange", handleVisibilityChange);
    return () => document.removeEventListener("visibilitychange", handleVisibilityChange);
  }, [hasVideo, isEmbed, isPlaying]);

  // Lógica de avanço do carrossel (resume/start)
  const startSlideshow = useCallback(() => {
    if (slideTimerRef.current) clearInterval(slideTimerRef.current);
    slideTimerRef.current = setInterval(() => {
      setSlideIndex((prev) => {
        const nextSlide = prev + 1;
        if (nextSlide >= allImages.length) {
          clearInterval(slideTimerRef.current!);
          onEndRef.current();
          return prev;
        }
        return nextSlide;
      });
    }, 3000);
    if (audioRef.current) audioRef.current.play().catch(() => {});
    setIsPlaying(true);
  }, [allImages.length]);

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
            if (!audioRef.current) {
              audioRef.current = new Audio(selectedTrackRef.current);
              audioRef.current.loop = true;
              audioRef.current.muted = mutedRef.current; // usa ref para evitar stale closure
              audioRef.current.volume = 0.5;
            }
            startSlideshow();
          } else {
            if (slideTimerRef.current) clearInterval(slideTimerRef.current);
            audioRef.current?.pause();
            setIsPlaying(false);
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
  }, [hasVideo, isEmbed, allImages.length, startSlideshow]);

  // Detecta fim de vídeo em iframes (YouTube state=0, Vimeo 'finish')
  useEffect(() => {
    if (!isEmbed) return;
    const handleMessage = (e: MessageEvent) => {
      // YouTube IFrame API
      try {
        const data = typeof e.data === "string" ? JSON.parse(e.data) : e.data;
        // YouTube: {event: "onStateChange", info: 0} => ended
        if (data?.event === "onStateChange" && data?.info === 0) {
          if (isVisibleRef.current) onEndRef.current();
        }
        // Vimeo: {event: "finish"}
        if (data?.event === "finish") {
          if (isVisibleRef.current) onEndRef.current();
        }
      } catch { /* ignore non-JSON messages */ }
    };
    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, [isEmbed]);

  // Tap/clique para play/pause (fotos e vídeo direto)
  const feedbackTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const handleTap = useCallback(() => {
    if (!hasVideo) {
      if (isPlaying) {
        if (slideTimerRef.current) clearInterval(slideTimerRef.current);
        if (audioRef.current) audioRef.current.pause();
        setIsPlaying(false);
        setShowFeedbackIcon("pause");
      } else {
        startSlideshow();
        setShowFeedbackIcon("play");
      }
    } else {
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
    }
    // Esconde o ícone após 700ms
    if (feedbackTimerRef.current) clearTimeout(feedbackTimerRef.current);
    feedbackTimerRef.current = setTimeout(() => setShowFeedbackIcon(null), 700);
  }, [hasVideo, isPlaying, startSlideshow]);

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
        const { error } = await supabase.from("product_likes").delete().eq("user_id", user!.id).eq("product_id", product.id);
        if (error) throw error;
      } else {
        const { error } = await supabase.from("product_likes").insert({ user_id: user!.id, product_id: product.id });
        if (error) throw error;
      }
    } catch (err) {
      console.error("Like error:", err);
      toast.error("Erro ao curtir. Tente novamente.");
      setIsLiked(liked);
    }
    setBusy(false);
  }, [isLiked, user, product.id, busy, requireAuth]);

  const handleSave = useCallback(async () => {
    if (requireAuth() || busy) return;
    setBusy(true);
    const saved = isSaved;
    setIsSaved(!saved);
    try {
      if (saved) {
        const { error } = await supabase.from("wishlists").delete().eq("user_id", user!.id).eq("product_id", product.id);
        if (error) throw error;
      } else {
        const { error } = await supabase.from("wishlists").insert({ user_id: user!.id, product_id: product.id });
        if (error) throw error;
      }
    } catch (err) {
      console.error("Save error:", err);
      toast.error("Houve uma falha ao favoritar produto.");
      setIsSaved(saved);
    }
    setBusy(false);
  }, [isSaved, user, product.id, busy, requireAuth]);

  const handleCommentClick = () => {
    setShowComments(true);
  };

  const handleInfoClick = () => {
    setShowInfo(true);
  };

  const handleShare = async () => {
    const url = `${window.location.origin}/produto/${product.id}`;
    if (navigator.share) {
      try {
        await navigator.share({
          title: product.title,
          text: "Olha essa oferta que eu encontrei no OfertaShop!",
          url: url,
        });
      } catch (err) {
        // user aborted or error
      }
    } else {
      navigator.clipboard.writeText(url);
      toast.success("Link copiado para a área de transferência!");
    }
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
      {/* Panels */}
      <ShortsCommentPanel
        productId={product.id}
        productTitle={product.title}
        open={showComments}
        onClose={() => setShowComments(false)}
      />
      <ShortsInfoPanel
        productId={product.id}
        productTitle={product.title}
        open={showInfo}
        onClose={() => setShowInfo(false)}
      />

      {/* ── Mídia: Vídeo / Iframe / Carrossel de fotos ── */}
      {!hasVideo ? (
        // Carrossel de fotos (slideshow automático)
        allImages.length > 0 ? (
          <div className="absolute inset-0 overflow-hidden bg-black flex items-center justify-center">
            {allImages.map((src, i) => (
              <img
                key={i}
                src={src}
                alt={`${product.title} - foto ${i + 1}`}
                className="absolute inset-0 h-full w-full object-contain transition-opacity duration-700"
                style={{ opacity: i === slideIndex ? 1 : 0 }}
              />
            ))}
            {/* Área de toque para play/pause de fotos */}
            <button
              onClick={handleTap}
              className="absolute inset-0 z-10 w-full h-full cursor-pointer bg-transparent"
              aria-label={isPlaying ? "Pausar galeria" : "Reproduzir galeria"}
            />
            {/* Indicadores de slide */}
            {allImages.length > 1 && (
              <div className="absolute bottom-28 left-1/2 -translate-x-1/2 flex gap-1.5 z-20 pointer-events-none">
                {allImages.map((_, i) => (
                  <div
                    key={i}
                    className={`h-1.5 rounded-full transition-all duration-300 ${
                      i === slideIndex ? "w-5 bg-white" : "w-1.5 bg-white/40"
                    }`}
                  />
                ))}
              </div>
            )}
            {/* Ícone de feedback animado para fotos */}
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
            muted={muted}
            playsInline
            preload="metadata"
            onEnded={onEnd}
          />
          {/* Área de toque para play/pause de vídeo */}
          <button
            onClick={handleTap}
            className="absolute inset-0 z-10 w-full h-full cursor-pointer bg-transparent"
            aria-label={isPlaying ? "Pausar vídeo" : "Reproduzir vídeo"}
          />
          {/* Ícone de feedback animado para vídeo */}
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

      {/* Action Bar Lateral (Curtir, Comentar, Salvar, Ofertas, Compartilhar) */}
      <div className="absolute right-4 bottom-32 z-20 flex flex-col gap-5 items-center">
        {/* Like */}
        <button onClick={handleLike} className="group flex flex-col items-center gap-1">
          <div className="flex h-[42px] w-[42px] items-center justify-center rounded-full backdrop-blur-lg border transition-all duration-300 bg-black/40 border-white/10 text-white group-hover:bg-black/60 shadow-lg">
            <Heart className={`h-5 w-5 transition-transform ${isLiked ? 'fill-red-500 text-red-500 scale-110' : 'scale-100'}`} />
          </div>
        </button>

        {/* Comment */}
        <button onClick={handleCommentClick} className="group flex flex-col items-center gap-1">
          <div className="flex h-[42px] w-[42px] items-center justify-center rounded-full backdrop-blur-lg border transition-colors duration-300 bg-black/40 border-white/10 text-white group-hover:bg-black/60 shadow-lg">
            <MessageCircle className="h-5 w-5" />
          </div>
        </button>

        {/* Info (Preço e Cupons) */}
        <button onClick={handleInfoClick} className="group flex flex-col items-center gap-1">
          <div className="flex h-[42px] w-[42px] items-center justify-center rounded-full backdrop-blur-lg border transition-colors duration-300 bg-black/40 border-white/10 text-white group-hover:bg-black/60 shadow-lg">
            <TrendingUp className="h-5 w-5" />
          </div>
        </button>

        {/* Save/Bookmark */}
        <button onClick={handleSave} className="group flex flex-col items-center gap-1">
          <div className="flex h-[42px] w-[42px] items-center justify-center rounded-full backdrop-blur-lg border transition-all duration-300 bg-black/40 border-white/10 text-white group-hover:bg-black/60 shadow-lg">
            <Bookmark className={`h-5 w-5 transition-transform ${isSaved ? 'fill-yellow-400 text-yellow-400 scale-110' : 'scale-100'}`} />
          </div>
        </button>

        {/* Share */}
        <button onClick={handleShare} className="group flex flex-col items-center gap-1">
          <div className="flex h-[42px] w-[42px] items-center justify-center rounded-full backdrop-blur-lg border transition-colors duration-300 bg-black/40 border-white/10 text-white group-hover:bg-black/60 shadow-lg">
            <Share2 className="h-5 w-5 text-white" />
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
          {/* Preço na cor laranja do accent — igual ao destaque da página do produto */}
          <span className="text-lg font-bold" style={{ color: "hsl(24 95% 55%)" }}>
            {formattedPrice(product.price)}
          </span>
          {product.original_price && product.original_price > product.price && (
            <span className="text-sm text-white/60 line-through">
              {formattedPrice(product.original_price)}
            </span>
          )}
        </div>

        {/* Botão com a mesma aparência do "Acessar Oferta" da página do produto */}
        <a
          href={product.affiliate_url}
          target="_blank"
          rel="noopener noreferrer"
          className="btn-accent mt-3 w-full flex items-center justify-center gap-2 text-base py-3"
          aria-label={`Comprar ${product.title}`}
        >
          Comprar Agora
          <ExternalLink className="h-5 w-5" />
        </a>
      </div>
    </div>
  );
};

export default ShortsItem;