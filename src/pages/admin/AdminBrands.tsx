import { useState } from "react";
import { Plus, Trash2, Pencil, Check, X } from "lucide-react";
import { useBrands, useCreateBrand, useUpdateBrand, useDeleteBrand } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminBrands = () => {
  const { data: brands = [], isLoading } = useBrands();
  const createBrand = useCreateBrand();
  const updateBrand = useUpdateBrand();
  const deleteBrand = useDeleteBrand();
  const [name, setName] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editName, setEditName] = useState("");

  const handleCreate = async () => {
    if (!name.trim()) return toast.error("Informe o nome da marca.");
    try {
      await createBrand.mutateAsync(name.trim());
      setName("");
      toast.success("Marca criada!");
    } catch { toast.error("Erro ao criar marca."); }
  };

  const startEdit = (id: string, currentName: string) => {
    setEditingId(id);
    setEditName(currentName);
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditName("");
  };

  const handleUpdate = async () => {
    if (!editingId || !editName.trim()) return toast.error("Nome é obrigatório.");
    try {
      await updateBrand.mutateAsync({ id: editingId, name: editName.trim() });
      toast.success("Marca atualizada!");
      cancelEdit();
    } catch { toast.error("Erro ao atualizar marca."); }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Excluir marca?")) return;
    try { await deleteBrand.mutateAsync(id); toast.success("Marca excluída."); }
    catch { toast.error("Erro ao excluir. Verifique se não há produtos vinculados."); }
  };

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Marcas</h2>
      <div className="flex gap-2">
        <input value={name} onChange={(e) => setName(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleCreate()} placeholder="Nome da marca" className="flex-1 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
        <button onClick={handleCreate} disabled={createBrand.isPending} className="btn-accent flex items-center gap-2 text-sm" aria-label="Adicionar marca"><Plus className="w-4 h-4" /> Adicionar</button>
      </div>
      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Nome</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={2} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              brands.length === 0 ? <tr><td colSpan={2} className="p-8 text-center text-muted-foreground">Nenhuma marca.</td></tr> :
                brands.map((b) => (
                  <tr key={b.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground">
                      {editingId === b.id ? (
                        <input value={editName} onChange={(e) => setEditName(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleUpdate()} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" autoFocus />
                      ) : b.name}
                    </td>
                    <td className="p-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        {editingId === b.id ? (
                          <>
                            <button onClick={handleUpdate} className="p-2 rounded-lg hover:bg-success/10 transition-colors" aria-label="Salvar"><Check className="w-4 h-4 text-success" /></button>
                            <button onClick={cancelEdit} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Cancelar"><X className="w-4 h-4 text-muted-foreground" /></button>
                          </>
                        ) : (
                          <>
                            <button onClick={() => startEdit(b.id, b.name)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar marca"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                            <button onClick={() => handleDelete(b.id)} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir marca"><Trash2 className="w-4 h-4 text-destructive" /></button>
                          </>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminBrands;
