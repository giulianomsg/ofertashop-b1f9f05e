import { useState } from "react";
import { Plus, Trash2 } from "lucide-react";
import { useCategories, useCreateCategory, useDeleteCategory } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminCategories = () => {
  const { data: categories = [], isLoading } = useCategories();
  const createCategory = useCreateCategory();
  const deleteCategory = useDeleteCategory();
  const [name, setName] = useState("");
  const [slug, setSlug] = useState("");
  const [icon, setIcon] = useState("");

  const autoSlug = (val: string) => {
    setName(val);
    setSlug(val.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, ""));
  };

  const handleCreate = async () => {
    if (!name.trim() || !slug.trim()) return toast.error("Nome e slug são obrigatórios.");
    try {
      await createCategory.mutateAsync({ name: name.trim(), slug: slug.trim(), icon: icon || undefined });
      setName(""); setSlug(""); setIcon("");
      toast.success("Categoria criada!");
    } catch { toast.error("Erro ao criar categoria."); }
  };

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Categorias</h2>
      <div className="flex gap-2 flex-wrap">
        <input value={name} onChange={(e) => autoSlug(e.target.value)} placeholder="Nome" className="flex-1 min-w-[150px] h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
        <input value={slug} onChange={(e) => setSlug(e.target.value)} placeholder="Slug" className="w-40 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
        <input value={icon} onChange={(e) => setIcon(e.target.value)} placeholder="Ícone (opcional)" className="w-32 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
        <button onClick={handleCreate} disabled={createCategory.isPending} className="btn-accent flex items-center gap-2 text-sm" aria-label="Adicionar categoria"><Plus className="w-4 h-4" /> Adicionar</button>
      </div>
      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Nome</th><th className="text-left p-4 font-semibold text-foreground">Slug</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              categories.length === 0 ? <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">Nenhuma categoria.</td></tr> :
                categories.map((c) => (
                  <tr key={c.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground">{c.name}</td>
                    <td className="p-4 text-muted-foreground">{c.slug}</td>
                    <td className="p-4 text-right"><button onClick={async () => { if (!confirm("Excluir?")) return; try { await deleteCategory.mutateAsync(c.id); toast.success("Excluída."); } catch { toast.error("Erro."); } }} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir categoria"><Trash2 className="w-4 h-4 text-destructive" /></button></td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminCategories;
