import { useState } from "react";
import { Loader2, Bot, MessageSquare, Gift, Wand2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useProducts } from "@/hooks/useProducts";

const AdminAIAutomations = () => {
  const queryClient = useQueryClient();
  const { data: products = [] } = useProducts(false);

  // Auto-responses
  const [keyword, setKeyword] = useState("");
  const [response, setResponse] = useState("");
  const [autoResponses, setAutoResponses] = useState<{ keyword: string; response: string }[]>([]);

  // Draw generator
  const [drawProductId, setDrawProductId] = useState("");
  const [drawPrize, setDrawPrize] = useState("");
  const [drawRules, setDrawRules] = useState("");
  const [generatingRules, setGeneratingRules] = useState(false);

  const { data: draws = [], isLoading: loadingDraws } = useQuery({
    queryKey: ["ai-draws"],
    queryFn: async () => {
      const { data } = await (supabase as any).from("ai_gamification_draws").select("*, products(title)").order("created_at", { ascending: false });
      return data || [];
    },
  });

  // Load auto-responses from admin_settings
  useQuery({
    queryKey: ["auto-responses-config"],
    queryFn: async () => {
      const { data } = await (supabase as any).from("admin_settings").select("value").eq("key", "auto_responses").maybeSingle();
      if (data?.value && Array.isArray(data.value)) setAutoResponses(data.value);
      return data;
    },
  });

  const saveAutoResponses = async (responses: { keyword: string; response: string }[]) => {
    await (supabase as any).from("admin_settings").upsert({
      key: "auto_responses",
      value: responses,
      updated_at: new Date().toISOString(),
    });
  };

  const handleAddResponse = async () => {
    if (!keyword.trim() || !response.trim()) { toast.error("Preencha palavra-chave e resposta."); return; }
    const updated = [...autoResponses, { keyword: keyword.trim(), response: response.trim() }];
    setAutoResponses(updated);
    await saveAutoResponses(updated);
    setKeyword("");
    setResponse("");
    toast.success("Resposta automática adicionada!");
  };

  const handleRemoveResponse = async (index: number) => {
    const updated = autoResponses.filter((_, i) => i !== index);
    setAutoResponses(updated);
    await saveAutoResponses(updated);
    toast.success("Resposta removida.");
  };

  const handleGenerateDrawRules = async () => {
    if (!drawPrize.trim()) { toast.error("Informe o prêmio."); return; }
    setGeneratingRules(true);
    try {
      const product = products.find((p) => p.id === drawProductId);
      const { data, error } = await supabase.functions.invoke("generate-social-copy-pro", {
        body: {
          product: product || { title: drawPrize },
          settings: { tone: "divertido", trigger: "exclusividade" },
        },
      });
      if (error) throw error;
      // Use a simplified rule from the generated content
      const rules = `🎁 SORTEIO: ${drawPrize}\n\n📋 Regras:\n1. Siga nosso perfil @ofertashop\n2. Curta esta publicação\n3. Marque 2 amigos nos comentários\n4. Compartilhe nos Stories (vale ponto extra!)\n\n📅 Resultado: em breve!\n\n${data?.content?.whatsapp?.versao_curta || "Boa sorte! 🍀"}`;
      setDrawRules(rules);
      toast.success("Regras geradas com IA!");
    } catch (err: any) {
      toast.error(err.message || "Erro ao gerar regras.");
    } finally {
      setGeneratingRules(false);
    }
  };

  const saveDrawMutation = useMutation({
    mutationFn: async () => {
      await (supabase as any).from("ai_gamification_draws").insert({
        product_id: drawProductId || null,
        prize: drawPrize,
        rules: drawRules,
        status: "pending",
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ai-draws"] });
      toast.success("Sorteio salvo!");
      setDrawPrize("");
      setDrawRules("");
      setDrawProductId("");
    },
    onError: (err: any) => toast.error(err.message),
  });

  const inputClass = "w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors";

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <div className="p-2.5 rounded-xl bg-accent/10"><Bot className="w-6 h-6 text-accent" /></div>
        <div>
          <h2 className="font-display font-bold text-xl text-foreground">Automações & Engajamento</h2>
          <p className="text-sm text-muted-foreground">Respostas automáticas, sorteios e desafios</p>
        </div>
      </div>

      <Tabs defaultValue="responses">
        <TabsList>
          <TabsTrigger value="responses"><MessageSquare className="w-3.5 h-3.5 mr-1" />Respostas</TabsTrigger>
          <TabsTrigger value="draws"><Gift className="w-3.5 h-3.5 mr-1" />Sorteios</TabsTrigger>
        </TabsList>

        <TabsContent value="responses" className="space-y-4 mt-4">
          <Card>
            <CardHeader><CardTitle className="text-sm">Adicionar Resposta Automática</CardTitle></CardHeader>
            <CardContent className="space-y-3">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Palavra-chave</label>
                  <input value={keyword} onChange={(e) => setKeyword(e.target.value)} className={inputClass} placeholder="Ex: preço, link, comprar" />
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Resposta</label>
                  <input value={response} onChange={(e) => setResponse(e.target.value)} className={inputClass} placeholder="Ex: Confira o link na bio! 👆" />
                </div>
              </div>
              <Button onClick={handleAddResponse} size="sm">Adicionar</Button>
            </CardContent>
          </Card>

          {autoResponses.length > 0 && (
            <Card>
              <CardHeader><CardTitle className="text-sm">Respostas Configuradas</CardTitle></CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {autoResponses.map((ar, i) => (
                    <div key={i} className="flex items-center justify-between p-3 bg-secondary rounded-lg">
                      <div>
                        <span className="text-xs font-mono text-accent">{ar.keyword}</span>
                        <span className="mx-2 text-muted-foreground">→</span>
                        <span className="text-sm text-foreground">{ar.response}</span>
                      </div>
                      <button onClick={() => handleRemoveResponse(i)} className="text-xs text-destructive hover:underline">Remover</button>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}
        </TabsContent>

        <TabsContent value="draws" className="space-y-4 mt-4">
          <Card>
            <CardHeader><CardTitle className="text-sm">Gerar Sorteio com IA</CardTitle></CardHeader>
            <CardContent className="space-y-4">
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Produto (opcional)</label>
                <select value={drawProductId} onChange={(e) => setDrawProductId(e.target.value)} className={inputClass}>
                  <option value="">Nenhum</option>
                  {products.map((p) => <option key={p.id} value={p.id}>{p.title}</option>)}
                </select>
              </div>
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Prêmio</label>
                <input value={drawPrize} onChange={(e) => setDrawPrize(e.target.value)} className={inputClass} placeholder="Ex: Echo Dot 5ª Geração" />
              </div>
              <Button onClick={handleGenerateDrawRules} disabled={generatingRules} variant="outline">
                {generatingRules ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : <Wand2 className="w-4 h-4 mr-2" />}
                Gerar Regras com IA
              </Button>
              {drawRules && (
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Regras Geradas</label>
                  <textarea value={drawRules} onChange={(e) => setDrawRules(e.target.value)} className={`${inputClass} h-40 resize-none`} />
                </div>
              )}
              {drawRules && (
                <Button onClick={() => saveDrawMutation.mutate()} disabled={saveDrawMutation.isPending}>Salvar Sorteio</Button>
              )}
            </CardContent>
          </Card>

          {draws.length > 0 && (
            <Card>
              <CardHeader><CardTitle className="text-sm">Sorteios Cadastrados</CardTitle></CardHeader>
              <CardContent className="space-y-3">
                {draws.map((d: any) => (
                  <div key={d.id} className="p-3 bg-secondary rounded-lg">
                    <div className="flex items-center justify-between mb-1">
                      <span className="font-medium text-sm text-foreground">🎁 {d.prize}</span>
                      <span className="text-xs text-muted-foreground">{d.status}</span>
                    </div>
                    {d.products?.title && <p className="text-xs text-muted-foreground">Produto: {d.products.title}</p>}
                    {d.rules && <p className="text-xs text-muted-foreground mt-1 whitespace-pre-wrap line-clamp-3">{d.rules}</p>}
                  </div>
                ))}
              </CardContent>
            </Card>
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
};

export default AdminAIAutomations;
