import { useState } from "react";
import { motion } from "framer-motion";
import { Calendar, Plus, Pencil, Trash2, Loader2, FlaskConical, Trophy } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Badge } from "@/components/ui/badge";
import { useAuth } from "@/hooks/useAuth";
import { useProducts } from "@/hooks/useProducts";

const CAMPAIGN_TYPES = [
  "EASTER", "MOTHERS_DAY", "FATHERS_DAY", "VALENTINES_DAY",
  "BLACK_FRIDAY", "CYBER_MONDAY", "CHRISTMAS", "NEW_YEAR",
  "CARNIVAL", "BACK_TO_SCHOOL", "CUSTOM",
];

const CAMPAIGN_LABELS: Record<string, string> = {
  EASTER: "🐣 Páscoa", MOTHERS_DAY: "💐 Dia das Mães", FATHERS_DAY: "👔 Dia dos Pais",
  VALENTINES_DAY: "💕 Dia dos Namorados", BLACK_FRIDAY: "🖤 Black Friday",
  CYBER_MONDAY: "💻 Cyber Monday", CHRISTMAS: "🎄 Natal", NEW_YEAR: "🎆 Ano Novo",
  CARNIVAL: "🎭 Carnaval", BACK_TO_SCHOOL: "📚 Volta às Aulas", CUSTOM: "⚙️ Personalizada",
};

const STATUS_COLORS: Record<string, string> = {
  ACTIVE: "bg-accent/10 text-accent",
  DRAFT: "bg-secondary text-muted-foreground",
  EXPIRED: "bg-destructive/10 text-destructive",
};

