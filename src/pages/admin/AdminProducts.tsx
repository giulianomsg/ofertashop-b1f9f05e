import { useState, useRef, useEffect } from "react";
import { motion } from "framer-motion";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X, Image, Loader2, Upload, Video } from "lucide-react";
import { useProducts, useCreateProduct, useUpdateProduct, useDeleteProduct } from "@/hooks/useProducts";
import { useCategories, useBrands, useModels, usePlatforms } from "@/hooks/useEntities";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
// @ts-ignore
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

const emptyForm = {
  title: "",
  affiliate_url: "",
  price: "",
  store: "",
  category: "",
  description: "",
  image_url: "",
  original_price: "",
  discount: "",
  badge: "",
  gallery_urls: [] as string[],
  brand_id: "",
  model_id: "",
  platform_id: "",
  video_url: "",
};

const AdminProducts = () => {
  const { data: products = [], isLoading } = useProducts(false);
  const createProduct = useCreateProduct();
  const updateProduct = useUpdateProduct();
  const deleteProduct = useDeleteProduct();
  const { data: categories = [] } = useCategories();
  const { data: brands = [] } = useBrands();
  const { data: platforms = [] } = usePlatforms();
  const { user } = useAuth();

  const [showModal, setShowModal] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(emptyForm);
  const [importingImage, setImportingImage] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const galleryInputRef = useRef<HTMLInputElement>(null);

  // Filter models by selected brand
  const { data: models = [] } = useModels(form.brand_id || undefined);

  // Auto-calculate discount percentage
  const calcDiscount = (price: string, originalPrice: string) => {
    const p = parseFloat(price.replace(",", "."));
    const op = parseFloat(originalPrice.replace(",", "."));
    if (op > 0 && p > 0 && op > p) {
      return Math.round(((op - p) / op) * 100).toString();
    }
    return "";
  };

  const handlePriceChange = (field: "price" | "original_price", value: string) => {
    const newForm = { ...form, [field]: value };
    newForm.discount = calcDiscount(
      field === "price" ? value : form.price,
      field === "original_price" ? value : form.original_price
    );
    setForm(newForm);
  };

  const openCreate = () => {
    setEditingId(null);
    setForm({ ...emptyForm, category: categories[0]?.name || "" });
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
      gallery_urls: product.gallery_urls || [],
      brand_id: (product as any).brand_id || "",
      model_id: (product as any).model_id || "",
      platform_id: (product as any).platform_id || "",
      video_url: (product as any).video_url || "",
    });
    setShowModal(true);
  };

  const importImageFromUrl = async () => {
    if (!form.image_url) { toast.error("Cole uma URL primeiro."); return; }
    setImportingImage(true);
    try {
      const { data, error } = await supabase.functions.invoke("image-proxy", { body: { imageUrl: form.image_url } });
      if (error) throw error;
      if (!data?.publicUrl) throw new Error("URL não retornada");
      setForm((f) => ({ ...f, image_url: data.publicUrl }));
      toast.success("Imagem importada com sucesso!");
    } catch (err: any) {
      toast.error(err?.message || "Erro ao importar imagem.");
    } finally { setImportingImage(false); }
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !file.type.startsWith("image/")) { toast.error("Selecione uma imagem."); return; }
    setImportingImage(true);
    try {
      const fileName = `${Date.now()}-${Math.random().toString(36).slice(2)}.${file.name.split(".").pop() || "jpg"}`;
      const { error } = await supabase.storage.from("product-images").upload(fileName, file, { contentType: file.type });
      if (error) throw error;
      const { data } = supabase.storage.from("product-images").getPublicUrl(fileName);
      setForm((f) => ({ ...f, image_url: data.publicUrl }));
      toast.success("Imagem enviada!");
    } catch { toast.error("Erro ao enviar imagem."); }
    finally { setImportingImage(false); if (fileInputRef.current) fileInputRef.current.value = ""; }
  };

  const handleGalleryUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (form.gallery_urls.length >= 15) { toast.error("Limite máximo de 15 fotos alcançado."); return; }
    if (!file.type.startsWith("image/")) { toast.error("Selecione uma imagem."); return; }
    setImportingImage(true);
    try {
      const fileName = `${Date.now()}-${Math.random().toString(36).slice(2)}.${file.name.split(".").pop() || "jpg"}`;
      const { error } = await supabase.storage.from("product-images").upload(fileName, file, { contentType: file.type });
      if (error) throw error;
      const { data } = supabase.storage.from("product-images").getPublicUrl(fileName);
      setForm((f) => ({ ...f, gallery_urls: [...f.gallery_urls, data.publicUrl] }));
      toast.success("Foto adicional enviada!");
    } catch { toast.error("Erro ao enviar imagem."); }
    finally { setImportingImage(false); if (galleryInputRef.current) galleryInputRef.current.value = ""; }
  };

  const removeGalleryImage = (index: number) => {
    setForm(f => ({ ...f, gallery_urls: f.gallery_urls.filter((_, i) => i !== index) }));
  };

  const handleAffiliatePaste = async (e: React.ClipboardEvent<HTMLInputElement>) => {
    const pastedText = e.clipboardData.getData("text");
    if (pastedText.startsWith("http") && !form.image_url) {
      setTimeout(async () => {
        setImportingImage(true);
        try {
          const { data, error } = await supabase.functions.invoke("image-proxy", { body: { imageUrl: pastedText } });
          if (!error && data?.publicUrl) {
            setForm((f) => ({ ...f, image_url: data.publicUrl }));
            toast.success("Imagem importada automaticamente!");
          }
        } catch {}
        finally { setImportingImage(false); }
      }, 0);
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
      category: form.category || categories[0]?.name || "Outros",
      description: form.description || null,
      image_url: form.image_url || null,
      original_price: form.original_price ? parseFloat(form.original_price.replace(",", ".")) : null,
      discount: form.discount ? parseInt(form.discount) : null,
      badge: form.badge || null,
      gallery_urls: form.gallery_urls,
      brand_id: form.brand_id || null,
      model_id: form.model_id || null,
      platform_id: form.platform_id || null,
      video_url: form.video_url || null,
    };

    if (!editingId && user) {
      payload.registered_by = user.id;
    }

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
      toast.error("Erro ao salvar produto.");
    }
  };

  const handleToggle = async (id: string, currentActive: boolean) => {
    try { await updateProduct.mutateAsync({ id, is_active: !currentActive }); }
    catch { toast.error("Erro ao atualizar status."); }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Excluir este produto?")) return;
    try { await deleteProduct.mutateAsync(id); toast.success("Produto excluído."); }
    catch { toast.error("Erro ao excluir."); }
  };

  const isSaving = createProduct.isPending || updateProduct.isPending;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="font-display font-bold text-xl text-foreground">Produtos</h2>
        <button onClick={openCreate} className="btn-accent flex items-center gap-2 text-sm" aria-label="Novo produto">
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
                <motion.tr key={product.id} initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <img src={product.image_url || "/placeholder.svg"} alt={product.title} className="w-10 h-10 rounded-lg object-cover bg-secondary" />
                      <span className="font-medium text-foreground line-clamp-1">{product.title}</span>
                    </div>
                  </td>
                  <td className="p-4 text-muted-foreground hidden md:table-cell">{product.store}</td>
                  <td className="p-4 font-semibold text-foreground">R$ {Number(product.price).toFixed(2).replace(".", ",")}</td>
                  <td className="p-4 text-center text-muted-foreground hidden md:table-cell">{product.clicks.toLocaleString()}</td>
                  <td className="p-4 text-center">
                    <button onClick={() => handleToggle(product.id, product.is_active)} className="inline-flex" aria-label="Alternar status">
                      {product.is_active ? <ToggleRight className="w-7 h-7 text-success" /> : <ToggleLeft className="w-7 h-7 text-muted-foreground" />}
                    </button>
                  </td>
                  <td className="p-4 text-right">
                    <div className="flex items-center justify-end gap-1">
                      <button onClick={() => openEdit(product)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar produto"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                      <button onClick={() => handleDelete(product.id)} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir produto"><Trash2 className="w-4 h-4 text-destructive" /></button>
                    </div>
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {showModal && (
        <div className="fixed inset-0 bg-foreground/20 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-card rounded-2xl border border-border p-6 w-full max-w-2xl space-y-4 max-h-[90vh] overflow-y-auto"
            style={{ boxShadow: "var(--shadow-elevated)" }}
          >
            <div className="flex items-center justify-between">
              <h3 className="font-display font-bold text-lg text-foreground">
                {editingId ? "Editar Produto" : "Novo Produto"}
              </h3>
              <button onClick={() => setShowModal(false)} className="p-1.5 rounded-lg hover:bg-secondary" aria-label="Fechar"><X className="w-4 h-4" /></button>
            </div>

            <div className="space-y-3">
              {/* Image section */}
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Imagem Principal</label>
                {form.image_url && (
                  <div className="mb-2 rounded-lg overflow-hidden border border-border bg-secondary">
                    <img src={form.image_url} alt="Preview" className="w-full h-40 object-contain" />
                  </div>
                )}
                <div className="flex gap-2">
                  <input value={form.image_url} onChange={(e) => setForm({ ...form, image_url: e.target.value })} className="flex-1 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="URL da imagem" />
                  <button type="button" onClick={importImageFromUrl} disabled={importingImage || !form.image_url} className="h-10 px-3 rounded-lg bg-accent text-accent-foreground text-xs font-semibold flex items-center gap-1.5 hover:bg-accent/90 disabled:opacity-50 transition-colors whitespace-nowrap" aria-label="Importar imagem">
                    {importingImage ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Image className="w-3.5 h-3.5" />} Importar
                  </button>
                </div>
                <input ref={fileInputRef} type="file" accept="image/*" onChange={handleFileUpload} className="hidden" />
                <button type="button" onClick={() => fileInputRef.current?.click()} disabled={importingImage} className="mt-2 w-full h-10 rounded-lg border border-dashed border-border bg-secondary/50 text-sm text-muted-foreground flex items-center justify-center gap-2 hover:bg-secondary transition-colors disabled:opacity-50" aria-label="Upload foto principal">
                  <Upload className="w-3.5 h-3.5" /> Enviar foto principal
                </button>
              </div>

              {/* Gallery */}
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">
                  Galeria de Fotos ({form.gallery_urls.length}/15)
                </label>
                {form.gallery_urls.length > 0 && (
                  <div className="flex flex-wrap gap-2 mb-2">
                    {form.gallery_urls.map((url, idx) => (
                      <div key={idx} className="relative w-16 h-16 rounded-md overflow-hidden bg-secondary border border-border">
                        <img src={url} alt={`Galeria ${idx + 1}`} className="w-full h-full object-cover" />
                        <button type="button" onClick={() => removeGalleryImage(idx)} className="absolute top-0.5 right-0.5 bg-background/80 text-foreground p-1 rounded hover:bg-destructive hover:text-destructive-foreground transition-colors" aria-label="Remover imagem">
                          <X className="w-3 h-3" />
                        </button>
                      </div>
                    ))}
                  </div>
                )}
                {form.gallery_urls.length < 15 && (
                  <>
                    <input ref={galleryInputRef} type="file" accept="image/*" onChange={handleGalleryUpload} className="hidden" />
                    <button type="button" onClick={() => galleryInputRef.current?.click()} disabled={importingImage} className="w-full h-10 rounded-lg border border-dashed border-border bg-secondary/50 text-sm text-muted-foreground flex items-center justify-center gap-2 hover:bg-secondary transition-colors disabled:opacity-50" aria-label="Adicionar foto à galeria">
                      <Upload className="w-3.5 h-3.5" /> Adicionar foto (máx. 15)
                    </button>
                  </>
                )}
              </div>

              {/* Video URL */}
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">URL do Vídeo</label>
                <div className="flex items-center gap-2">
                  <Video className="w-4 h-4 text-muted-foreground shrink-0" />
                  <input value={form.video_url} onChange={(e) => setForm({ ...form, video_url: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="https://youtube.com/watch?v=..." />
                </div>
              </div>

              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Título *</label>
                <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Nome do produto" />
              </div>

              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Link de Afiliado *</label>
                <input value={form.affiliate_url} onChange={(e) => setForm({ ...form, affiliate_url: e.target.value })} onPaste={handleAffiliatePaste} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Cole aqui (ex: https://...)" />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Preço (R$) *</label>
                  <input value={form.price} onChange={(e) => handlePriceChange("price", e.target.value)} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="99,90" />
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Preço Original</label>
                  <input value={form.original_price} onChange={(e) => handlePriceChange("original_price", e.target.value)} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="149,90" />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Desconto (%) — auto</label>
                  <input value={form.discount} onChange={(e) => setForm({ ...form, discount: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Calculado auto" />
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

              {/* Dynamic selects */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Categoria</label>
                  <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
                    <option value="">Selecione</option>
                    {categories.map((c) => <option key={c.id} value={c.name}>{c.name}</option>)}
                  </select>
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Plataforma</label>
                  <select value={form.platform_id} onChange={(e) => setForm({ ...form, platform_id: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
                    <option value="">Selecione</option>
                    {platforms.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Marca</label>
                  <select value={form.brand_id} onChange={(e) => setForm({ ...form, brand_id: e.target.value, model_id: "" })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
                    <option value="">Selecione</option>
                    {brands.map((b) => <option key={b.id} value={b.id}>{b.name}</option>)}
                  </select>
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Modelo</label>
                  <select value={form.model_id} onChange={(e) => setForm({ ...form, model_id: e.target.value })} disabled={!form.brand_id} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 disabled:opacity-50">
                    <option value="">Selecione</option>
                    {models.map((m) => <option key={m.id} value={m.id}>{m.name}</option>)}
                  </select>
                </div>
              </div>

              <div className="pb-10">
                <label className="text-xs font-semibold text-foreground mb-1 block">Descrição</label>
                <div className="text-foreground bg-secondary rounded-lg overflow-hidden border border-transparent focus-within:ring-2 focus-within:ring-accent/30">
                  <ReactQuill theme="snow" value={form.description} onChange={(content: string, delta: any, source: string) => { if (source === 'user') setForm({ ...form, description: content }); }} className="min-h-[150px]" />
                </div>
              </div>
            </div>

            <button onClick={handleSave} disabled={isSaving} className="btn-accent w-full disabled:opacity-50 mt-6" aria-label="Salvar produto">
              {isSaving ? "Salvando..." : editingId ? "Salvar Alterações" : "Salvar Produto"}
            </button>
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default AdminProducts;
