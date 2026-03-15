import { useState } from "react";
import { Plus, Trash2, ToggleLeft, ToggleRight } from "lucide-react";
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
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Título</th><th className="text-left p-4 font-semibold text-foreground">Slug</th><th className="text-center p-4 font-semibold text-foreground">Ativa</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={4} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              pages.length === 0 ? <tr><td colSpan={4} className="p-8 text-center text-muted-foreground">Nenhuma página.</td></tr> :
                pages.map((p) => (
                  <tr key={p.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-foreground">{p.title}</td>
                    <td className="p-4 text-muted-foreground">/especial/{p.slug}</td>
                    <td className="p-4 text-center">
                      <button onClick={async () => { try { await updatePage.mutateAsync({ id: p.id, active: !p.active }); } catch { toast.error("Erro."); } }} aria-label="Alternar status">
                        {p.active ? <ToggleRight className="w-7 h-7 text-success" /> : <ToggleLeft className="w-7 h-7 text-muted-foreground" />}
                      </button>
                    </td>
                    <td className="p-4 text-right"><button onClick={async () => { if (!confirm("Excluir?")) return; try { await deletePage.mutateAsync(p.id); toast.success("Excluída."); } catch { toast.error("Erro."); } }} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir página"><Trash2 className="w-4 h-4 text-destructive" /></button></td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AdminSpecialPages;
