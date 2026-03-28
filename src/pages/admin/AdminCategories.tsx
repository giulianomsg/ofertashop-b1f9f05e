import { useState } from "react";
import { Plus, Trash2, Pencil, Check, X } from "lucide-react";
import { useCategories, useCreateCategory, useUpdateCategory, useDeleteCategory } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminCategories = () => {
  const { data: categories = [], isLoading } = useCategories();
  const createCategory = useCreateCategory();
  const updateCategory = useUpdateCategory();
  const deleteCategory = useDeleteCategory();
  const [name, setName] = useState("");
  const [slug, setSlug] = useState("");
  const [icon, setIcon] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editName, setEditName] = useState("");
  const [editSlug, setEditSlug] = useState("");
  const [editIcon, setEditIcon] = useState("");

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

  const startEdit = (c: any) => {
    setEditingId(c.id);
    setEditName(c.name);
    setEditSlug(c.slug);
    setEditIcon(c.icon || "");
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditName("");
    setEditSlug("");
    setEditIcon("");
  };

  const handleUpdate = async () => {
    if (!editingId || !editName.trim() || !editSlug.trim()) return toast.error("Nome e slug são obrigatórios.");
    try {
      await updateCategory.mutateAsync({ id: editingId, name: editName.trim(), slug: editSlug.trim(), icon: editIcon || null });
      toast.success("Categoria atualizada!");
      cancelEdit();
    } catch { toast.error("Erro ao atualizar categoria."); }
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
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Nome</th><th className="text-left p-4 font-semibold text-foreground">Slug</th><th className="text-left p-4 font-semibold text-foreground hidden sm:table-cell">Ícone</th><th className="text-center p-4 font-semibold text-foreground">Produtos</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              categories.length === 0 ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Nenhuma categoria.</td></tr> :
                categories.map((c: any) => {
                  const productCount = Array.isArray(c.products) ? c.products[0]?.count || 0 : c.products?.count || 0;
                  return (
                  <tr key={c.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground">
                      {editingId === c.id ? (
                        <input value={editName} onChange={(e) => setEditName(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleUpdate()} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" autoFocus />
                      ) : c.name}
                    </td>
                    <td className="p-4 text-muted-foreground">
                      {editingId === c.id ? (
                        <input value={editSlug} onChange={(e) => setEditSlug(e.target.value)} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
                      ) : c.slug}
                    </td>
                    <td className="p-4 text-muted-foreground hidden sm:table-cell">
                      {editingId === c.id ? (
                        <input value={editIcon} onChange={(e) => setEditIcon(e.target.value)} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Ícone" />
                      ) : (c.icon || "—")}
                    </td>
                    <td className="p-4 text-center text-muted-foreground font-medium">
                      {productCount}
                    </td>
                    <td className="p-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        {editingId === c.id ? (
                          <>
                            <button onClick={handleUpdate} className="p-2 rounded-lg hover:bg-success/10 transition-colors" aria-label="Salvar"><Check className="w-4 h-4 text-success" /></button>
                            <button onClick={cancelEdit} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Cancelar"><X className="w-4 h-4 text-muted-foreground" /></button>
                          </>
                        ) : (
                          <>
                            <button onClick={() => startEdit(c)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar categoria"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                            <button 
                              onClick={async () => { 
                                if (productCount > 0) return toast.error("Não é possível excluir categorias que contêm produtos.");
                                if (!confirm("Excluir?")) return; 
                                try { await deleteCategory.mutateAsync(c.id); toast.success("Excluída."); } catch { toast.error("Erro."); } 
                              }} 
                              className={`p-2 rounded-lg transition-colors ${productCount > 0 ? 'opacity-50 cursor-not-allowed text-muted-foreground' : 'hover:bg-destructive/10 text-destructive'}`} 
                              aria-label="Excluir categoria"
                              title={productCount > 0 ? "Categoria possui produtos" : "Excluir"}
                            >
                              <Trash2 className="w-4 h-4" />
                            </button>
                          </>
                        )}
                      </div>
                    </td>
                  </tr>
                );
              })}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminCategories;
