import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sparkles, Wand2, Instagram, MessageCircle, Video, Palette, Copy, Smartphone } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useProducts } from "@/hooks/useProducts";
import { useQuery } from "@tanstack/react-query";
import { toast } from "sonner";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import CopyBlock from "@/components/admin/ai/CopyBlock";
import ReelsScriptTable from "@/components/admin/ai/ReelsScriptTable";
import StoryMockup from "@/components/admin/ai/StoryMockup";
import GenerationLoader from "@/components/admin/ai/GenerationLoader";

const TONES = [
  { value: "persuasivo", label: "Persuasivo" },
  { value: "urgente", label: "Urgente" },
  { value: "divertido", label: "Divertido" },
  { value: "informativo", label: "Informativo" },
  { value: "premium", label: "Premium/Luxo" },
  { value: "casual", label: "Casual" },
];

const TRIGGERS = [
  { value: "urgencia", label: "Urgência" },
  { value: "escassez", label: "Escassez" },
  { value: "prova_social", label: "Prova Social" },
  { value: "autoridade", label: "Autoridade" },
  { value: "reciprocidade", label: "Reciprocidade" },
  { value: "exclusividade", label: "Exclusividade" },
];

interface ProContent {
  feed?: { legendas: string[] };
  reels?: { audio_sugerido: string; cenas: any[] };
  stories?: { texto_curto: string; enquete: { pergunta: string; opcao1: string; opcao2: string } };
  whatsapp?: { mensagem: string; versao_curta: string };
  tiktok_shorts?: { roteiro: string };
  prompts_visuais?: { feed_background: string; story_background: string };
}

