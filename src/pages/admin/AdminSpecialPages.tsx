import { useState, useEffect } from "react";
import { Plus, Trash2, Pencil, Check, X, ToggleLeft, ToggleRight, List, Package, Search, Loader2, CheckSquare, Square } from "lucide-react";
import { useSpecialPages, useCreateSpecialPage, useUpdateSpecialPage, useDeleteSpecialPage, usePlatforms } from "@/hooks/useEntities";
import { useProducts } from "@/hooks/useProducts";
import { supabase } from "@/integrations/supabase/client";
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

  const { data: platforms = [] } = usePlatforms();
  const { data: products = [], isLoading: isLoadingProducts } = useProducts(false);
  
  const [managingPage, setManagingPage] = useState<any>(null);
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [platformFilter, setPlatformFilter] = useState("all");
  const [currentPage, setCurrentPage] = useState(1);
  const ITEMS_PER_PAGE = 8;
  
  const [linkedProducts, setLinkedProducts] = useState<Set<string>>(new Set());
  const [loadingLinks, setLoadingLinks] = useState(false);
  const [togglingId, setTogglingId] = useState<string | null>(null);

  const fetchLinkedProducts = async (pageId: string) => {
    setLoadingLinks(true);
    try {
      const { data, error } = await supabase
        .from('special_page_products')
        .select('product_id')
        .eq('special_page_id', pageId);
        
      if (error) throw error;
      setLinkedProducts(new Set(data.map((d: any) => d.product_id)));
    } catch (err) {
      toast.error("Erro ao carregar produtos vinculados.");
    } finally {
      setLoadingLinks(false);
    }
  };

  const openManageProducts = (page: any) => {
    setManagingPage(page);
    setSearchTerm("");
    setStatusFilter("all");
    setPlatformFilter("all");
    setCurrentPage(1);
    fetchLinkedProducts(page.id);
  };

  const toggleProductLink = async (productId: string) => {
    if (!managingPage) return;
    setTogglingId(productId);
    const isLinked = linkedProducts.has(productId);
    try {
      if (isLinked) {
        const { error } = await supabase.from('special_page_products')
          .delete()
          .match({ special_page_id: managingPage.id, product_id: productId });
        if (error) throw error;
        setLinkedProducts(prev => { const n = new Set(prev); n.delete(productId); return n; });
        toast.info("Produto removido da página.");
      } else {
        const { error } = await supabase.from('special_page_products')
          .insert({ special_page_id: managingPage.id, product_id: productId });
        if (error) throw error;
        setLinkedProducts(prev => { const n = new Set(prev); n.add(productId); return n; });
        toast.success("Produto adicionado à página.");
      }
    } catch (err) {
      toast.error("Erro ao alterar vínculo.");
    } finally {
      setTogglingId(null);
    }
  };

  const filteredProducts = products.filter((p: any) => {
    const term = searchTerm.toLowerCase();
    const matchesSearch = p.title.toLowerCase().includes(term) || p.store.toLowerCase().includes(term);
    const matchesStatus = statusFilter === "all" ? true : statusFilter === "active" ? p.is_active : !p.is_active;
    const matchesPlatform = platformFilter === "all" ? true : p.platform_id === platformFilter;
    return matchesSearch && matchesStatus && matchesPlatform;
  });

  const totalPages = Math.ceil(filteredProducts.length / ITEMS_PER_PAGE);
  const paginatedProducts = filteredProducts.slice((currentPage - 1) * ITEMS_PER_PAGE, currentPage * ITEMS_PER_PAGE);

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

      {/* Modal Gerenciar Produtos */}
      {managingPage && (
        <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-card border shadow-lg rounded-xl flex flex-col w-full max-w-4xl max-h-[90vh] relative animate-in fade-in zoom-in-95 duration-200" style={{ boxShadow: "var(--shadow-card)" }}>
            
            {/* Header */}
            <div className="flex items-center justify-between p-4 sm:p-6 border-b border-border shrink-0">
              <div>
                <h3 className="font-bold text-lg text-foreground flex items-center gap-2">
                  <List className="w-5 h-5 text-accent" /> Produtos na Página: {managingPage.title}
                </h3>
                <p className="text-xs text-muted-foreground mt-1">Selecione os produtos que serão listados para os clientes nesta página.</p>
              </div>
              <button onClick={() => setManagingPage(null)} className="p-2 rounded-lg hover:bg-secondary transition-colors text-muted-foreground">
                <X className="w-5 h-5"/>
              </button>
            </div>
            
            {/* Filters */}
            <div className="p-4 sm:p-6 border-b border-border shrink-0 bg-secondary/30 space-y-4">
              <div className="flex flex-col sm:flex-row gap-3">
                <div className="relative flex-1">
                  <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                  <input
                    type="text"
                    placeholder="Buscar por nome ou loja..."
                    value={searchTerm}
                    onChange={(e) => { setSearchTerm(e.target.value); setCurrentPage(1); }}
                    className="w-full h-10 pl-9 pr-3 rounded-lg bg-background border border-border text-sm focus:outline-none focus:ring-2 focus:ring-accent/30"
                  />
                </div>
                <div className="flex gap-3 sm:w-auto w-full">
                  <select
                    value={statusFilter}
                    onChange={(e) => { setStatusFilter(e.target.value); setCurrentPage(1); }}
                    className="h-10 px-3 rounded-lg bg-background border border-border text-sm focus:outline-none focus:ring-2 focus:ring-accent/30 flex-1 sm:w-36"
                  >
                    <option value="all">S: Todos</option>
                    <option value="active">S: Ativos</option>
                    <option value="inactive">S: Inativos</option>
                  </select>
                  <select
                    value={platformFilter}
                    onChange={(e) => { setPlatformFilter(e.target.value); setCurrentPage(1); }}
                    className="h-10 px-3 rounded-lg bg-background border border-border text-sm focus:outline-none focus:ring-2 focus:ring-accent/30 flex-1 sm:w-44"
                  >
                    <option value="all">P: Todas</option>
                    <option value="">P: Nenhuma</option>
                    {platforms.map((p: any) => (
                      <option key={p.id} value={p.id}>P: {p.name}</option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="flex justify-between items-center text-xs font-medium text-muted-foreground">
                <span>Total retornados: {filteredProducts.length}</span>
                {loadingLinks && <span className="flex items-center gap-1 text-accent"><Loader2 className="w-3 h-3 animate-spin" /> Sincronizando vínculos...</span>}
              </div>
            </div>

            {/* List */}
            <div className="flex-1 overflow-y-auto p-4 sm:p-6 space-y-3 min-h-[300px]">
              {isLoadingProducts ? (
                 <div className="flex justify-center py-10 text-muted-foreground"><Loader2 className="w-6 h-6 animate-spin" /></div>
              ) : paginatedProducts.length === 0 ? (
                 <div className="text-center py-10 text-muted-foreground border border-dashed rounded-lg">Nenhum produto atendeu aos filtros.</div>
              ) : (
                paginatedProducts.map((p: any) => {
                  const isLinked = linkedProducts.has(p.id);
                  const isToggling = togglingId === p.id;
                  
                  return (
                    <div key={p.id} className={`flex items-center gap-4 p-3 rounded-lg border transition-all ${isLinked ? 'bg-accent/5 border-accent/20' : 'bg-background hover:bg-secondary/50'}`}>
                      <div className="w-12 h-12 rounded-md border bg-white flex items-center justify-center shrink-0 p-1">
                        {p.image_url ? (
                          <img src={p.image_url} alt={p.title} className="w-full h-full object-contain mix-blend-multiply" />
                        ) : (
                          <Package className="w-6 h-6 text-muted-foreground/50" />
                        )}
                      </div>
                      
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-semibold text-foreground line-clamp-1 truncate" title={p.title}>{p.title}</p>
                        <div className="flex items-center gap-2 mt-1">
                          <span className="text-xs font-bold text-emerald-600">R$ {Number(p.price).toFixed(2).replace('.', ',')}</span>
                          <span className="text-xs text-muted-foreground">Loja: {p.store}</span>
                          {!p.is_active && (
                             <span className="text-[10px] uppercase font-bold text-red-600 bg-red-500/10 px-1.5 py-0.5 rounded border border-red-500/20">Inativo</span>
                          )}
                        </div>
                      </div>

                      <button 
                        onClick={() => toggleProductLink(p.id)}
                        disabled={isToggling || loadingLinks}
                        className={`h-9 px-4 rounded-lg flex items-center gap-2 text-sm font-medium transition-colors shrink-0 ${isLinked ? 'bg-accent text-accent-foreground shadow-sm hover:bg-accent/90' : 'bg-secondary text-foreground border border-border hover:border-accent hover:text-accent disabled:hover:border-border disabled:hover:text-foreground'}`}
                      >
                         {isToggling ? (
                           <Loader2 className="w-4 h-4 animate-spin" />
                         ) : isLinked ? (
                           <><CheckSquare className="w-4 h-4" /> <span className="hidden sm:inline">Adicionado</span></>
                         ) : (
                           <><Square className="w-4 h-4" /> <span className="hidden sm:inline">Adicionar</span></>
                         )}
                      </button>
                    </div>
                  );
                })
              )}
            </div>

            {/* Pagination */}
            {totalPages > 0 && (
              <div className="p-4 sm:p-6 border-t border-border flex items-center justify-between shrink-0 bg-secondary/10">
                <span className="text-xs text-muted-foreground">Página {currentPage} de {totalPages}</span>
                <div className="flex gap-2">
                  <button onClick={() => setCurrentPage(p => Math.max(1, p - 1))} disabled={currentPage === 1} className="h-8 px-3 rounded-md border text-xs font-medium hover:bg-secondary disabled:opacity-50">Anterior</button>
                  <button onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))} disabled={currentPage === totalPages} className="h-8 px-3 rounded-md border text-xs font-medium hover:bg-secondary disabled:opacity-50">Próxima</button>
                </div>
              </div>
            )}
            
          </div>
        </div>
      )}

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
                            <button onClick={() => openManageProducts(p)} className="p-2 rounded-lg hover:bg-secondary transition-colors text-accent flex items-center gap-1" aria-label="Gerenciar Produtos" title="Gerenciar Produtos da Página"><List className="w-4 h-4" /></button>
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
