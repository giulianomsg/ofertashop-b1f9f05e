import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sparkles, Loader2, Copy, Check, Instagram, MessageCircle, Video, Wand2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";

interface SocialCopyContent {
  instagram_captions: string[];
  whatsapp_message: string;
  reels_hook: string;
  video_description?: string;
}

interface SocialCopyGeneratorProps {
  product: any;
  open: boolean;
  onClose: () => void;
}

const CopyBlock = ({ label, icon: Icon, content, accentClass = "" }: { label: string; icon: any; content: string; accentClass?: string }) => {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(content);
    setCopied(true);
    toast.success("Copiado!");
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className={`bg-secondary rounded-lg p-4 space-y-2 ${accentClass}`}>
      <div className="flex items-center justify-between">
        <span className="text-xs font-semibold text-muted-foreground flex items-center gap-1.5 uppercase tracking-wider">
          <Icon className="w-3.5 h-3.5" /> {label}
        </span>
        <button onClick={handleCopy} className="p-1.5 rounded-md hover:bg-background transition-colors" title="Copiar">
          {copied ? <Check className="w-3.5 h-3.5 text-emerald-500" /> : <Copy className="w-3.5 h-3.5 text-muted-foreground" />}
        </button>
      </div>
      <p className="text-sm text-foreground whitespace-pre-wrap leading-relaxed">{content}</p>
    </div>
  );
};

type TabKey = "instagram" | "whatsapp" | "reels";

const TABS: { key: TabKey; label: string; icon: typeof Instagram }[] = [
  { key: "instagram", label: "Instagram", icon: Instagram },
  { key: "whatsapp", label: "WhatsApp", icon: MessageCircle },
  { key: "reels", label: "Reels/Stories", icon: Video },
];

const SocialCopyGenerator = ({ product, open, onClose }: SocialCopyGeneratorProps) => {
  const [loading, setLoading] = useState(false);
  const [content, setContent] = useState<SocialCopyContent | null>(null);
  const [activeTab, setActiveTab] = useState<TabKey>("instagram");
  const [usedModel, setUsedModel] = useState<string>("");
  const [loadingSaved, setLoadingSaved] = useState(false);

  // Load previously saved content when modal opens
  useEffect(() => {
    if (!open || !product?.id) return;
    const loadSaved = async () => {
      setLoadingSaved(true);
      try {
        const { data } = await supabase
          .from("products")
          .select("extra_metadata")
          .eq("id", product.id)
          .single();
        const saved = (data as any)?.extra_metadata?.social_copy;
        if (saved?.content) {
          setContent(saved.content);
          setUsedModel(saved.model || "");
        }
      } catch (_e) {}
      setLoadingSaved(false);
    };
    loadSaved();
  }, [open, product?.id]);

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
        setUsedModel(data.model || "");

        // Save to product extra_metadata for future reference
        const { data: existing } = await supabase
          .from("products")
          .select("extra_metadata")
          .eq("id", product.id)
          .single();
        const currentMeta = (existing as any)?.extra_metadata || {};
        await (supabase as any).from("products").update({
          extra_metadata: {
            ...currentMeta,
            social_copy: {
              content: data.content,
              model: data.model || "",
              generated_at: new Date().toISOString(),
            },
          },
        }).eq("id", product.id);

        toast.success("Conteúdo gerado e salvo com sucesso!");
      }
    } catch (err: any) {
      toast.error(err.message || "Erro ao gerar conteúdo. Verifique a configuração em IA / Conteúdo.");
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
      ...(content.video_description ? ["\n\n🎥 DESCRIÇÃO DO VÍDEO:", content.video_description] : []),
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
            Gerador de Conteúdo IA
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
            <><Wand2 className="w-4 h-4" /> {content ? "Regenerar Conteúdo" : "Gerar Conteúdo com IA"}</>
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
              {/* Header with model badge */}
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <h3 className="text-sm font-semibold text-foreground">Conteúdo Gerado</h3>
                  {usedModel && (
                    <span className="text-[10px] px-2 py-0.5 rounded-full bg-accent/10 text-accent font-medium">
                      {usedModel.split("/").pop()}
                    </span>
                  )}
                </div>
                <button onClick={handleCopyAll} className="text-xs text-accent hover:underline flex items-center gap-1">
                  <Copy className="w-3 h-3" /> Copiar tudo
                </button>
              </div>

              {/* Tabs */}
              <div className="flex rounded-lg bg-secondary p-1 gap-1">
                {TABS.map((tab) => (
                  <button
                    key={tab.key}
                    onClick={() => setActiveTab(tab.key)}
                    className={`flex-1 flex items-center justify-center gap-1.5 px-3 py-2 rounded-md text-xs font-medium transition-all ${
                      activeTab === tab.key
                        ? "bg-card text-foreground shadow-sm"
                        : "text-muted-foreground hover:text-foreground"
                    }`}
                  >
                    <tab.icon className="w-3.5 h-3.5" />
                    {tab.label}
                  </button>
                ))}
              </div>

              {/* Tab Content */}
              <AnimatePresence mode="wait">
                {activeTab === "instagram" && (
                  <motion.div
                    key="instagram"
                    initial={{ opacity: 0, x: -10 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: 10 }}
                    className="space-y-3"
                  >
                    {content.instagram_captions?.map((caption, i) => (
                      <CopyBlock
                        key={i}
                        label={`Legenda #${i + 1}`}
                        icon={Instagram}
                        content={caption}
                        accentClass="border-l-2 border-pink-500"
                      />
                    ))}
                  </motion.div>
                )}

                {activeTab === "whatsapp" && (
                  <motion.div
                    key="whatsapp"
                    initial={{ opacity: 0, x: -10 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: 10 }}
                  >
                    {content.whatsapp_message && (
                      <CopyBlock
                        label="Mensagem WhatsApp"
                        icon={MessageCircle}
                        content={content.whatsapp_message}
                        accentClass="border-l-2 border-emerald-500"
                      />
                    )}
                  </motion.div>
                )}

                {activeTab === "reels" && (
                  <motion.div
                    key="reels"
                    initial={{ opacity: 0, x: -10 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: 10 }}
                    className="space-y-3"
                  >
                    {content.reels_hook && (
                      <CopyBlock
                        label="Hook para Reels / Stories"
                        icon={Video}
                        content={content.reels_hook}
                        accentClass="border-l-2 border-purple-500"
                      />
                    )}
                    {content.video_description && (
                      <CopyBlock
                        label="Descrição do Vídeo"
                        icon={Video}
                        content={content.video_description}
                        accentClass="border-l-2 border-blue-500"
                      />
                    )}
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          )}
        </AnimatePresence>
      </DialogContent>
    </Dialog>
  );
};

export default SocialCopyGenerator;
