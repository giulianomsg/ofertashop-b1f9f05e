import { useState, useEffect, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sparkles, Wand2, Instagram, MessageCircle, Video, Palette, Copy, Smartphone, Check, ChevronsUpDown, Download, Mic, ChevronLeft, ChevronRight } from "lucide-react";
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
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Command, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList } from "@/components/ui/command";
import { cn } from "@/lib/utils";

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
  prompts_visuais?: { 
    image_generation_prompt: string;
    audio_generation_prompt?: string;
  };
}

const AdminAIGenerator = () => {
  const { data: products = [] } = useProducts(false);
  const [selectedProductId, setSelectedProductId] = useState("");
  const [productSearchOpen, setProductSearchOpen] = useState(false);
  const [tone, setTone] = useState("persuasivo");
  const [trigger, setTrigger] = useState("urgencia");
  const [selectedPersonaId, setSelectedPersonaId] = useState("");
  const [selectedCampaignId, setSelectedCampaignId] = useState("");
  const [includeHashtags, setIncludeHashtags] = useState(true);
  const [includeCTA, setIncludeCTA] = useState(true);
  const [optimizeSEO, setOptimizeSEO] = useState(false);
  const [loadingPlatform, setLoadingPlatform] = useState<string>("");
  const [content, setContent] = useState<ProContent | null>(null);
  const [usedModel, setUsedModel] = useState("");
  const [prompts, setPrompts] = useState<Record<string, { system: string, user: string }>>({});
  const galleryScrollRef = useRef<HTMLDivElement>(null);

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

  const lastLoadedProductId = useRef<string | null>(null);

  useEffect(() => {
    if (!selectedProductId) {
      setContent(null);
      setUsedModel("");
      lastLoadedProductId.current = null;
      return;
    }

    if (selectedProductId !== lastLoadedProductId.current) {
      const product = products.find((p) => p.id === selectedProductId);
      if (product) {
        lastLoadedProductId.current = selectedProductId;
        if ((product as any).ai_content_metadata?.latest) {
          setContent((product as any).ai_content_metadata.latest);
          const hist = (product as any).ai_content_metadata.history;
          setUsedModel(hist && hist[0] ? hist[0].model + " (Salvo)" : "Recuperado da Base");
          
          if (hist && hist[0]?.settings) {
             if (hist[0].settings.tone) setTone(hist[0].settings.tone);
             if (hist[0].settings.trigger) setTrigger(hist[0].settings.trigger);
          }
        } else {
          setContent(null);
          setUsedModel("");
        }
      }
    }
  }, [selectedProductId, products]);

  const handleGenerate = async (platform: string = "all") => {
    if (!selectedProduct) {
      toast.error("Selecione um produto.");
      return;
    }
    setLoadingPlatform(platform);
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
            platform,
          },
        },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      if (platform === "all") {
        // Campanha completa: substitui tudo
        setContent(data.content || null);
      } else {
        // Plataforma específica: mescla apenas a(s) chave(s) retornadas,
        // preservando o conteúdo das demais abas já gerado em memória.
        setContent((prev) => {
          const incoming = data.content || {};
          if (!prev) return incoming;
          return { ...prev, ...incoming };
        });
      }

      setUsedModel(data.model || "");
      if (data.promptSent) {
        setPrompts((p) => ({ ...p, [platform]: data.promptSent }));
      }
      toast.success(platform === "all" ? "Campanha gerada com sucesso!" : "Conteúdo gerado com sucesso!");
    } catch (err: any) {
      toast.error(err.message || "Erro ao gerar conteúdo.");
    } finally {
      setLoadingPlatform("");
    }
  };

  const PromptDisplay = ({ pPlatform }: { pPlatform: string }) => {
    const pData = prompts[pPlatform] || prompts["all"];
    if (!pData) return null;
    return (
      <div className="mt-4 p-4 rounded-lg bg-muted/30 border border-border text-xs text-muted-foreground space-y-2">
        <p className="font-semibold text-foreground mb-2 flex items-center gap-2"><Sparkles className="w-3 h-3 text-accent" /> Prompt Utilizado</p>
        <details className="cursor-pointer mb-2">
          <summary className="font-medium text-muted-foreground hover:text-foreground">Ver System Prompt (Instruções da IA)</summary>
          <pre className="mt-2 text-[10px] whitespace-pre-wrap break-words bg-background p-2 rounded border border-border">{pData.system}</pre>
        </details>
        <details className="cursor-pointer">
          <summary className="font-medium text-muted-foreground hover:text-foreground">Ver User Prompt (Dados Enviados)</summary>
          <pre className="mt-2 text-[10px] whitespace-pre-wrap break-words bg-background p-2 rounded border border-border">{pData.user}</pre>
        </details>
      </div>
    );
  };

  const selectClass = "w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors";

  return (
    <div className="space-y-6">
      <GenerationLoader isLoading={loadingPlatform !== ""} />

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
              <Popover open={productSearchOpen} onOpenChange={setProductSearchOpen}>
                <PopoverTrigger asChild>
                  <Button
                    variant="outline"
                    role="combobox"
                    aria-expanded={productSearchOpen}
                    className="w-full justify-between bg-secondary border-border"
                  >
                    <span className="truncate">
                      {selectedProductId
                        ? products.find((product) => product.id === selectedProductId)?.title
                        : "Selecione um produto..."}
                    </span>
                    <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                  </Button>
                </PopoverTrigger>
                <PopoverContent className="w-[--radix-popover-trigger-width] p-0" align="start">
                  <Command>
                    <CommandInput placeholder="Buscar produto..." />
                    <CommandList>
                      <CommandEmpty>Nenhum produto encontrado.</CommandEmpty>
                      <CommandGroup>
                        {products.map((product) => (
                          <CommandItem
                            key={product.id}
                            value={product.title}
                            onSelect={() => {
                              setSelectedProductId(product.id === selectedProductId ? "" : product.id);
                              setProductSearchOpen(false);
                            }}
                          >
                            <Check
                              className={cn(
                                "mr-2 h-4 w-4",
                                selectedProductId === product.id ? "opacity-100" : "opacity-0"
                              )}
                            />
                            {product.title}
                          </CommandItem>
                        ))}
                      </CommandGroup>
                    </CommandList>
                  </Command>
                </PopoverContent>
              </Popover>
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
            <Button onClick={() => handleGenerate("all")} disabled={loadingPlatform !== "" || !selectedProductId} className="w-full" size="lg">
              <Wand2 className="w-4 h-4 mr-2" />
              Criar Campanha Completa
            </Button>
          </CardContent>
        </Card>

        {/* Right: Results */}
        <div className="lg:col-span-3">
          {!selectedProductId ? (
            <Card className="h-full flex items-center justify-center min-h-[400px]">
              <CardContent className="text-center space-y-3">
                <Sparkles className="w-12 h-12 text-muted-foreground/30 mx-auto" />
                <p className="text-muted-foreground text-sm">Selecione um produto para gerar conteúdo.</p>
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
                    <TabsTrigger value="stories" className="text-xs"><Smartphone className="w-3 h-3 mr-1" />Story</TabsTrigger>
                    <TabsTrigger value="whatsapp" className="text-xs"><MessageCircle className="w-3 h-3 mr-1" />WhatsApp</TabsTrigger>
                    <TabsTrigger value="tiktok" className="text-xs"><Video className="w-3 h-3 mr-1" />TikTok</TabsTrigger>
                    <TabsTrigger value="design" className="text-xs"><Palette className="w-3 h-3 mr-1" />Design</TabsTrigger>
                  </TabsList>

                  <TabsContent value="feed" className="space-y-3 mt-4">
                    <div className="flex items-center justify-between mb-2">
                       <p className="text-xs text-muted-foreground">Legendas otimizadas para feed.</p>
                       <Button variant="outline" size="sm" onClick={() => handleGenerate("feed")} disabled={loadingPlatform === "feed"} className="h-7 text-xs">
                         <Wand2 className="w-3 h-3 mr-1" /> Regerar Feed
                       </Button>
                    </div>
                    {content?.feed?.legendas ? content.feed.legendas.map((leg, i) => (
                      <CopyBlock key={i} label={`Legenda #${i + 1}`} icon={Instagram} content={leg} accentClass="border-l-2 border-accent" />
                    )) : <p className="text-xs text-muted-foreground p-4 bg-muted/30 rounded text-center">Nenhum conteúdo de feed gerado ainda.</p>}
                    <PromptDisplay pPlatform="feed" />
                  </TabsContent>

                  <TabsContent value="reels" className="mt-4 space-y-3">
                    <div className="flex items-center justify-between mb-2">
                       <p className="text-xs text-muted-foreground">Roteiro para vídeos curtos.</p>
                       <Button variant="outline" size="sm" onClick={() => handleGenerate("reels")} disabled={loadingPlatform === "reels"} className="h-7 text-xs">
                         <Wand2 className="w-3 h-3 mr-1" /> Regerar Reels
                       </Button>
                    </div>
                    {content?.reels?.cenas ? (
                      <ReelsScriptTable scenes={content.reels.cenas} audioSugerido={content.reels.audio_sugerido} />
                    ) : <p className="text-xs text-muted-foreground p-4 bg-muted/30 rounded text-center">Nenhum conteúdo de reels gerado ainda.</p>}
                    <PromptDisplay pPlatform="reels" />
                  </TabsContent>

                  <TabsContent value="stories" className="mt-4 space-y-3">
                    <div className="flex items-center justify-between mb-2">
                       <p className="text-xs text-muted-foreground">Conteúdo rápido para stories com enquete.</p>
                       <Button variant="outline" size="sm" onClick={() => handleGenerate("stories")} disabled={loadingPlatform === "stories"} className="h-7 text-xs">
                         <Wand2 className="w-3 h-3 mr-1" /> Regerar Story
                       </Button>
                    </div>
                    {content?.stories?.texto_curto ? (
                      <StoryMockup
                        textoCurto={content.stories.texto_curto}
                        enquete={content.stories.enquete}
                      />
                    ) : <p className="text-xs text-muted-foreground p-4 bg-muted/30 rounded text-center">Nenhum conteúdo de story gerado ainda.</p>}
                    <PromptDisplay pPlatform="stories" />
                  </TabsContent>

                  <TabsContent value="whatsapp" className="space-y-3 mt-4">
                    <div className="flex items-center justify-between mb-2">
                       <p className="text-xs text-muted-foreground">Mensagens diretas persuasivas.</p>
                       <Button variant="outline" size="sm" onClick={() => handleGenerate("whatsapp")} disabled={loadingPlatform === "whatsapp"} className="h-7 text-xs">
                         <Wand2 className="w-3 h-3 mr-1" /> Regerar WhatsApp
                       </Button>
                    </div>
                    {content?.whatsapp?.mensagem ? (
                      <>
                        <CopyBlock label="Mensagem para Grupo" icon={MessageCircle} content={content.whatsapp.mensagem} accentClass="border-l-2 border-accent" />
                        <CopyBlock label="Versão Curta (Lista)" icon={MessageCircle} content={content.whatsapp.versao_curta} accentClass="border-l-2 border-accent/50" />
                      </>
                    ) : <p className="text-xs text-muted-foreground p-4 bg-muted/30 rounded text-center">Nenhum conteúdo de WhatsApp gerado ainda.</p>}
                    <PromptDisplay pPlatform="whatsapp" />
                  </TabsContent>

                  <TabsContent value="tiktok" className="mt-4 space-y-3">
                    <div className="flex items-center justify-between mb-2">
                       <p className="text-xs text-muted-foreground">Roteiro rápido com hooks fortes.</p>
                       <Button variant="outline" size="sm" onClick={() => handleGenerate("tiktok")} disabled={loadingPlatform === "tiktok"} className="h-7 text-xs">
                         <Wand2 className="w-3 h-3 mr-1" /> Regerar TikTok
                       </Button>
                    </div>
                    {content?.tiktok_shorts?.roteiro ? (
                      <CopyBlock label="Roteiro TikTok/Shorts" icon={Video} content={content.tiktok_shorts.roteiro} accentClass="border-l-2 border-accent" />
                    ) : <p className="text-xs text-muted-foreground p-4 bg-muted/30 rounded text-center">Nenhum conteúdo de TikTok gerado ainda.</p>}
                    <PromptDisplay pPlatform="tiktok" />
                  </TabsContent>

                  <TabsContent value="design" className="space-y-3 mt-4">
                    <div className="flex items-center justify-between mb-2">
                       <p className="text-xs text-muted-foreground">Prompts para Midjourney/DALL-E.</p>
                       <Button variant="outline" size="sm" onClick={() => handleGenerate("design")} disabled={loadingPlatform === "design"} className="h-7 text-xs">
                         <Wand2 className="w-3 h-3 mr-1" /> Regerar Design
                       </Button>
                    </div>
                    {selectedProduct && (selectedProduct.image_url || (selectedProduct as any).gallery_urls?.length) && (() => {
                      const allImgs: string[] = [
                        ...(selectedProduct.image_url ? [selectedProduct.image_url] : []),
                        ...((selectedProduct as any).gallery_urls || []),
                      ].filter(Boolean);
                      const scrollGallery = (dir: number) => {
                        if (galleryScrollRef.current) {
                          galleryScrollRef.current.scrollBy({ left: dir * 96, behavior: 'smooth' });
                        }
                      };
                      return (
                        <div className="mb-4">
                          <p className="text-xs font-medium text-muted-foreground mb-2">Imagens de Referência — {allImgs.length} foto(s) (clique para baixar)</p>
                          <div className="relative flex items-center gap-1">
                            {allImgs.length > 3 && (
                              <button onClick={() => scrollGallery(-1)} className="shrink-0 w-6 h-6 rounded-full bg-muted hover:bg-accent/30 flex items-center justify-center transition-colors">
                                <ChevronLeft className="w-3.5 h-3.5" />
                              </button>
                            )}
                            <div ref={galleryScrollRef} className="flex gap-2 overflow-x-auto scrollbar-hide scroll-smooth flex-1">
                              {allImgs.map((url, i) => (
                                <a key={i} href={url} target="_blank" download className="block shrink-0 overflow-hidden rounded-md border border-border group relative w-20 h-20">
                                  <img src={url} alt={`Ref ${i + 1}`} className="w-full h-full object-cover transition-transform group-hover:scale-110" />
                                  <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                    <Download className="w-4 h-4 text-white" />
                                  </div>
                                </a>
                              ))}
                            </div>
                            {allImgs.length > 3 && (
                              <button onClick={() => scrollGallery(1)} className="shrink-0 w-6 h-6 rounded-full bg-muted hover:bg-accent/30 flex items-center justify-center transition-colors">
                                <ChevronRight className="w-3.5 h-3.5" />
                              </button>
                            )}
                          </div>
                        </div>
                      );
                    })()}

                    {content?.prompts_visuais?.audio_generation_prompt && (
                      <div className="mb-4">
                        <CopyBlock label="🎙️ Prompt de Áudio Emocional" icon={Mic} content={content.prompts_visuais.audio_generation_prompt} accentClass="border-l-2 border-indigo-500" />
                      </div>
                    )}
                    
                    {content?.prompts_visuais?.image_generation_prompt ? (
                      <CopyBlock label="🤖 Prompt Visual c/ Overlay" icon={Palette} content={content.prompts_visuais.image_generation_prompt} accentClass="border-l-2 border-accent" />
                    ) : <p className="text-xs text-muted-foreground p-4 bg-muted/30 rounded text-center">Nenhum prompt visual gerado ainda.</p>}
                    <PromptDisplay pPlatform="design" />
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
