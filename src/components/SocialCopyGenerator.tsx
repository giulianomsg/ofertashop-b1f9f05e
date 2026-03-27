import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sparkles, Loader2, Copy, Check, Instagram, MessageCircle, Video, X } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";

interface SocialCopyContent {
  instagram_captions: string[];
  whatsapp_message: string;
  reels_hook: string;
}

interface SocialCopyGeneratorProps {
  product: any;
  open: boolean;
  onClose: () => void;
}

const CopyBlock = ({ label, icon: Icon, content, className = "" }: { label: string; icon: any; content: string; className?: string }) => {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(content);
    setCopied(true);
    toast.success("Copiado!");
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className={`bg-secondary rounded-lg p-4 space-y-2 ${className}`}>
      <div className="flex items-center justify-between">
        <span className="text-xs font-semibold text-muted-foreground flex items-center gap-1.5 uppercase tracking-wider">
          <Icon className="w-3.5 h-3.5" /> {label}
        </span>
        <button onClick={handleCopy} className="p-1.5 rounded-md hover:bg-background transition-colors">
          {copied ? <Check className="w-3.5 h-3.5 text-emerald-500" /> : <Copy className="w-3.5 h-3.5 text-muted-foreground" />}
        </button>
      </div>
      <p className="text-sm text-foreground whitespace-pre-wrap leading-relaxed">{content}</p>
    </div>
  );
};

const SocialCopyGenerator = ({ product, open, onClose }: SocialCopyGeneratorProps) => {
  const [loading, setLoading] = useState(false);
  const [content, setContent] = useState<SocialCopyContent | null>(null);

  const handleGenerate = async () => {
    setLoading(true);
    setContent(null);
    try {
      const { data, error } = await supabase.functions.invoke("generate-social-copy", {
        body: { product },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);
      if (data?.content) {
        setContent(data.content);
        toast.success("Conteúdo gerado com sucesso!");
      }
    } catch (err: any) {
      toast.error(err.message || "Erro ao gerar conteúdo");
    } finally {
      setLoading(false);
    }
  };

  const handleCopyAll = () => {
    if (!content) return;
    const allText = [
      "📸 INSTAGRAM (3 variações):",
      ...content.instagram_captions.map((c, i) => `\n--- Variação ${i + 1} ---\n${c}`),
      "\n\n📱 WHATSAPP:",
      content.whatsapp_message,
      "\n\n🎬 REELS/STORIES HOOK:",
      content.reels_hook,
    ].join("\n");
    navigator.clipboard.writeText(allText);
    toast.success("Todo o conteúdo copiado!");
  };

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-accent" />
            Gerador de Copy / Social
          </DialogTitle>
        </DialogHeader>

        {/* Product info */}
        <div className="flex items-center gap-3 p-3 rounded-lg bg-secondary border border-border">
          {product?.image_url && (
            <img src={product.image_url} alt="" className="w-12 h-12 rounded-lg object-cover" />
          )}
          <div className="flex-1 min-w-0">
            <p className="font-medium text-sm text-foreground line-clamp-1">{product?.title}</p>
            <p className="text-xs text-muted-foreground">
              {product?.store} • R$ {Number(product?.price || 0).toFixed(2).replace(".", ",")}
              {product?.original_price && (
                <span className="ml-1 line-through">R$ {Number(product.original_price).toFixed(2).replace(".", ",")}</span>
              )}
            </p>
          </div>
        </div>

        {/* Generate button */}
        <button
          onClick={handleGenerate}
          disabled={loading}
          className="btn-accent w-full flex items-center justify-center gap-2 py-3"
        >
          {loading ? (
            <><Loader2 className="w-4 h-4 animate-spin" /> Gerando com IA...</>
          ) : (
            <><Sparkles className="w-4 h-4" /> {content ? "Regenerar Conteúdo" : "Gerar Conteúdo com IA"}</>
          )}
        </button>

        {/* Results */}
        <AnimatePresence>
          {content && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-4"
            >
              <div className="flex items-center justify-between">
                <h3 className="text-sm font-semibold text-foreground">Conteúdo Gerado</h3>
                <button onClick={handleCopyAll} className="text-xs text-accent hover:underline flex items-center gap-1">
                  <Copy className="w-3 h-3" /> Copiar tudo
                </button>
              </div>

              {/* Instagram Captions */}
              {content.instagram_captions?.map((caption, i) => (
                <CopyBlock
                  key={i}
                  label={`Instagram #${i + 1}`}
                  icon={Instagram}
                  content={caption}
                />
              ))}

              {/* WhatsApp */}
              {content.whatsapp_message && (
                <CopyBlock
                  label="WhatsApp"
                  icon={MessageCircle}
                  content={content.whatsapp_message}
                  className="border-l-2 border-emerald-500"
                />
              )}

              {/* Reels Hook */}
              {content.reels_hook && (
                <CopyBlock
                  label="Reels / Stories Hook"
                  icon={Video}
                  content={content.reels_hook}
                  className="border-l-2 border-pink-500"
                />
              )}
            </motion.div>
          )}
        </AnimatePresence>
      </DialogContent>
    </Dialog>
  );
};

export default SocialCopyGenerator;
