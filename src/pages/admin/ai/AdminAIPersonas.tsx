import { useState } from "react";
import { motion } from "framer-motion";
import { Users, Plus, Pencil, Trash2, Loader2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { useAuth } from "@/hooks/useAuth";

interface Persona {
  id: string;
  name: string;
  description: string;
  tone: string;
  triggers: string[];
  preferences: any;
}

const TONES = ["persuasivo", "urgente", "divertido", "informativo", "premium", "casual"];

const AdminAIPersonas = () => {
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const [isOpen, setIsOpen] = useState(false);
  const [editing, setEditing] = useState<Persona | null>(null);
  const [form, setForm] = useState({ name: "", description: "", tone: "persuasivo", triggers: "" });

  const { data: personas = [], isLoading } = useQuery({
    queryKey: ["ai-personas"],
    queryFn: async () => {
      const { data, error } = await (supabase as any).from("ai_personas").select("*").order("name");
      if (error) throw error;
      return data || [];
    },
  });

  const saveMutation = useMutation({
    mutationFn: async () => {
      const payload = {
        name: form.name.trim(),
        description: form.description.trim(),
        tone: form.tone,
        triggers: form.triggers.split(",").map((t: string) => t.trim()).filter(Boolean),
        user_id: user?.id,
      };
      if (editing) {
        const { error } = await (supabase as any).from("ai_personas").update(payload).eq("id", editing.id);
        if (error) throw error;
      } else {
        const { error } = await (supabase as any).from("ai_personas").insert(payload);
        if (error) throw error;
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ai-personas"] });
      toast.success(editing ? "Persona atualizada!" : "Persona criada!");
      handleClose();
    },
    onError: (err: any) => toast.error(err.message || "Erro ao salvar."),
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => {
      const { error } = await (supabase as any).from("ai_personas").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["ai-personas"] });
      toast.success("Persona removida!");
    },
  });

  const handleOpen = (persona?: Persona) => {
    if (persona) {
      setEditing(persona);
      setForm({
        name: persona.name,
        description: persona.description || "",
        tone: persona.tone,
        triggers: (persona.triggers || []).join(", "),
      });
    } else {
      setEditing(null);
      setForm({ name: "", description: "", tone: "persuasivo", triggers: "" });
    }
    setIsOpen(true);
  };

  const handleClose = () => {
    setIsOpen(false);
    setEditing(null);
  };

  const selectClass = "w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors";
  const inputClass = selectClass;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="p-2.5 rounded-xl bg-accent/10"><Users className="w-6 h-6 text-accent" /></div>
          <div>
            <h2 className="font-display font-bold text-xl text-foreground">Personas</h2>
            <p className="text-sm text-muted-foreground">Segmente seu público para conteúdo personalizado</p>
          </div>
        </div>
        <Button onClick={() => handleOpen()}><Plus className="w-4 h-4 mr-2" />Nova Persona</Button>
      </div>

      {isLoading ? (
        <div className="flex justify-center p-12"><Loader2 className="w-6 h-6 animate-spin text-muted-foreground" /></div>
      ) : personas.length === 0 ? (
        <Card><CardContent className="p-12 text-center"><Users className="w-10 h-10 mx-auto text-muted-foreground/30 mb-3" /><p className="text-muted-foreground">Nenhuma persona cadastrada.</p></CardContent></Card>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {personas.map((p: Persona, i: number) => (
            <motion.div key={p.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.05 }}>
              <Card>
                <CardContent className="p-5 space-y-3">
                  <div className="flex items-center justify-between">
                    <h3 className="font-semibold text-foreground">{p.name}</h3>
                    <div className="flex gap-1">
                      <button onClick={() => handleOpen(p)} className="p-1.5 rounded-md hover:bg-secondary"><Pencil className="w-3.5 h-3.5 text-muted-foreground" /></button>
                      <button onClick={() => deleteMutation.mutate(p.id)} className="p-1.5 rounded-md hover:bg-destructive/10"><Trash2 className="w-3.5 h-3.5 text-destructive" /></button>
                    </div>
                  </div>
                  {p.description && <p className="text-xs text-muted-foreground line-clamp-2">{p.description}</p>}
                  <div className="flex flex-wrap gap-1.5">
                    <span className="text-[10px] px-2 py-0.5 rounded-full bg-accent/10 text-accent font-medium">{p.tone}</span>
                    {(p.triggers || []).map((t, ti) => (
                      <span key={ti} className="text-[10px] px-2 py-0.5 rounded-full bg-secondary text-muted-foreground">{t}</span>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>
      )}

      <Dialog open={isOpen} onOpenChange={(v) => !v && handleClose()}>
        <DialogContent>
          <DialogHeader><DialogTitle>{editing ? "Editar Persona" : "Nova Persona"}</DialogTitle></DialogHeader>
          <div className="space-y-4">
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Nome</label>
              <input value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} className={inputClass} placeholder="Ex: Tech Lover" />
            </div>
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Descrição</label>
              <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} className={`${inputClass} h-20 resize-none`} placeholder="Perfil do público-alvo..." />
            </div>
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Tom de Voz</label>
              <select value={form.tone} onChange={(e) => setForm({ ...form, tone: e.target.value })} className={selectClass}>
                {TONES.map((t) => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Gatilhos (separados por vírgula)</label>
              <input value={form.triggers} onChange={(e) => setForm({ ...form, triggers: e.target.value })} className={inputClass} placeholder="urgência, escassez, prova social" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={handleClose}>Cancelar</Button>
            <Button onClick={() => saveMutation.mutate()} disabled={!form.name.trim() || saveMutation.isPending}>
              {saveMutation.isPending ? <Loader2 className="w-4 h-4 animate-spin mr-2" /> : null}
              Salvar
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default AdminAIPersonas;
