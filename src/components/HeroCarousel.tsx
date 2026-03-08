import { useState, useEffect } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import heroBanner1 from "@/assets/hero-banner-1.jpg";
import heroBanner2 from "@/assets/hero-banner-2.jpg";

const slides = [
  {
    image: heroBanner1,
    title: "Ofertas Imperdíveis",
    subtitle: "Até 60% de desconto em eletrônicos selecionados",
    cta: "Ver Ofertas",
  },
  {
    image: heroBanner2,
    title: "Novidades da Semana",
    subtitle: "Os melhores lançamentos com preços exclusivos",
    cta: "Explorar",
  },
];

const HeroCarousel = () => {
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => setCurrent((c) => (c + 1) % slides.length), 5000);
    return () => clearInterval(timer);
  }, []);

  const navigate = (dir: number) => setCurrent((c) => (c + dir + slides.length) % slides.length);

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
            <img src={slides[current].image} alt="" className="w-full h-full object-cover" />
            <div className="absolute inset-0 bg-gradient-to-r from-foreground/70 via-foreground/30 to-transparent" />
            <div className="absolute inset-0 flex flex-col justify-center px-8 md:px-12 lg:px-16">
              <motion.h2
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.2 }}
                className="font-display font-bold text-2xl md:text-4xl lg:text-5xl text-primary-foreground mb-2"
              >
                {slides[current].title}
              </motion.h2>
              <motion.p
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.35 }}
                className="text-primary-foreground/80 text-sm md:text-lg mb-6 max-w-md"
              >
                {slides[current].subtitle}
              </motion.p>
              <motion.button
                initial={{ y: 20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ delay: 0.5 }}
                className="btn-accent w-fit"
              >
                {slides[current].cta}
              </motion.button>
            </div>
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Nav */}
      <button onClick={() => navigate(-1)} className="absolute left-3 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-card/80 backdrop-blur flex items-center justify-center hover:bg-card transition-colors">
        <ChevronLeft className="w-5 h-5 text-foreground" />
      </button>
      <button onClick={() => navigate(1)} className="absolute right-3 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-card/80 backdrop-blur flex items-center justify-center hover:bg-card transition-colors">
        <ChevronRight className="w-5 h-5 text-foreground" />
      </button>

      {/* Dots */}
      <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-2">
        {slides.map((_, i) => (
          <button key={i} onClick={() => setCurrent(i)} className={`h-1.5 rounded-full transition-all ${i === current ? "w-8 bg-accent" : "w-4 bg-primary-foreground/40"}`} />
        ))}
      </div>
    </div>
  );
};

export default HeroCarousel;
