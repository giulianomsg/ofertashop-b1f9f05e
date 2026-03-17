import { useState } from "react";
import { Plus, Trash2, Pencil, Check, X } from "lucide-react";
import { useBrands, useModels, useCreateModel, useUpdateModel, useDeleteModel } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminModels = () => {
  const { data: brands = [] } = useBrands();
  const { data: models = [], isLoading } = useModels();
  const createModel = useCreateModel();
  const updateModel = useUpdateModel();
  const deleteModel = useDeleteModel();
  const [brandId, setBrandId] = useState("");
  const [name, setName] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editName, setEditName] = useState("");
  const [editBrandId, setEditBrandId] = useState("");

  const handleCreate = async () => {
    if (!brandId || !name.trim()) return toast.error("Selecione a marca e informe o nome.");
    try {
      await createModel.mutateAsync({ brand_id: brandId, name: name.trim() });
      setName("");
      toast.success("Modelo criado!");
    } catch { toast.error("Erro ao criar modelo."); }
  };

  const startEdit = (m: any) => {
    setEditingId(m.id);
    setEditName(m.name);
    setEditBrandId(m.brand_id || "");
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditName("");
    setEditBrandId("");
  };

  const handleUpdate = async () => {
    if (!editingId || !editName.trim() || !editBrandId) return toast.error("Preencha todos os campos.");
    try {
      await updateModel.mutateAsync({ id: editingId, name: editName.trim(), brand_id: editBrandId });
      toast.success("Modelo atualizado!");
      cancelEdit();
    } catch { toast.error("Erro ao atualizar modelo."); }
  };

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Modelos</h2>
      <div className="flex gap-2 flex-wrap">
        <select value={brandId} onChange={(e) => setBrandId(e.target.value)} className="h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
          <option value="">Selecione a marca</option>
          {brands.map((b) => <option key={b.id} value={b.id}>{b.name}</option>)}
        </select>
        <input value={name} onChange={(e) => setName(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleCreate()} placeholder="Nome do modelo" className="flex-1 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
        <button onClick={handleCreate} disabled={createModel.isPending} className="btn-accent flex items-center gap-2 text-sm" aria-label="Adicionar modelo"><Plus className="w-4 h-4" /> Adicionar</button>
      </div>
      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Modelo</th><th className="text-left p-4 font-semibold text-foreground">Marca</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              models.length === 0 ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Nenhum modelo.</td></tr> :
                models.map((m: any) => (
                  <tr key={m.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground">
                      {editingId === m.id ? (
                        <input value={editName} onChange={(e) => setEditName(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleUpdate()} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" autoFocus />
                      ) : m.name}
                    </td>
                    <td className="p-4 text-muted-foreground">
                      {editingId === m.id ? (
                        <select value={editBrandId} onChange={(e) => setEditBrandId(e.target.value)} className="h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
                          {brands.map((b) => <option key={b.id} value={b.id}>{b.name}</option>)}
                        </select>
                      ) : m.brands?.name}
                    </td>
                    <td className="p-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        {editingId === m.id ? (
                          <>
                            <button onClick={handleUpdate} className="p-2 rounded-lg hover:bg-success/10 transition-colors" aria-label="Salvar"><Check className="w-4 h-4 text-success" /></button>
                            <button onClick={cancelEdit} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Cancelar"><X className="w-4 h-4 text-muted-foreground" /></button>
                          </>
                        ) : (
                          <>
                            <button onClick={() => startEdit(m)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar modelo"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                            <button onClick={async () => { if (!confirm("Excluir?")) return; try { await deleteModel.mutateAsync(m.id); toast.success("Excluído."); } catch { toast.error("Erro."); } }} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir modelo"><Trash2 className="w-4 h-4 text-destructive" /></button>
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

export default AdminModels;
