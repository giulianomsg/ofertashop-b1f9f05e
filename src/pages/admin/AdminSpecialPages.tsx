import { useState } from "react";
import { Plus, Trash2, Pencil, Check, X, ToggleLeft, ToggleRight } from "lucide-react";
import { useSpecialPages, useCreateSpecialPage, useUpdateSpecialPage, useDeleteSpecialPage } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminSpecialPages = () => {
  const { data: pages = [], isLoading } = useSpecialPages();
  const createPage = useCreateSpecialPage();
  const updatePage = useUpdateSpecialPage();
  const deletePage = useDeleteSpecialPage();
  const [title, setTitle] = useState("");
  const [slug, setSlug] = useState("");
  const [description, setDescription] = useState("");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editTitle, setEditTitle] = useState("");
  const [editSlug, setEditSlug] = useState("");
  const [editDescription, setEditDescription] = useState("");

  const autoSlug = (val: string) => {
    setTitle(val);
    setSlug(val.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, ""));
  };

  const handleCreate = async () => {
    if (!title.trim() || !slug.trim()) return toast.error("Título e slug são obrigatórios.");
    try {
      await createPage.mutateAsync({ title: title.trim(), slug: slug.trim(), description: description || undefined });
      setTitle(""); setSlug(""); setDescription("");
      toast.success("Página especial criada!");
    } catch { toast.error("Erro ao criar."); }
  };

  const startEdit = (p: any) => {
    setEditingId(p.id);
    setEditTitle(p.title);
    setEditSlug(p.slug);
    setEditDescription(p.description || "");
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditTitle("");
    setEditSlug("");
    setEditDescription("");
  };

  const handleUpdate = async () => {
    if (!editingId || !editTitle.trim() || !editSlug.trim()) return toast.error("Título e slug são obrigatórios.");
    try {
      await updatePage.mutateAsync({ id: editingId, title: editTitle.trim(), slug: editSlug.trim(), description: editDescription || undefined });
      toast.success("Página atualizada!");
      cancelEdit();
    } catch { toast.error("Erro ao atualizar."); }
  };

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Páginas Especiais</h2>
      <div className="space-y-2">
        <div className="flex gap-2 flex-wrap">
          <input value={title} onChange={(e) => autoSlug(e.target.value)} placeholder="Título (ex: Black Friday)" className="flex-1 min-w-[150px] h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
          <input value={slug} onChange={(e) => setSlug(e.target.value)} placeholder="Slug" className="w-40 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
          <button onClick={handleCreate} disabled={createPage.isPending} className="btn-accent flex items-center gap-2 text-sm" aria-label="Criar página especial"><Plus className="w-4 h-4" /> Criar</button>
        </div>
        <input value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Descrição (opcional)" className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
      </div>
      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Título</th><th className="text-left p-4 font-semibold text-foreground">Slug</th><th className="text-left p-4 font-semibold text-foreground hidden sm:table-cell">Descrição</th><th className="text-center p-4 font-semibold text-foreground">Ativa</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              pages.length === 0 ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Nenhuma página.</td></tr> :
                pages.map((p) => (
                  <tr key={p.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground">
                      {editingId === p.id ? (
                        <input value={editTitle} onChange={(e) => setEditTitle(e.target.value)} onKeyDown={(e) => e.key === "Enter" && handleUpdate()} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" autoFocus />
                      ) : p.title}
                    </td>
                    <td className="p-4 text-muted-foreground">
                      {editingId === p.id ? (
                        <input value={editSlug} onChange={(e) => setEditSlug(e.target.value)} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
                      ) : `/especial/${p.slug}`}
                    </td>
                    <td className="p-4 text-muted-foreground hidden sm:table-cell">
                      {editingId === p.id ? (
                        <input value={editDescription} onChange={(e) => setEditDescription(e.target.value)} className="w-full h-9 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Descrição" />
                      ) : ((p as any).description || "—")}
                    </td>
                    <td className="p-4 text-center">
                      <button onClick={async () => { try { await updatePage.mutateAsync({ id: p.id, active: !p.active }); } catch { toast.error("Erro."); } }} aria-label="Alternar status">
                        {p.active ? <ToggleRight className="w-7 h-7 text-success" /> : <ToggleLeft className="w-7 h-7 text-muted-foreground" />}
                      </button>
                    </td>
                    <td className="p-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        {editingId === p.id ? (
                          <>
                            <button onClick={handleUpdate} className="p-2 rounded-lg hover:bg-success/10 transition-colors" aria-label="Salvar"><Check className="w-4 h-4 text-success" /></button>
                            <button onClick={cancelEdit} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Cancelar"><X className="w-4 h-4 text-muted-foreground" /></button>
                          </>
                        ) : (
                          <>
                            <button onClick={() => startEdit(p)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                            <button onClick={async () => { if (!confirm("Excluir?")) return; try { await deletePage.mutateAsync(p.id); toast.success("Excluída."); } catch { toast.error("Erro."); } }} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir"><Trash2 className="w-4 h-4 text-destructive" /></button>
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

export default AdminSpecialPages;
