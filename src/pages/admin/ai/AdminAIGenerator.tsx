import { useState, useEffect, useRef } from "react";
import { Sparkles, Wand2, Instagram, MessageCircle, Video, Palette, Download, Check, ChevronsUpDown, ChevronLeft, ChevronRight, Mic, ExternalLink } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useProducts } from "@/hooks/useProducts";
import { toast } from "sonner";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import CopyBlock from "@/components/admin/ai/CopyBlock";
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
];

const TRIGGERS = [
  { value: "urgencia", label: "Urgência" },
  { value: "escassez", label: "Escassez" },
  { value: "prova_social", label: "Prova Social" },
  { value: "autoridade", label: "Autoridade" },
];

interface ProContent {
  feed?: { legendas: string[] };
  whatsapp?: { mensagem: string; versao_curta: string };
  tiktok_shorts?: { roteiro: string };
  prompts_visuais?: { image_generation_prompt: string; audio_generation_prompt?: string; };
}

const AdminAIGenerator = () => {
  const { data: products = [] } = useProducts(false);
  const [selectedProductId, setSelectedProductId] = useState("");
  const [productSearchOpen, setProductSearchOpen] = useState(false);
  const [tone, setTone] = useState("persuasivo");
  const [trigger, setTrigger] = useState("escassez");
  const [loadingPlatform, setLoadingPlatform] = useState<string>("");
  const [content, setContent] = useState<ProContent | null>(null);
  const galleryScrollRef = useRef<HTMLDivElement>(null);

  const selectedProduct = products.find((p) => p.id === selectedProductId);

  useEffect(() => {
    if (!selectedProductId) {
      setContent(null);
      return;
    }
    const product = products.find((p) => p.id === selectedProductId);
    if (product && (product as any).ai_content_metadata?.latest) {
      setContent((product as any).ai_content_metadata.latest as ProContent);
    } else {
      setContent(null);
    }
  }, [selectedProductId, products]);

  const handleGenerate = async (platform: string) => {
    if (!selectedProduct) return toast.error("Selecione um produto.");
    setLoadingPlatform(platform);
    try {
      const { data, error } = await supabase.functions.invoke("generate-social-copy-pro", {
        body: {
          product: selectedProduct,
          settings: { tone, trigger, platform },
        },
      });
      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      setContent((prev) => ({ ...prev, ...(data.content || {}) }));
      toast.success("Conteúdo gerado com sucesso!");
    } catch (err: any) {
      toast.error(err.message || "Erro ao gerar conteúdo.");
    } finally {
      setLoadingPlatform("");
    }
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
          <p className="text-sm text-muted-foreground">Estratégia de curadoria e conversão via automação (Manychat).</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-5 gap-6">
        {/* Left: Settings */}
        <Card className="lg:col-span-2 h-fit">
          <CardHeader>
            <CardTitle className="text-sm">⚙️ Configurações Base</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Produto</label>
              <div className="flex gap-2">
                <Popover open={productSearchOpen} onOpenChange={setProductSearchOpen}>
                  <PopoverTrigger asChild>
                    <Button variant="outline" role="combobox" className="flex-1 justify-between bg-secondary border-border">
                      <span className="truncate">{selectedProduct ? selectedProduct.title : "Selecione..."}</span>
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
                            <CommandItem key={product.id} value={product.title} onSelect={() => { setSelectedProductId(product.id); setProductSearchOpen(false); }}>
                              <Check className={cn("mr-2 h-4 w-4", selectedProductId === product.id ? "opacity-100" : "opacity-0")} />
                              {product.title}
                            </CommandItem>
                          ))}
                        </CommandGroup>
                      </CommandList>
                    </Command>
                  </PopoverContent>
                </Popover>

                {selectedProductId && (
                  <Button
                    variant="outline"
                    size="icon"
                    className="shrink-0 bg-secondary hover:bg-accent hover:text-white transition-colors"
                    onClick={() => window.open(`https://www.ofertashop.com.br/produto/${selectedProductId}`, '_blank')}
                    title="Visitar na loja"
                  >
                    <ExternalLink className="w-4 h-4" />
                  </Button>
                )}
              </div>
            </div>

            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Tom de Voz</label>
              <select value={tone} onChange={(e) => setTone(e.target.value)} className={selectClass}>
                {TONES.map((t) => <option key={t.value} value={t.value}>{t.label}</option>)}
              </select>
            </div>

            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Gatilho de Venda Principal</label>
              <select value={trigger} onChange={(e) => setTrigger(e.target.value)} className={selectClass}>
                {TRIGGERS.map((t) => <option key={t.value} value={t.value}>{t.label}</option>)}
              </select>
            </div>

            <div className="pt-2 text-xs text-muted-foreground p-3 bg-muted/30 rounded-md">
              💡 <strong>Dica:</strong> A geração on-demand foca recursos na plataforma escolhida, evitando timeouts (Erro 546) na IA.
            </div>
          </CardContent>
        </Card>

        {/* Right: Results */}
        <div className="lg:col-span-3">
          {!selectedProductId ? (
            <Card className="h-full flex items-center justify-center min-h-[400px]">
              <CardContent className="text-center space-y-3">
                <Sparkles className="w-12 h-12 text-muted-foreground/30 mx-auto" />
                <p className="text-muted-foreground text-sm">Selecione um produto para gerar ou acessar o conteúdo.</p>
              </CardContent>
            </Card>
          ) : (
            <Card>
              <CardHeader>
                <CardTitle className="text-sm">✨ Canais de Distribuição</CardTitle>
              </CardHeader>
              <CardContent>
                <Tabs defaultValue="feed">
                  <TabsList className="w-full grid grid-cols-4">
                    <TabsTrigger value="feed" className="text-xs"><Instagram className="w-3 h-3 mr-1" />Feed</TabsTrigger>
                    <TabsTrigger value="tiktok" className="text-xs"><Video className="w-3 h-3 mr-1" />TikTok/Reels</TabsTrigger>
                    <TabsTrigger value="whatsapp" className="text-xs"><MessageCircle className="w-3 h-3 mr-1" />WhatsApp</TabsTrigger>
                    <TabsTrigger value="design" className="text-xs"><Palette className="w-3 h-3 mr-1" />Design</TabsTrigger>
                  </TabsList>

                  {/* Feed Tab */}
                  <TabsContent value="feed" className="space-y-3 mt-4">
                    <div className="flex items-center justify-between mb-4 border-b pb-3 border-border">
                      <p className="text-xs text-muted-foreground w-2/3">Legendas focadas em conversão usando automação de direct.</p>
                      <Button size="sm" onClick={() => handleGenerate("feed")} disabled={loadingPlatform === "feed"} className="h-8 text-xs">
                        <Wand2 className="w-3 h-3 mr-1" /> Gerar Legendas
                      </Button>
                    </div>
                    {content?.feed?.legendas ? content.feed.legendas.map((leg, i) => (
                      <CopyBlock key={i} label={`Opção de Legenda #${i + 1}`} icon={Instagram} content={leg} accentClass="border-l-2 border-accent" />
                    )) : <p className="text-xs text-muted-foreground text-center py-6">Nenhum conteúdo gerado.</p>}
                  </TabsContent>

                  {/* TikTok / Reels Tab */}
                  <TabsContent value="tiktok" className="mt-4 space-y-3">
                    <div className="flex items-center justify-between mb-4 border-b pb-3 border-border">
                      <p className="text-xs text-muted-foreground w-2/3">Roteiros curtos com hook de retenção para captação orgânica.</p>
                      <Button size="sm" onClick={() => handleGenerate("tiktok")} disabled={loadingPlatform === "tiktok"} className="h-8 text-xs">
                        <Wand2 className="w-3 h-3 mr-1" /> Gerar Roteiro
                      </Button>
                    </div>
                    {content?.tiktok_shorts?.roteiro ? (
                      <CopyBlock label="Estrutura de Vídeo Retentivo" icon={Video} content={content.tiktok_shorts.roteiro} accentClass="border-l-2 border-accent" />
                    ) : <p className="text-xs text-muted-foreground text-center py-6">Nenhum conteúdo gerado.</p>}
                  </TabsContent>

                  {/* WhatsApp Tab */}
                  <TabsContent value="whatsapp" className="space-y-3 mt-4">
                    <div className="flex items-center justify-between mb-4 border-b pb-3 border-border">
                      <p className="text-xs text-muted-foreground w-2/3">Disparos de venda direta para aquecimento de Grupos e Listas VIP.</p>
                      <Button size="sm" onClick={() => handleGenerate("whatsapp")} disabled={loadingPlatform === "whatsapp"} className="h-8 text-xs">
                        <Wand2 className="w-3 h-3 mr-1" /> Gerar Mensagens
                      </Button>
                    </div>
                    {content?.whatsapp?.mensagem ? (
                      <>
                        <CopyBlock label="Copy Estruturada (Grupo VIP)" icon={MessageCircle} content={content.whatsapp.mensagem} accentClass="border-l-2 border-accent" />
                        <CopyBlock label="Copy Curta (Lista de Transmissão)" icon={MessageCircle} content={content.whatsapp.versao_curta} accentClass="border-l-2 border-accent/50" />
                      </>
                    ) : <p className="text-xs text-muted-foreground text-center py-6">Nenhum conteúdo gerado.</p>}
                  </TabsContent>

                  {/* Design Tab */}
                  <TabsContent value="design" className="space-y-3 mt-4">
                    <div className="flex items-center justify-between mb-4 border-b pb-3 border-border">
                      <p className="text-xs text-muted-foreground w-2/3">Direcionais técnicos para criação de artes e locução.</p>
                      <Button size="sm" onClick={() => handleGenerate("design")} disabled={loadingPlatform === "design"} className="h-8 text-xs">
                        <Wand2 className="w-3 h-3 mr-1" /> Gerar Prompts
                      </Button>
                    </div>

                    {/* Galeria Restaurada */}
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
                        <div className="mb-6 bg-muted/20 p-3 rounded-lg border border-border">
                          <p className="text-xs font-medium text-muted-foreground mb-3 flex items-center justify-between">
                            <span>Imagens de Referência ({allImgs.length})</span>
                            <span className="text-[10px] font-normal opacity-70">Clique para baixar</span>
                          </p>
                          <div className="relative flex items-center gap-1">
                            {allImgs.length > 3 && (
                              <button onClick={() => scrollGallery(-1)} className="shrink-0 w-6 h-6 rounded-full bg-background border border-border shadow-sm hover:bg-accent/30 flex items-center justify-center transition-colors">
                                <ChevronLeft className="w-3.5 h-3.5" />
                              </button>
                            )}
                            <div ref={galleryScrollRef} className="flex gap-2 overflow-x-auto scrollbar-hide scroll-smooth flex-1 py-1">
                              {allImgs.map((url, i) => (
                                <a key={i} href={url} target="_blank" download className="block shrink-0 overflow-hidden rounded-md border border-border shadow-sm group relative w-20 h-20">
                                  <img src={url} alt={`Ref ${i + 1}`} className="w-full h-full object-cover transition-transform group-hover:scale-110" />
                                  <div className="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                                    <Download className="w-4 h-4 text-white" />
                                  </div>
                                </a>
                              ))}
                            </div>
                            {allImgs.length > 3 && (
                              <button onClick={() => scrollGallery(1)} className="shrink-0 w-6 h-6 rounded-full bg-background border border-border shadow-sm hover:bg-accent/30 flex items-center justify-center transition-colors">
                                <ChevronRight className="w-3.5 h-3.5" />
                              </button>
                            )}
                          </div>
                        </div>
                      );
                    })()}

                    {content?.prompts_visuais?.audio_generation_prompt && (
                      <div className="mb-4">
                        <CopyBlock label="🎙️ Script de Locução Emocional" icon={Mic} content={content.prompts_visuais.audio_generation_prompt} accentClass="border-l-2 border-indigo-500" />
                      </div>
                    )}

                    {content?.prompts_visuais?.image_generation_prompt ? (
                      <CopyBlock label="🤖 Prompt Visual (DALL-E/Midjourney)" icon={Palette} content={content.prompts_visuais.image_generation_prompt} accentClass="border-l-2 border-accent" />
                    ) : <p className="text-xs text-muted-foreground text-center py-6">Nenhum prompt visual gerado.</p>}
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