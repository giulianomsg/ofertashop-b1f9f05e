import { useState, useEffect } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { useNavigate } from "react-router-dom";
import { useBanners } from "@/hooks/useBanners";

const HeroCarousel = () => {
  const [current, setCurrent] = useState(0);
  const { data: slides = [], isLoading } = useBanners(true);
  const navigateRoute = useNavigate();

  useEffect(() => {
    if (slides.length <= 1) return;
    const timer = setInterval(() => setCurrent((c) => (c + 1) % slides.length), 5000);
    return () => clearInterval(timer);
  }, [slides.length]);

  const navigate = (dir: number) => {
    if (slides.length <= 1) return;
    setCurrent((c) => (c + dir + slides.length) % slides.length);
  };

  if (isLoading || slides.length === 0) {
    return (
      <div className="relative rounded-2xl overflow-hidden aspect-[21/8] bg-secondary animate-pulse" style={{ boxShadow: "var(--shadow-elevated)" }} />
    );
  }

  return (
    <div className="relative rounded-2xl overflow-hidden" style={{ boxShadow: "var(--shadow-elevated)" }}>
      <div className="aspect-[21/8] relative">
        <AnimatePresence mode="wait">
          <motion.div
            key={current}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.5 }}
            className="absolute inset-0"
          >
            <img src={slides[current].image_url} alt="" className="w-full h-full object-cover" />
            <div className="absolute inset-0 bg-gradient-to-r from-foreground/70 via-foreground/30 to-transparent" />
            <div className="absolute inset-0 flex flex-col justify-center px-8 md:px-12 lg:px-16">
              {slides[current].title && (
                <motion.h2
                  initial={{ y: 20, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: 0.2 }}
                  className="font-display font-bold text-2xl md:text-4xl lg:text-5xl text-primary-foreground mb-2"
                >
                  {slides[current].title}
                </motion.h2>
              )}
              {slides[current].subtitle && (
                <motion.p
                  initial={{ y: 20, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: 0.35 }}
                  className="text-primary-foreground/80 text-sm md:text-lg mb-6 max-w-md"
                >
                  {slides[current].subtitle}
                </motion.p>
              )}
              {slides[current].cta_text && (
                <motion.button
                  initial={{ y: 20, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ delay: 0.5 }}
                  onClick={() => {
                    if (slides[current].link_url) {
                      navigateRoute(slides[current].link_url);
                    }
                  }}
                  className="btn-accent w-fit"
                >
                  {slides[current].cta_text}
                </motion.button>
              )}
            </div>
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Nav */}
      {slides.length > 1 && (
        <>
          <button onClick={() => navigate(-1)} className="absolute left-3 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-card/80 backdrop-blur flex items-center justify-center hover:bg-card transition-colors">
            <ChevronLeft className="w-5 h-5 text-foreground" />
          </button>
          <button onClick={() => navigate(1)} className="absolute right-3 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-card/80 backdrop-blur flex items-center justify-center hover:bg-card transition-colors">
            <ChevronRight className="w-5 h-5 text-foreground" />
          </button>
        </>
      )}

      {/* Dots */}
      {slides.length > 1 && (
        <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2">
          {slides.map((_, i) => (
            <button key={i} onClick={() => setCurrent(i)} className={`h-1.5 rounded-full transition-all ${i === current ? "w-8 bg-accent" : "w-4 bg-primary-foreground/40"}`} />
          ))}
        </div>
      )}
    </div>
  );
};

export default HeroCarousel;