const AdminAIGenerator = () => {
  const { data: products = [] } = useProducts(false);
  const [selectedProductId, setSelectedProductId] = useState("");
  const [tone, setTone] = useState("persuasivo");
  const [trigger, setTrigger] = useState("urgencia");
  const [selectedPersonaId, setSelectedPersonaId] = useState("");
  const [selectedCampaignId, setSelectedCampaignId] = useState("");
  const [includeHashtags, setIncludeHashtags] = useState(true);
  const [includeCTA, setIncludeCTA] = useState(true);
  const [optimizeSEO, setOptimizeSEO] = useState(false);
  const [loading, setLoading] = useState(false);
  const [content, setContent] = useState<ProContent | null>(null);
  const [usedModel, setUsedModel] = useState("");

  const { data: personas = [] } = useQuery({
    queryKey: ["ai-personas"],
    queryFn: async () => {
      const { data } = await (supabase as any).from("ai_personas").select("*").order("name");
      return data || [];
    },
  });

  const { data: campaigns = [] } = useQuery({
    queryKey: ["ai-campaigns-active"],
    queryFn: async () => {
      const { data } = await (supabase as any).from("ai_campaigns").select("*").eq("status", "ACTIVE").order("name");
      return data || [];
    },
  });

  const selectedProduct = products.find((p) => p.id === selectedProductId);
  const selectedPersona = personas.find((p: any) => p.id === selectedPersonaId);

  const handleGenerate = async () => {
    if (!selectedProduct) {
      toast.error("Selecione um produto.");
      return;
    }
    setLoading(true);
    setContent(null);
    try {
      const { data, error } = await supabase.functions.invoke("generate-social-copy-pro", {
        body: {
          product: selectedProduct,
          settings: {
            persona: selectedPersona || null,
            tone,
            trigger,
            campaignName: campaigns.find((c: any) => c.id === selectedCampaignId)?.name || "",
            campaignType: campaigns.find((c: any) => c.id === selectedCampaignId)?.type || "",
            includeHashtags,
            includeCTA,
            optimizeSEO,
          },
        },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);
      setContent(data.content);
      setUsedModel(data.model || "");
      toast.success("Campanha gerada com sucesso!");
    } catch (err: any) {
      toast.error(err.message || "Erro ao gerar conteúdo.");
    } finally {
      setLoading(false);
    }
  };

  const selectClass = "w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors";

  return (
    <div className="space-y-6">
      <GenerationLoader isLoading={loading} />

      <div className="flex items-center gap-3">
        <div className="p-2.5 rounded-xl bg-accent/10">
          <Sparkles className="w-6 h-6 text-accent" />
        </div>
        <div>
          <h2 className="font-display font-bold text-xl text-foreground">Central de Geração de Conteúdo</h2>
          <p className="text-sm text-muted-foreground">Gere campanhas multicanal com IA</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-5 gap-6">
        {/* Left: Settings */}
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="text-sm">⚙️ Configurações</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {/* Product */}
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Produto</label>
              <select value={selectedProductId} onChange={(e) => setSelectedProductId(e.target.value)} className={selectClass}>
                <option value="">Selecione um produto...</option>
                {products.map((p) => (
                  <option key={p.id} value={p.id}>{p.title}</option>
                ))}
              </select>
            </div>

            {/* Campaign */}
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Campanha Sazonal</label>
              <select value={selectedCampaignId} onChange={(e) => setSelectedCampaignId(e.target.value)} className={selectClass}>
                <option value="">Nenhuma</option>
                {campaigns.map((c: any) => (
                  <option key={c.id} value={c.id}>{c.name} ({c.type})</option>
                ))}
              </select>
            </div>

            {/* Tone */}
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Tom de Voz</label>
              <select value={tone} onChange={(e) => setTone(e.target.value)} className={selectClass}>
                {TONES.map((t) => <option key={t.value} value={t.value}>{t.label}</option>)}
              </select>
            </div>

            {/* Trigger */}
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Gatilho de Venda</label>
              <select value={trigger} onChange={(e) => setTrigger(e.target.value)} className={selectClass}>
                {TRIGGERS.map((t) => <option key={t.value} value={t.value}>{t.label}</option>)}
              </select>
            </div>

            {/* Persona */}
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Persona</label>
              <select value={selectedPersonaId} onChange={(e) => setSelectedPersonaId(e.target.value)} className={selectClass}>
                <option value="">Nenhuma</option>
                {personas.map((p: any) => (
                  <option key={p.id} value={p.id}>{p.name}</option>
                ))}
              </select>
            </div>

            {/* Switches */}
            <div className="space-y-3 pt-2">
              <div className="flex items-center justify-between">
                <label className="text-xs font-medium text-foreground">Incluir Hashtags</label>
                <Switch checked={includeHashtags} onCheckedChange={setIncludeHashtags} />
              </div>
              <div className="flex items-center justify-between">
                <label className="text-xs font-medium text-foreground">Incluir CTA</label>
                <Switch checked={includeCTA} onCheckedChange={setIncludeCTA} />
              </div>
              <div className="flex items-center justify-between">
                <label className="text-xs font-medium text-foreground">Otimizar para SEO</label>
                <Switch checked={optimizeSEO} onCheckedChange={setOptimizeSEO} />
              </div>
            </div>

            {/* Generate button */}
            <Button onClick={handleGenerate} disabled={loading || !selectedProductId} className="w-full" size="lg">
              <Wand2 className="w-4 h-4 mr-2" />
              Criar Campanha com IA
            </Button>
          </CardContent>
        </Card>

        {/* Right: Results */}
        <div className="lg:col-span-3">
          {!content ? (
            <Card className="h-full flex items-center justify-center min-h-[400px]">
              <CardContent className="text-center space-y-3">
                <Sparkles className="w-12 h-12 text-muted-foreground/30 mx-auto" />
                <p className="text-muted-foreground text-sm">Selecione um produto e clique em "Criar Campanha" para gerar conteúdo multicanal.</p>
              </CardContent>
            </Card>
          ) : (
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="text-sm">✨ Conteúdo Gerado</CardTitle>
                  {usedModel && (
                    <span className="text-[10px] px-2 py-0.5 rounded-full bg-accent/10 text-accent font-medium">
                      {usedModel.split("/").pop()}
                    </span>
                  )}
                </div>
              </CardHeader>
              <CardContent>
                <Tabs defaultValue="feed">
                  <TabsList className="w-full grid grid-cols-6">
                    <TabsTrigger value="feed" className="text-xs"><Instagram className="w-3 h-3 mr-1" />Feed</TabsTrigger>
                    <TabsTrigger value="reels" className="text-xs"><Video className="w-3 h-3 mr-1" />Reels</TabsTrigger>
                    <TabsTrigger value="story" className="text-xs"><Smartphone className="w-3 h-3 mr-1" />Story</TabsTrigger>
                    <TabsTrigger value="whatsapp" className="text-xs"><MessageCircle className="w-3 h-3 mr-1" />WhatsApp</TabsTrigger>
                    <TabsTrigger value="tiktok" className="text-xs"><Video className="w-3 h-3 mr-1" />TikTok</TabsTrigger>
                    <TabsTrigger value="design" className="text-xs"><Palette className="w-3 h-3 mr-1" />Design</TabsTrigger>
                  </TabsList>

                  <TabsContent value="feed" className="space-y-3 mt-4">
                    {content.feed?.legendas?.map((leg, i) => (
                      <CopyBlock key={i} label={`Legenda #${i + 1}`} icon={Instagram} content={leg} accentClass="border-l-2 border-accent" />
                    ))}
                  </TabsContent>

                  <TabsContent value="reels" className="mt-4">
                    <ReelsScriptTable scenes={content.reels?.cenas || []} audioSugerido={content.reels?.audio_sugerido} />
                  </TabsContent>

                  <TabsContent value="story" className="mt-4">
                    <StoryMockup
                      textoCurto={content.stories?.texto_curto || ""}
                      enquete={content.stories?.enquete || { pergunta: "", opcao1: "", opcao2: "" }}
                    />
                  </TabsContent>

                  <TabsContent value="whatsapp" className="space-y-3 mt-4">
                    <CopyBlock label="Mensagem para Grupo" icon={MessageCircle} content={content.whatsapp?.mensagem || ""} accentClass="border-l-2 border-accent" />
                    <CopyBlock label="Versão Curta (Lista)" icon={MessageCircle} content={content.whatsapp?.versao_curta || ""} accentClass="border-l-2 border-accent/50" />
                  </TabsContent>

                  <TabsContent value="tiktok" className="mt-4">
                    <CopyBlock label="Roteiro TikTok/Shorts" icon={Video} content={content.tiktok_shorts?.roteiro || ""} accentClass="border-l-2 border-accent" />
                  </TabsContent>

                  <TabsContent value="design" className="space-y-3 mt-4">
                    <CopyBlock label="Prompt: Fundo Feed (Midjourney)" icon={Palette} content={content.prompts_visuais?.feed_background || ""} accentClass="border-l-2 border-accent" />
                    <CopyBlock label="Prompt: Fundo Story (Midjourney)" icon={Palette} content={content.prompts_visuais?.story_background || ""} accentClass="border-l-2 border-accent/50" />
                  </TabsContent>
                </Tabs>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
};

export default AdminAIGenerator;
