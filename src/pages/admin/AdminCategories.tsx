import { useState } from "react";
import { Plus, Trash2, Pencil, Check, X, List, Package, Loader2 } from "lucide-react";
import { useQueryClient } from "@tanstack/react-query";
import { useCategories, useCreateCategory, useUpdateCategory, useDeleteCategory } from "@/hooks/useEntities";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const AdminCategories = () => {
  const queryClient = useQueryClient();
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

  const [viewingCategory, setViewingCategory] = useState<{id: string, name: string, icon?: string | null} | null>(null);
  const [categoryProducts, setCategoryProducts] = useState<{id: string, title: string, price: number, image_url: string, is_active: boolean}[]>([]);
  const [loadingProducts, setLoadingProducts] = useState(false);
  const [changingProduct, setChangingProduct] = useState<string | null>(null);

  const fetchCategoryProducts = async (c: {id: string, name: string, icon?: string | null}) => {
    setViewingCategory(c);
    setLoadingProducts(true);
    try {
      const { data, error } = await supabase
        .from("products")
        .select("id, title, price, image_url, is_active")
        .eq("category_id", c.id)
        .order("created_at", { ascending: false });
      if (error) throw error;
      setCategoryProducts(data || []);
    } catch (err) {
      toast.error("Erro ao puxar produtos da categoria.");
    } finally {
      setLoadingProducts(false);
    }
  };

  const handleMoveProduct = async (productId: string, newCategoryId: string) => {
    if (!newCategoryId) return;
    setChangingProduct(productId);
    try {
      const { error } = await supabase.from("products").update({ category_id: newCategoryId }).eq("id", productId);
      if (error) throw error;
      setCategoryProducts(prev => prev.filter(p => p.id !== productId));
      queryClient.invalidateQueries({ queryKey: ["categories"] });
      toast.success("Produto movido com sucesso!");
    } catch (err) {
      toast.error("Erro ao mover produto.");
    } finally {
      setChangingProduct(null);
    }
  };

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

  const startEdit = (c: {id: string, name: string, slug: string, icon?: string | null}) => {
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

      {viewingCategory && (
        <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-card border shadow-lg rounded-xl p-6 w-full max-w-2xl relative animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] flex flex-col">
            <button onClick={() => setViewingCategory(null)} className="absolute top-4 right-4 text-muted-foreground hover:text-foreground">
              <X className="w-5 h-5"/>
            </button>
            <h3 className="font-bold text-lg mb-1 flex items-center gap-2">
              {viewingCategory.icon || <Package className="w-5 h-5"/>} 
              Produtos na categoria: {viewingCategory.name}
            </h3>
            <p className="text-xs text-muted-foreground mb-4">{categoryProducts.length} itens encontrados</p>
            
            <div className="overflow-y-auto pr-2 space-y-3 flex-1 min-h-[100px]">
              {loadingProducts ? (
                <div className="text-center py-8 text-muted-foreground text-sm">Carregando produtos...</div>
              ) : categoryProducts.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground text-sm">Nenhum produto está usando esta categoria.</div>
              ) : (
                categoryProducts.map((p) => (
                  <div key={p.id} className="flex flex-col sm:flex-row gap-3 p-3 rounded-lg border bg-secondary/50 items-start sm:items-center">
                    <div className="flex gap-3 flex-1 min-w-0 w-full">
                      <div className="w-12 h-12 rounded-md border bg-white flex items-center justify-center shrink-0 p-1">
                        {p.image_url ? (
                          <img src={p.image_url} alt={p.title} className="w-full h-full object-contain mix-blend-multiply" />
                        ) : (
                          <Package className="w-6 h-6 text-muted-foreground/50" />
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium line-clamp-1 truncate" title={p.title}>{p.title}</p>
                        <div className="flex items-center gap-2 mt-1">
                          <span className="text-xs font-bold text-accent">R$ {Number(p.price).toFixed(2).replace('.', ',')}</span>
                          {p.is_active ? (
                             <span className="text-[10px] uppercase font-bold text-green-600 bg-green-500/10 px-1.5 py-0.5 rounded border border-green-500/20">Ativo</span>
                          ) : (
                             <span className="text-[10px] uppercase font-bold text-red-600 bg-red-500/10 px-1.5 py-0.5 rounded border border-red-500/20">Inativo</span>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="w-full sm:w-auto shrink-0 flex items-center gap-2 border-t sm:border-t-0 pt-2 sm:pt-0 mt-2 sm:mt-0">
                       <span className="text-xs font-medium text-muted-foreground whitespace-nowrap">Mover para:</span>
                       <div className="relative">
                         {changingProduct === p.id && (
                           <Loader2 className="absolute right-2 top-1/2 -translate-y-1/2 w-3.5 h-3.5 animate-spin text-muted-foreground pointer-events-none" />
                         )}
                         <select
                           className="h-8 px-2 pr-7 text-xs rounded border border-border bg-background focus:ring-1 focus:ring-accent w-full sm:w-[150px] disabled:opacity-50 appearance-none"
                           value=""
                           onChange={(e) => handleMoveProduct(p.id, e.target.value)}
                           disabled={changingProduct === p.id}
                         >
                           <option value="" disabled>Selecionar...</option>
                           {categories.map((cat: any) => (
                             cat.id !== viewingCategory.id && (
                               <option key={cat.id} value={cat.id}>{cat.name}</option>
                             )
                           ))}
                         </select>
                       </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      )}

      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead><tr className="border-b border-border bg-secondary"><th className="text-left p-4 font-semibold text-foreground">Nome</th><th className="text-left p-4 font-semibold text-foreground">Slug</th><th className="text-left p-4 font-semibold text-foreground hidden sm:table-cell">Ícone</th><th className="text-center p-4 font-semibold text-foreground">Produtos</th><th className="text-right p-4 font-semibold text-foreground">Ações</th></tr></thead>
          <tbody>
            {isLoading ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              categories.length === 0 ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Nenhuma categoria.</td></tr> :
                categories.map((c: {id: string, name: string, slug: string, icon: string | null, products: any}) => {
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
                            {productCount > 0 && (
                               <button onClick={() => fetchCategoryProducts(c)} className="p-2 rounded-lg hover:bg-secondary transition-colors text-accent flex items-center gap-1" aria-label="Ver produtos" title="Ver produtos nesta categoria">
                                  <List className="w-4 h-4" />
                               </button>
                            )}
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
