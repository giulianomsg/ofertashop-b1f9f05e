import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";

const LOADING_MESSAGES = [
  "🔍 Analisando mercado...",
  "🧠 Processando dados do produto...",
  "✍️ Criando legendas para Feed...",
  "🎬 Roteirizando Reels...",
  "📱 Gerando Story com enquete...",
  "💬 Compondo mensagem WhatsApp...",
  "🎵 Selecionando áudio trending...",
  "🎨 Criando prompts visuais...",
  "✨ Finalizando campanha...",
];

interface GenerationLoaderProps {
  isLoading: boolean;
}

const GenerationLoader = ({ isLoading }: GenerationLoaderProps) => {
  const [messageIndex, setMessageIndex] = useState(0);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    if (!isLoading) {
      setMessageIndex(0);
      setProgress(0);
      return;
    }
    const interval = setInterval(() => {
      setMessageIndex((prev) => (prev + 1) % LOADING_MESSAGES.length);
    }, 2500);
    return () => clearInterval(interval);
  }, [isLoading]);

  useEffect(() => {
    if (!isLoading) return;
    const interval = setInterval(() => {
      setProgress((prev) => Math.min(prev + Math.random() * 8, 95));
    }, 500);
    return () => clearInterval(interval);
  }, [isLoading]);

  if (!isLoading) return null;

  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.95 }}
      className="fixed inset-0 z-50 bg-background/80 backdrop-blur-sm flex items-center justify-center"
    >
      <div className="bg-card rounded-2xl border border-border p-8 max-w-md w-full mx-4 space-y-6 shadow-2xl">
        {/* Animated icon */}
        <div className="flex justify-center">
          <motion.div
            animate={{ rotate: 360 }}
            transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
            className="w-16 h-16 rounded-2xl bg-accent/10 flex items-center justify-center"
          >
            <span className="text-3xl">🤖</span>
          </motion.div>
        </div>

        {/* Message */}
        <div className="text-center min-h-[3rem] flex items-center justify-center">
          <AnimatePresence mode="wait">
            <motion.p
              key={messageIndex}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              className="text-sm font-medium text-foreground"
            >
              {LOADING_MESSAGES[messageIndex]}
            </motion.p>
          </AnimatePresence>
        </div>

        {/* Progress bar */}
        <div className="space-y-2">
          <div className="w-full h-2 bg-secondary rounded-full overflow-hidden">
            <motion.div
              className="h-full bg-accent rounded-full"
              animate={{ width: `${progress}%` }}
              transition={{ duration: 0.3 }}
            />
          </div>
          <p className="text-xs text-muted-foreground text-center">
            Gerando conteúdo multicanal com IA...
          </p>
        </div>
      </div>
    </motion.div>
  );
};

export default GenerationLoader;
