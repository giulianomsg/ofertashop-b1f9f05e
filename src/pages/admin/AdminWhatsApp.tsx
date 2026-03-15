import { useState } from "react";
import { Plus, Trash2, ToggleLeft, ToggleRight } from "lucide-react";
import { useWhatsAppGroups, useCreateWhatsAppGroup, useUpdateWhatsAppGroup, useDeleteWhatsAppGroup } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminWhatsApp = () => {
  const { data: groups = [], isLoading } = useWhatsAppGroups();
  const createGroup = useCreateWhatsAppGroup();
  const updateGroup = useUpdateWhatsAppGroup();
  const deleteGroup = useDeleteWhatsAppGroup();
  const [link, setLink] = useState("");

  const handleCreate = async () => {
    if (!link.trim()) return toast.error("Informe o link do grupo.");
    try {
      await createGroup.mutateAsync({ link: link.trim(), active: groups.length === 0 });
      setLink("");
      toast.success("Grupo adicionado!");
    } catch { toast.error("Erro ao adicionar."); }
  };

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Grupos de WhatsApp</h2>
      <p className="text-sm text-muted-foreground">Apenas um grupo pode estar ativo por vez. Ao ativar um, os demais serão desativados automaticamente.</p>
      <div className="flex gap-2">
        <input value={link} onChange={(e) => setLink(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleCreate()} placeholder="https://chat.whatsapp.com/..." className="flex-1 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
        <button onClick={handleCreate} disabled={createGroup.isPending} className="btn-accent flex items-center gap-2 text-sm" aria-label="Adicionar grupo"><Plus className="w-4 h-4" /> Adicionar</button>
      </div>
      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Link</th><th className="text-center p-4 font-semibold text-foreground">Ativo</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              groups.length === 0 ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Nenhum grupo.</td></tr> :
                groups.map((g) => (
                  <tr key={g.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground truncate max-w-[300px]">{g.link}</td>
                    <td className="p-4 text-center">
                      <button onClick={async () => { try { await updateGroup.mutateAsync({ id: g.id, active: !g.active }); } catch { toast.error("Erro."); } }} aria-label="Alternar status">
                        {g.active ? <ToggleRight className="w-7 h-7 text-success" /> : <ToggleLeft className="w-7 h-7 text-muted-foreground" />}
                      </button>
                    </td>
                    <td className="p-4 text-right"><button onClick={async () => { if (!confirm("Excluir?")) return; try { await deleteGroup.mutateAsync(g.id); toast.success("Excluído."); } catch { toast.error("Erro."); } }} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir grupo"><Trash2 className="w-4 h-4 text-destructive" /></button></td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminWhatsApp;