const AdminAICampaigns = () => {
  const { user } = useAuth();
  const { data: products = [] } = useProducts(false);
  const queryClient = useQueryClient();
  const [isCampaignOpen, setIsCampaignOpen] = useState(false);
  const [editingCampaign, setEditingCampaign] = useState<any>(null);
  const [campaignForm, setCampaignForm] = useState({ name: "", type: "CUSTOM", description: "", start_date: "", end_date: "", status: "DRAFT" });

  const [isABOpen, setIsABOpen] = useState(false);
  const [abForm, setABForm] = useState({ name: "", product_id: "", variant_a_id: "", variant_b_id: "" });

  const { data: campaigns = [], isLoading: loadingCampaigns } = useQuery({
    queryKey: ["ai-campaigns"],
    queryFn: async () => {
      const { data } = await (supabase as any).from("ai_campaigns").select("*").order("start_date", { ascending: false });
      return data || [];
    },
  });

  const { data: abTests = [], isLoading: loadingAB } = useQuery({
    queryKey: ["ai-ab-tests"],
    queryFn: async () => {
      const { data } = await (supabase as any).from("ai_ab_tests").select("*, products(title)").order("created_at", { ascending: false });
      return data || [];
    },
  });

  const saveCampaignMutation = useMutation({
    mutationFn: async () => {
      const payload = {
        ...campaignForm,
        start_date: campaignForm.start_date || null,
        end_date: campaignForm.end_date || null,
        user_id: user?.id,
      };
      if (editingCampaign) {
        await (supabase as any).from("ai_campaigns").update(payload).eq("id", editingCampaign.id);
      } else {
        await (supabase as any).from("ai_campaigns").insert(payload);
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ai-campaigns"] });
      toast.success(editingCampaign ? "Campanha atualizada!" : "Campanha criada!");
      setIsCampaignOpen(false);
      setEditingCampaign(null);
    },
    onError: (err: any) => toast.error(err.message),
  });

  const deleteCampaignMutation = useMutation({
    mutationFn: async (id: string) => { await (supabase as any).from("ai_campaigns").delete().eq("id", id); },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["ai-campaigns"] }); toast.success("Campanha removida!"); },
  });

  const createABMutation = useMutation({
    mutationFn: async () => {
      await (supabase as any).from("ai_ab_tests").insert({
        name: abForm.name,
        product_id: abForm.product_id || null,
        variant_a_id: abForm.variant_a_id || "A",
        variant_b_id: abForm.variant_b_id || "B",
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ai-ab-tests"] });
      toast.success("Teste A/B criado!");
      setIsABOpen(false);
      setABForm({ name: "", product_id: "", variant_a_id: "", variant_b_id: "" });
    },
    onError: (err: any) => toast.error(err.message),
  });

  const evaluateABMutation = useMutation({
    mutationFn: async () => {
      const { data, error } = await supabase.functions.invoke("evaluate-ab-tests");
      if (error) throw error;
      return data;
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ["ai-ab-tests"] });
      toast.success(`Avaliação concluída: ${data?.evaluated || 0} testes avaliados.`);
    },
    onError: (err: any) => toast.error(err.message),
  });

  const openEditCampaign = (c: any) => {
    setEditingCampaign(c);
    setCampaignForm({
      name: c.name, type: c.type, description: c.description || "",
      start_date: c.start_date?.split("T")[0] || "", end_date: c.end_date?.split("T")[0] || "",
      status: c.status,
    });
    setIsCampaignOpen(true);
  };

  const selectClass = "w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors";
  const inputClass = selectClass;

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <div className="p-2.5 rounded-xl bg-accent/10"><Calendar className="w-6 h-6 text-accent" /></div>
        <div>
          <h2 className="font-display font-bold text-xl text-foreground">Campanhas & A/B Testing</h2>
          <p className="text-sm text-muted-foreground">Gerencie campanhas sazonais e testes de performance</p>
        </div>
      </div>

      <Tabs defaultValue="campaigns">
        <TabsList>
          <TabsTrigger value="campaigns"><Calendar className="w-3.5 h-3.5 mr-1" />Campanhas</TabsTrigger>
          <TabsTrigger value="ab"><FlaskConical className="w-3.5 h-3.5 mr-1" />Testes A/B</TabsTrigger>
        </TabsList>

        {/* Campaigns Tab */}
        <TabsContent value="campaigns" className="space-y-4 mt-4">
          <div className="flex justify-end">
            <Button onClick={() => { setEditingCampaign(null); setCampaignForm({ name: "", type: "CUSTOM", description: "", start_date: "", end_date: "", status: "DRAFT" }); setIsCampaignOpen(true); }}>
              <Plus className="w-4 h-4 mr-2" />Nova Campanha
            </Button>
          </div>

          {loadingCampaigns ? (
            <div className="flex justify-center p-12"><Loader2 className="w-6 h-6 animate-spin text-muted-foreground" /></div>
          ) : campaigns.length === 0 ? (
            <Card><CardContent className="p-12 text-center text-muted-foreground">Nenhuma campanha cadastrada.</CardContent></Card>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {campaigns.map((c: any, i: number) => (
                <motion.div key={c.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.03 }}>
                  <Card>
                    <CardContent className="p-5 space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-lg">{CAMPAIGN_LABELS[c.type]?.split(" ")[0]}</span>
                        <Badge className={STATUS_COLORS[c.status] || ""}>{c.status}</Badge>
                      </div>
                      <h3 className="font-semibold text-foreground">{c.name}</h3>
                      {c.description && <p className="text-xs text-muted-foreground line-clamp-2">{c.description}</p>}
                      {c.start_date && (
                        <p className="text-xs text-muted-foreground">
                          {new Date(c.start_date).toLocaleDateString("pt-BR")} — {c.end_date ? new Date(c.end_date).toLocaleDateString("pt-BR") : "sem fim"}
                        </p>
                      )}
                      <div className="flex gap-1 pt-1">
                        <button onClick={() => openEditCampaign(c)} className="p-1.5 rounded-md hover:bg-secondary"><Pencil className="w-3.5 h-3.5 text-muted-foreground" /></button>
                        <button onClick={() => deleteCampaignMutation.mutate(c.id)} className="p-1.5 rounded-md hover:bg-destructive/10"><Trash2 className="w-3.5 h-3.5 text-destructive" /></button>
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>
              ))}
            </div>
          )}
        </TabsContent>

        {/* A/B Tests Tab */}
        <TabsContent value="ab" className="space-y-4 mt-4">
          <div className="flex justify-between">
            <Button variant="outline" onClick={() => evaluateABMutation.mutate()} disabled={evaluateABMutation.isPending}>
              {evaluateABMutation.isPending ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : <Trophy className="w-4 h-4 mr-2" />}
              Avaliar Testes
            </Button>
            <Button onClick={() => setIsABOpen(true)}><Plus className="w-4 h-4 mr-2" />Novo Teste A/B</Button>
          </div>

          {loadingAB ? (
            <div className="flex justify-center p-12"><Loader2 className="w-6 h-6 animate-spin text-muted-foreground" /></div>
          ) : abTests.length === 0 ? (
            <Card><CardContent className="p-12 text-center text-muted-foreground">Nenhum teste A/B cadastrado.</CardContent></Card>
          ) : (
            <div className="space-y-3">
              {abTests.map((test: any) => (
                <Card key={test.id}>
                  <CardContent className="p-4 flex items-center justify-between">
                    <div>
                      <h3 className="font-medium text-foreground">{test.name}</h3>
                      <p className="text-xs text-muted-foreground">{test.products?.title || "Sem produto"} — {test.status}</p>
                    </div>
                    <div className="flex items-center gap-3">
                      {test.winner_id && (
                        <Badge className="bg-accent/10 text-accent">
                          <Trophy className="w-3 h-3 mr-1" />Vencedor: {test.winner_id}
                        </Badge>
                      )}
                      <Badge variant={test.status === "RUNNING" ? "default" : "secondary"}>{test.status}</Badge>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </TabsContent>
      </Tabs>

      {/* Campaign Dialog */}
      <Dialog open={isCampaignOpen} onOpenChange={(v) => !v && setIsCampaignOpen(false)}>
        <DialogContent>
          <DialogHeader><DialogTitle>{editingCampaign ? "Editar Campanha" : "Nova Campanha"}</DialogTitle></DialogHeader>
          <div className="space-y-4">
            <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Nome</label><input value={campaignForm.name} onChange={(e) => setCampaignForm({ ...campaignForm, name: e.target.value })} className={inputClass} /></div>
            <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Tipo</label><select value={campaignForm.type} onChange={(e) => setCampaignForm({ ...campaignForm, type: e.target.value })} className={selectClass}>{CAMPAIGN_TYPES.map((t) => <option key={t} value={t}>{CAMPAIGN_LABELS[t]}</option>)}</select></div>
            <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Descrição</label><textarea value={campaignForm.description} onChange={(e) => setCampaignForm({ ...campaignForm, description: e.target.value })} className={`${inputClass} h-20 resize-none`} /></div>
            <div className="grid grid-cols-2 gap-3">
              <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Início</label><input type="date" value={campaignForm.start_date} onChange={(e) => setCampaignForm({ ...campaignForm, start_date: e.target.value })} className={inputClass} /></div>
              <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Fim</label><input type="date" value={campaignForm.end_date} onChange={(e) => setCampaignForm({ ...campaignForm, end_date: e.target.value })} className={inputClass} /></div>
            </div>
            <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Status</label><select value={campaignForm.status} onChange={(e) => setCampaignForm({ ...campaignForm, status: e.target.value })} className={selectClass}><option value="DRAFT">Rascunho</option><option value="ACTIVE">Ativa</option><option value="EXPIRED">Expirada</option></select></div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsCampaignOpen(false)}>Cancelar</Button>
            <Button onClick={() => saveCampaignMutation.mutate()} disabled={!campaignForm.name.trim() || saveCampaignMutation.isPending}>Salvar</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* A/B Test Dialog */}
      <Dialog open={isABOpen} onOpenChange={(v) => !v && setIsABOpen(false)}>
        <DialogContent>
          <DialogHeader><DialogTitle>Novo Teste A/B</DialogTitle></DialogHeader>
          <div className="space-y-4">
            <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Nome do Teste</label><input value={abForm.name} onChange={(e) => setABForm({ ...abForm, name: e.target.value })} className={inputClass} placeholder="Ex: Legenda urgente vs divertida" /></div>
            <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Produto</label><select value={abForm.product_id} onChange={(e) => setABForm({ ...abForm, product_id: e.target.value })} className={selectClass}><option value="">Selecionar...</option>{products.map((p) => <option key={p.id} value={p.id}>{p.title}</option>)}</select></div>
            <div className="grid grid-cols-2 gap-3">
              <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Variante A</label><input value={abForm.variant_a_id} onChange={(e) => setABForm({ ...abForm, variant_a_id: e.target.value })} className={inputClass} placeholder="A" /></div>
              <div><label className="text-xs font-semibold text-foreground mb-1.5 block">Variante B</label><input value={abForm.variant_b_id} onChange={(e) => setABForm({ ...abForm, variant_b_id: e.target.value })} className={inputClass} placeholder="B" /></div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsABOpen(false)}>Cancelar</Button>
            <Button onClick={() => createABMutation.mutate()} disabled={!abForm.name.trim() || createABMutation.isPending}>Criar Teste</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default AdminAICampaigns;
