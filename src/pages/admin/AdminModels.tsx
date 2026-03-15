import { useState } from "react";
import { Plus, Trash2 } from "lucide-react";
import { useBrands, useModels, useCreateModel, useDeleteModel } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminModels = () => {
  const { data: brands = [] } = useBrands();
  const { data: models = [], isLoading } = useModels();
  const createModel = useCreateModel();
  const deleteModel = useDeleteModel();
  const [brandId, setBrandId] = useState("");
  const [name, setName] = useState("");

  const handleCreate = async () => {
    if (!brandId || !name.trim()) return toast.error("Selecione a marca e informe o nome.");
    try {
      await createModel.mutateAsync({ brand_id: brandId, name: name.trim() });
      setName("");
      toast.success("Modelo criado!");
    } catch { toast.error("Erro ao criar modelo."); }
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
                    <td className="p-4 text-foreground">{m.name}</td>
                    <td className="p-4 text-muted-foreground">{m.brands?.name}</td>
                    <td className="p-4 text-right"><button onClick={async () => { try { await deleteModel.mutateAsync(m.id); toast.success("Excluído."); } catch { toast.error("Erro."); } }} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir modelo"><Trash2 className="w-4 h-4 text-destructive" /></button></td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminModels;
