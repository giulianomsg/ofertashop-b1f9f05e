import { useState, useRef } from "react";
import { motion } from "framer-motion";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X, Image, Loader2, Upload } from "lucide-react";
import { useProducts, useCreateProduct, useUpdateProduct, useDeleteProduct } from "@/hooks/useProducts";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const emptyForm = {
  title: "",
  affiliate_url: "",
  price: "",
  store: "",
  category: "Eletrônicos",
  description: "",
  image_url: "",
  original_price: "",
  discount: "",
  badge: "",
};

const categories = ["Eletrônicos", "Wearables", "Áudio", "Periféricos", "Acessórios", "Casa & Decoração", "Esportes"];

const AdminProducts = () => {
  const { data: products = [], isLoading } = useProducts(false);
  const createProduct = useCreateProduct();
  const updateProduct = useUpdateProduct();
  const deleteProduct = useDeleteProduct();

  const [showModal, setShowModal] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(emptyForm);
  const [importingImage, setImportingImage] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const openCreate = () => {
    setEditingId(null);
    setForm(emptyForm);
    setShowModal(true);
  };

  const openEdit = (product: (typeof products)[0]) => {
    setEditingId(product.id);
    setForm({
      title: product.title,
      affiliate_url: product.affiliate_url,
      price: String(product.price).replace(".", ","),
      store: product.store,
      category: product.category,
      description: product.description || "",
      image_url: product.image_url || "",
      original_price: product.original_price ? String(product.original_price).replace(".", ",") : "",
      discount: product.discount ? String(product.discount) : "",
      badge: product.badge || "",
    });
    setShowModal(true);
  };

  const importImageFromUrl = async () => {
    if (!form.image_url) {
      toast.error("Cole uma URL primeiro.");
      return;
    }

    setImportingImage(true);
    try {
      const { data, error } = await supabase.functions.invoke("image-proxy", {
        body: { imageUrl: form.image_url },
      });

      if (error) throw error;
      if (!data?.publicUrl) throw new Error("URL não retornada");

      setForm((f) => ({ ...f, image_url: data.publicUrl }));
      toast.success("Imagem importada com sucesso!");
    } catch (err: any) {
      console.error(err);
      const msg = err?.message || "Erro ao importar imagem.";
      toast.error(msg);
    } finally {
      setImportingImage(false);
    }
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (!file.type.startsWith("image/")) {
      toast.error("Selecione um arquivo de imagem.");
      return;
    }

    setImportingImage(true);
    try {
      const ext = file.name.split(".").pop() || "jpg";
      const fileName = `${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`;

      const { error: uploadError } = await supabase.storage
        .from("product-images")
        .upload(fileName, file, { contentType: file.type });

      if (uploadError) throw uploadError;

      const { data: urlData } = supabase.storage
        .from("product-images")
        .getPublicUrl(fileName);

      setForm((f) => ({ ...f, image_url: urlData.publicUrl }));
      toast.success("Imagem enviada com sucesso!");
    } catch (err) {
      console.error(err);
      toast.error("Erro ao enviar imagem.");
    } finally {
      setImportingImage(false);
      if (fileInputRef.current) fileInputRef.current.value = "";
    }
  };

  const handleSave = async () => {
    if (!form.title || !form.affiliate_url || !form.price || !form.store) {
      toast.error("Preencha todos os campos obrigatórios.");
      return;
    }

    const payload: Record<string, any> = {
      title: form.title,
      affiliate_url: form.affiliate_url,
      price: parseFloat(form.price.replace(",", ".")),
      store: form.store,
      category: form.category,
      description: form.description || null,
      image_url: form.image_url || null,
      original_price: form.original_price ? parseFloat(form.original_price.replace(",", ".")) : null,
      discount: form.discount ? parseInt(form.discount) : null,
      badge: form.badge || null,
    };

    try {
      if (editingId) {
        await updateProduct.mutateAsync({ id: editingId, ...payload });
        toast.success("Produto atualizado!");
      } else {
        await createProduct.mutateAsync(payload as any);
        toast.success("Produto criado!");
      }
      setShowModal(false);
      setForm(emptyForm);
      setEditingId(null);
    } catch (err) {
      console.error("Save error:", err);
      toast.error("Erro ao salvar produto. Verifique suas permissões.");
    }
  };

  const handleToggle = async (id: string, currentActive: boolean) => {
    try {
      await updateProduct.mutateAsync({ id, is_active: !currentActive });
    } catch {
      toast.error("Erro ao atualizar status.");
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Tem certeza que deseja excluir este produto?")) return;
    try {
      await deleteProduct.mutateAsync(id);
      toast.success("Produto excluído.");
    } catch {
      toast.error("Erro ao excluir produto.");
    }
  };

  const isSaving = createProduct.isPending || updateProduct.isPending;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="font-display font-bold text-xl text-foreground">Produtos</h2>
        <button onClick={openCreate} className="btn-accent flex items-center gap-2 text-sm">
          <Plus className="w-4 h-4" /> Novo Produto
        </button>
      </div>

      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border bg-secondary">
                <th className="text-left p-4 font-semibold text-foreground">Produto</th>
                <th className="text-left p-4 font-semibold text-foreground hidden md:table-cell">Loja</th>
                <th className="text-left p-4 font-semibold text-foreground">Preço</th>
                <th className="text-center p-4 font-semibold text-foreground hidden md:table-cell">Cliques</th>
                <th className="text-center p-4 font-semibold text-foreground">Status</th>
                <th className="text-right p-4 font-semibold text-foreground">Ações</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                <tr><td colSpan={6} className="p-8 text-center text-muted-foreground">Carregando...</td></tr>
              ) : products.length === 0 ? (
                <tr><td colSpan={6} className="p-8 text-center text-muted-foreground">Nenhum produto cadastrado.</td></tr>
              ) : products.map((product) => (
                <motion.tr
                  key={product.id}
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors"
                >
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <img src={product.image_url || "/placeholder.svg"} alt="" className="w-10 h-10 rounded-lg object-cover bg-secondary" />
                      <span className="font-medium text-foreground line-clamp-1">{product.title}</span>
                    </div>
                  </td>
                  <td className="p-4 text-muted-foreground hidden md:table-cell">{product.store}</td>
                  <td className="p-4 font-semibold text-foreground">R$ {Number(product.price).toFixed(2).replace(".", ",")}</td>
                  <td className="p-4 text-center text-muted-foreground hidden md:table-cell">{product.clicks.toLocaleString()}</td>
                  <td className="p-4 text-center">
                    <button onClick={() => handleToggle(product.id, product.is_active)} className="inline-flex">
                      {product.is_active ? (
                        <ToggleRight className="w-7 h-7 text-success" />
                      ) : (
                        <ToggleLeft className="w-7 h-7 text-muted-foreground" />
                      )}
                    </button>
                  </td>
                  <td className="p-4 text-right">
                    <div className="flex items-center justify-end gap-1">
                      <button onClick={() => openEdit(product)} className="p-2 rounded-lg hover:bg-secondary transition-colors">
                        <Pencil className="w-4 h-4 text-muted-foreground" />
                      </button>
                      <button onClick={() => handleDelete(product.id)} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors">
                        <Trash2 className="w-4 h-4 text-destructive" />
                      </button>
                    </div>
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal - closes ONLY via X button */}
      {showModal && (
        <div className="fixed inset-0 bg-foreground/20 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-card rounded-2xl border border-border p-6 w-full max-w-lg space-y-4 max-h-[90vh] overflow-y-auto"
            style={{ boxShadow: "var(--shadow-elevated)" }}
          >
            <div className="flex items-center justify-between">
              <h3 className="font-display font-bold text-lg text-foreground">
                {editingId ? "Editar Produto" : "Novo Produto"}
              </h3>
              <button onClick={() => setShowModal(false)} className="p-1.5 rounded-lg hover:bg-secondary"><X className="w-4 h-4" /></button>
            </div>

            <div className="space-y-3">
              {/* Image section */}
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Imagem do Produto</label>
                {form.image_url && (
                  <div className="mb-2 rounded-lg overflow-hidden border border-border bg-secondary">
                    <img src={form.image_url} alt="Preview" className="w-full h-40 object-contain" />
                  </div>
                )}

                {/* URL import */}
                <div className="flex gap-2">
                  <input
                    value={form.image_url}
                    onChange={(e) => setForm({ ...form, image_url: e.target.value })}
                    className="flex-1 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                    placeholder="Cole a URL ou link de compartilhamento"
                  />
                  <button
                    type="button"
                    onClick={importImageFromUrl}
                    disabled={importingImage || !form.image_url}
                    className="h-10 px-3 rounded-lg bg-accent text-accent-foreground text-xs font-semibold flex items-center gap-1.5 hover:bg-accent/90 disabled:opacity-50 transition-colors whitespace-nowrap"
                  >
                    {importingImage ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Image className="w-3.5 h-3.5" />}
                    Importar
                  </button>
                </div>

                {/* Manual file upload */}
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  onChange={handleFileUpload}
                  className="hidden"
                />
                <button
                  type="button"
                  onClick={() => fileInputRef.current?.click()}
                  disabled={importingImage}
                  className="mt-2 w-full h-10 rounded-lg border border-dashed border-border bg-secondary/50 text-sm text-muted-foreground flex items-center justify-center gap-2 hover:bg-secondary transition-colors disabled:opacity-50"
                >
                  <Upload className="w-3.5 h-3.5" />
                  Enviar foto do computador
                </button>
                <p className="text-[11px] text-muted-foreground mt-1">Cole um link (direto ou de compartilhamento) e clique Importar, ou envie uma foto manualmente.</p>
              </div>

              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Título *</label>
                <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Nome do produto" />
              </div>

              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Link de Afiliado *</label>
                <input value={form.affiliate_url} onChange={(e) => setForm({ ...form, affiliate_url: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="https://..." />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Preço (R$) *</label>
                  <input value={form.price} onChange={(e) => setForm({ ...form, price: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="99,90" />
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Preço Original</label>
                  <input value={form.original_price} onChange={(e) => setForm({ ...form, original_price: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="149,90" />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Desconto (%)</label>
                  <input value={form.discount} onChange={(e) => setForm({ ...form, discount: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="30" />
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Badge</label>
                  <input value={form.badge} onChange={(e) => setForm({ ...form, badge: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Ex: Mais Vendido" />
                </div>
              </div>

              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Loja *</label>
                <input value={form.store} onChange={(e) => setForm({ ...form, store: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Nome da loja" />
              </div>

              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Categoria</label>
                <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
                  {categories.map((c) => (
                    <option key={c} value={c}>{c}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Descrição</label>
                <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} className="w-full p-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 resize-none h-20" placeholder="Descrição do produto..." />
              </div>
            </div>

            <button onClick={handleSave} disabled={isSaving} className="btn-accent w-full disabled:opacity-50">
              {isSaving ? "Salvando..." : editingId ? "Salvar Alterações" : "Salvar Produto"}
            </button>
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default AdminProducts;
