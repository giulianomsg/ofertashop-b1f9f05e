import { useState } from "react";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X, Code } from "lucide-react";
import { motion } from "framer-motion";
import { useInstitutionalPages, useCreateInstitutionalPage, useUpdateInstitutionalPage, useDeleteInstitutionalPage } from "@/hooks/useEntities";
import { toast } from "sonner";
// @ts-ignore
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const AdminInstitutionalPages = () => {
  const { data: pages = [], isLoading } = useInstitutionalPages();
  const createPage = useCreateInstitutionalPage();
  const updatePage = useUpdateInstitutionalPage();
  const deletePage = useDeleteInstitutionalPage();

  const [showModal, setShowModal] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState({ title: "", slug: "", content_html: "", active: true, section_type: "support" });
  const [showSource, setShowSource] = useState(false);

  const openCreate = () => {
    setEditingId(null);
    setForm({ title: "", slug: "", content_html: "", active: true, section_type: "support" });
    setShowSource(false);
    setShowModal(true);
  };

  const openEdit = (page: any) => {
    setEditingId(page.id);
    setForm({ title: page.title, slug: page.slug, content_html: page.content_html || "", active: page.active, section_type: page.section_type || "support" });
    setShowSource(false);
    setShowModal(true);
  };

  const handleSave = async () => {
    if (!form.title || !form.slug) {
      toast.error("Preencha título e slug.");
      return;
    }
    try {
      if (editingId) {
        await updatePage.mutateAsync({ id: editingId, ...form });
        toast.success("Página atualizada.");
      } else {
        await createPage.mutateAsync(form);
        toast.success("Página criada.");
      }
      setShowModal(false);
    } catch {
      toast.error("Erro ao salvar página.");
    }
  };

  const handleToggle = async (id: string, currentActive: boolean) => {
    try {
      await updatePage.mutateAsync({ id, active: !currentActive });
    } catch {
      toast.error("Erro ao alterar status.");
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Excluir esta página?")) return;
    try {
      await deletePage.mutateAsync(id);
      toast.success("Página excluída.");
    } catch {
      toast.error("Erro ao excluir.");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="font-display font-bold text-xl text-foreground">Páginas Institucionais (Rodapé)</h2>
        <button onClick={openCreate} className="btn-accent flex items-center gap-2 text-sm" aria-label="Nova página">
          <Plus className="w-4 h-4" /> Adicionar Página
        </button>
      </div>

      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border bg-secondary">
              <th className="text-left p-4 font-semibold text-foreground">Título</th>
              <th className="text-left p-4 font-semibold text-foreground hidden sm:table-cell">Slug</th>
              <th className="text-left p-4 font-semibold text-foreground hidden md:table-cell">Seção</th>
              <th className="text-center p-4 font-semibold text-foreground">Status</th>
              <th className="text-right p-4 font-semibold text-foreground">Ações</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              pages.length === 0 ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Nenhuma página.</td></tr> :
                pages.map((p: any) => (
                  <tr key={p.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 font-medium text-foreground">{p.title}</td>
                    <td className="p-4 text-muted-foreground hidden sm:table-cell">/p/{p.slug}</td>
                    <td className="p-4 text-muted-foreground hidden md:table-cell">
                      <span className={`text-xs px-2 py-1 rounded-full ${p.section_type === 'special' ? 'bg-accent/10 text-accent' : 'bg-secondary text-muted-foreground'}`}>
                        {p.section_type === 'special' ? 'Especial' : 'Suporte'}
                      </span>
                    </td>
                    <td className="p-4 text-center">
                      <button onClick={() => handleToggle(p.id, p.active)} aria-label="Alternar status">
                        {p.active ? <ToggleRight className="w-7 h-7 text-success" /> : <ToggleLeft className="w-7 h-7 text-muted-foreground" />}
                      </button>
                    </td>
                    <td className="p-4 text-right">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => openEdit(p)} className="p-2 rounded-lg hover:bg-secondary" aria-label="Editar página"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                        <button onClick={() => handleDelete(p.id)} className="p-2 rounded-lg hover:bg-destructive/10" aria-label="Excluir página"><Trash2 className="w-4 h-4 text-destructive" /></button>
                      </div>
                    </td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>

      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-foreground/20 backdrop-blur-sm">
          <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} className="bg-card rounded-2xl border border-border p-6 w-full max-w-3xl space-y-4 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between">
              <h3 className="font-display font-bold text-lg text-foreground">{editingId ? "Editar Página" : "Nova Página"}</h3>
              <button onClick={() => setShowModal(false)} className="p-1 rounded-lg hover:bg-secondary" aria-label="Fechar"><X className="w-5 h-5" /></button>
            </div>
            <div className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="text-xs font-semibold block mb-1">Título</label>
                  <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none" />
                </div>
                <div>
                  <label className="text-xs font-semibold block mb-1">Slug (URL)</label>
                  <input value={form.slug} onChange={(e) => setForm({ ...form, slug: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none" />
                </div>
              </div>
              <div>
                <label className="text-xs font-semibold block mb-1">Seção no Rodapé</label>
                <select value={form.section_type} onChange={(e) => setForm({ ...form, section_type: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none">
                  <option value="support">Suporte</option>
                  <option value="special">Página Especial</option>
                </select>
              </div>
              <div>
                <div className="flex items-center justify-between mb-1">
                  <label className="text-xs font-semibold">Conteúdo</label>
                  <button
                    type="button"
                    onClick={() => setShowSource(!showSource)}
                    className={`flex items-center gap-1.5 text-xs px-2 py-1 rounded-md transition-colors ${showSource ? 'bg-accent text-accent-foreground' : 'bg-secondary text-muted-foreground hover:text-foreground'}`}
                    aria-label="Alternar código fonte"
                  >
                    <Code className="w-3.5 h-3.5" /> {showSource ? "Editor Visual" : "Código Fonte"}
                  </button>
                </div>
                {showSource ? (
                  <textarea
                    value={form.content_html}
                    onChange={(e) => setForm({ ...form, content_html: e.target.value })}
                    className="w-full min-h-[300px] px-3 py-2 rounded-lg bg-secondary border-none font-mono text-xs"
                    placeholder="Cole seu HTML aqui..."
                  />
                ) : (
                  <div className="bg-secondary rounded-lg">
                    <ReactQuill theme="snow" value={form.content_html} onChange={(v: string) => setForm({ ...form, content_html: v })} className="min-h-[200px]" />
                  </div>
                )}
              </div>
            </div>
            <button onClick={handleSave} className="btn-accent w-full mt-4" aria-label="Salvar">Salvar</button>
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default AdminInstitutionalPages;
