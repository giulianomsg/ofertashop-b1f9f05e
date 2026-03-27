import { useState, useRef, useEffect } from "react";
import { motion } from "framer-motion";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X, Image, Loader2, Upload, Video, Check, ChevronsUpDown, Sparkles, BarChart3 } from "lucide-react";
import SocialCopyGenerator from "@/components/SocialCopyGenerator";
import PriceComparator from "@/components/PriceComparator";
import { useProducts, useCreateProduct, useUpdateProduct, useDeleteProduct } from "@/hooks/useProducts";
import { useCategories, useBrands, useCreateBrand, useModels, useCreateModel, usePlatforms } from "@/hooks/useEntities";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
// @ts-ignore
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import { DndContext, closestCenter, KeyboardSensor, PointerSensor, useSensor, useSensors, DragEndEvent } from '@dnd-kit/core';
import { arrayMove, SortableContext, sortableKeyboardCoordinates, rectSortingStrategy, useSortable } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Command, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList } from "@/components/ui/command";
import { cn } from "@/lib/utils";

const SortableImage = ({ url, onRemove }: { url: string; onRemove: () => void }) => {
  const { attributes, listeners, setNodeRef, transform, transition } = useSortable({ id: url });
  const style = { transform: CSS.Transform.toString(transform), transition };

  return (
    <div ref={setNodeRef} style={style} className="relative group rounded-lg overflow-hidden border border-border aspect-square w-24">
      <div {...attributes} {...listeners} className="absolute inset-0 z-10 cursor-grab active:cursor-grabbing"></div>
      <img src={url} alt="Galeria" className="w-full h-full object-cover" />
      <button 
        type="button"
        onPointerDown={(e) => { e.stopPropagation(); onRemove(); }}
        className="absolute top-1 right-1 p-1 bg-destructive text-destructive-foreground rounded-full opacity-0 group-hover:opacity-100 transition-opacity z-20"
      >
        <X className="w-3 h-3" />
      </button>
    </div>
  );
};

const emptyForm = {
  title: "",
  affiliate_url: "",
  price: "",
  store: "",
  category_id: "",
  description: "",
  image_url: "",
  original_price: "",
  discount: "",
  commission_rate: "",
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
  const createBrand = useCreateBrand();
  const { data: platforms = [] } = usePlatforms();
  const { user } = useAuth();

  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [platformFilter, setPlatformFilter] = useState("all");
  const [currentPage, setCurrentPage] = useState(1);
  const ITEMS_PER_PAGE = 10;

  // Social Copy & Price Comparator modals
  const [socialCopyProduct, setSocialCopyProduct] = useState<any>(null);
  const [comparatorProduct, setComparatorProduct] = useState<any>(null);

  const [showModal, setShowModal] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState(emptyForm);
  const [importingImage, setImportingImage] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const galleryInputRef = useRef<HTMLInputElement>(null);

  const [brandOpen, setBrandOpen] = useState(false);
  const [brandSearch, setBrandSearch] = useState("");
  const [modelOpen, setModelOpen] = useState(false);
  const [modelSearch, setModelSearch] = useState("");

  const sensors = useSensors(
    useSensor(PointerSensor),
    useSensor(KeyboardSensor, { coordinateGetter: sortableKeyboardCoordinates })
  );

  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    if (active.id !== over?.id) {
      setForm((prev) => {
        const oldIndex = (prev.gallery_urls || []).indexOf(active.id as string);
        const newIndex = (prev.gallery_urls || []).indexOf(over?.id as string);
        return { ...prev, gallery_urls: arrayMove(prev.gallery_urls || [], oldIndex, newIndex) };
      });
    }
  };

  // Filter models by selected brand
  const { data: models = [] } = useModels(form.brand_id || undefined);
  const createModel = useCreateModel();

  const handleCreateBrand = async (name: string) => {
    try {
      const newBrand = await createBrand.mutateAsync(name);
      setForm({ ...form, brand_id: newBrand.id, model_id: "" });
      setBrandOpen(false);
      setBrandSearch("");
      toast.success(`Marca "${name}" criada!`);
    } catch {
      toast.error("Erro ao criar marca.");
    }
  };

  const handleCreateModel = async (name: string) => {
    if (!form.brand_id) return;
    try {
      const newModel = await createModel.mutateAsync({ brand_id: form.brand_id, name });
      setForm({ ...form, model_id: newModel.id });
      setModelOpen(false);
      setModelSearch("");
      toast.success(`Modelo "${name}" criado!`);
    } catch {
      toast.error("Erro ao criar modelo.");
    }
  };

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
    setForm({ ...emptyForm, category_id: categories.length > 0 ? categories[0].id : "" });
    setShowModal(true);
  };

  const openEdit = (product: (typeof products)[0]) => {
    setEditingId(product.id);
    setForm({
      title: product.title,
      affiliate_url: product.affiliate_url,
      price: String(product.price).replace(".", ","),
      store: product.store,
      category_id: (product as any).category_id || "",
      description: product.description || "",
      image_url: product.image_url || "",
      original_price: product.original_price ? String(product.original_price).replace(".", ",") : "",
      discount: product.discount ? String(product.discount) : "",
      commission_rate: (product as any).commission_rate ? String((product as any).commission_rate) : "",
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
    const files = e.target.files;
    if (!files || files.length === 0) return;

    const currentLength = form.gallery_urls?.length || 0;
    if (currentLength + files.length > 15) {
      toast.error("Máximo de 15 imagens na galeria total.");
      return;
    }

    setImportingImage(true);
    try {
      const uploadPromises = Array.from(files).map(async (file) => {
        const fileExt = file.name.split(".").pop();
        const fileName = `${Math.random()}.${fileExt}`;
        const filePath = `${fileName}`;
        const { error: uploadError } = await supabase.storage.from("product-images").upload(filePath, file);
        if (uploadError) throw uploadError;
        const { data } = supabase.storage.from("product-images").getPublicUrl(filePath);
        return data.publicUrl;
      });

      const urls = await Promise.all(uploadPromises);
      setForm((f) => ({ ...f, gallery_urls: [...(f.gallery_urls || []), ...urls] }));
      toast.success(`${urls.length} foto(s) adicional(is) enviada(s)!`);
    } catch (error: any) {
      toast.error("Erro no upload múltiplo.");
    } finally {
      setImportingImage(false);
      if (e.target) e.target.value = "";
    }
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
      category_id: form.category_id || (categories.length > 0 ? categories[0].id : null),
      description: form.description || null,
      image_url: form.image_url || null,
      original_price: form.original_price ? parseFloat(form.original_price.replace(",", ".")) : null,
      discount: form.discount ? parseInt(form.discount) : null,
      commission_rate: form.commission_rate ? parseFloat(form.commission_rate.replace(",", ".")) : null,
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
    try { 
      await deleteProduct.mutateAsync(id); 
      
      // Limpar cache de busca para que os produtos não apareçam mais como 'Importados'
      sessionStorage.removeItem("ml_results");
      sessionStorage.removeItem("ml_imported");
      sessionStorage.removeItem("shopee_results");
      sessionStorage.removeItem("shopee_imported");

      toast.success("Produto excluído."); 
    }
    catch { toast.error("Erro ao excluir."); }
  };

  const isSaving = createProduct.isPending || updateProduct.isPending;

  // Process filters and pagination
  const filteredProducts = products.filter((p) => {
    const term = searchTerm.toLowerCase();
    const matchesSearch = p.title.toLowerCase().includes(term) || p.store.toLowerCase().includes(term);
    const matchesStatus = statusFilter === "all" ? true : statusFilter === "active" ? p.is_active : !p.is_active;
    const matchesPlatform = platformFilter === "all" ? true : (p as any).platform_id === platformFilter;
    return matchesSearch && matchesStatus && matchesPlatform;
  });

  const totalPages = Math.ceil(filteredProducts.length / ITEMS_PER_PAGE);
  const paginatedProducts = filteredProducts.slice((currentPage - 1) * ITEMS_PER_PAGE, currentPage * ITEMS_PER_PAGE);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="font-display font-bold text-xl text-foreground">Produtos</h2>
        <button onClick={openCreate} className="btn-accent flex items-center gap-2 text-sm" aria-label="Novo produto">
          <Plus className="w-4 h-4" /> Novo Produto
        </button>
      </div>

      {/* Filtros e Busca */}
      <div className="flex flex-col sm:flex-row gap-4 bg-card p-4 rounded-xl border border-border" style={{ boxShadow: "var(--shadow-card)" }}>
        <div className="flex-1 relative">
          <input
            type="text"
            placeholder="Buscar por nome ou loja..."
            value={searchTerm}
            onChange={(e) => { setSearchTerm(e.target.value); setCurrentPage(1); }}
            className="w-full h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-colors"
          />
        </div>
        <div className="flex gap-4 sm:w-auto w-full">
          <select
            value={statusFilter}
            onChange={(e) => { setStatusFilter(e.target.value); setCurrentPage(1); }}
            className="h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 flex-1 sm:w-40"
          >
            <option value="all">Todos Status</option>
            <option value="active">Ativos</option>
            <option value="inactive">Inativos</option>
          </select>
          <select
            value={platformFilter}
            onChange={(e) => { setPlatformFilter(e.target.value); setCurrentPage(1); }}
            className="h-10 px-3 rounded-lg bg-secondary border border-border text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 flex-1 sm:w-48"
          >
            <option value="all">Todas Plataformas</option>
            <option value="">Nenhuma (Vazio)</option>
            {platforms.map(p => (
              <option key={p.id} value={p.id}>{p.name}</option>
            ))}
          </select>
        </div>
      </div>

      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border bg-secondary">
                <th className="text-left p-4 font-semibold text-foreground">Produto</th>
                <th className="text-left p-4 font-semibold text-foreground hidden md:table-cell">Loja</th>
                <th className="text-left p-4 font-semibold text-foreground hidden md:table-cell">Plataforma</th>
                <th className="text-left p-4 font-semibold text-foreground">Preço</th>
                <th className="text-center p-4 font-semibold text-foreground hidden md:table-cell">Comissão</th>
                <th className="text-center p-4 font-semibold text-foreground hidden md:table-cell">Cliques</th>
                <th className="text-center p-4 font-semibold text-foreground">Status</th>
                <th className="text-right p-4 font-semibold text-foreground">Ações</th>
              </tr>
            </thead>
            <tbody>
              {isLoading ? (
                <tr><td colSpan={8} className="p-8 text-center text-muted-foreground">Carregando...</td></tr>
              ) : paginatedProducts.length === 0 ? (
                <tr><td colSpan={8} className="p-8 text-center text-muted-foreground">Nenhum produto encontrado.</td></tr>
              ) : paginatedProducts.map((product) => (
                <motion.tr key={product.id} initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <img src={product.image_url || "/placeholder.svg"} alt={product.title} className="w-10 h-10 rounded-lg object-cover bg-secondary" />
                      <span className="font-medium text-foreground line-clamp-1">{product.title}</span>
                    </div>
                  </td>
                  <td className="p-4 text-muted-foreground hidden md:table-cell">{product.store}</td>
                  <td className="p-4 text-muted-foreground hidden md:table-cell">
                    {(product as any).platform_id ? platforms.find(p => p.id === (product as any).platform_id)?.name || "-" : "-"}
                  </td>
                  <td className="p-4 font-semibold text-foreground">R$ {Number(product.price).toFixed(2).replace(".", ",")}</td>
                  <td className="p-4 text-center hidden md:table-cell">
                    {(product as any).commission_rate ? (
                      <span className="inline-flex items-center px-2 py-1 rounded-md bg-accent/10 text-accent font-medium text-xs">
                        {Number((product as any).commission_rate).toFixed(1)}%
                      </span>
                    ) : (
                      <span className="text-muted-foreground">-</span>
                    )}
                  </td>
                  <td className="p-4 text-center text-muted-foreground hidden md:table-cell">{product.clicks.toLocaleString()}</td>
                  <td className="p-4 text-center">
                    <button onClick={() => handleToggle(product.id, product.is_active)} className="inline-flex" aria-label="Alternar status">
                      {product.is_active ? <ToggleRight className="w-7 h-7 text-success" /> : <ToggleLeft className="w-7 h-7 text-muted-foreground" />}
                    </button>
                  </td>
                  <td className="p-4 text-right">
                    <div className="flex items-center justify-end gap-1">
                      <button onClick={() => setSocialCopyProduct(product)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Gerar copy" title="Gerar Copy IA">
                        <Sparkles className="w-4 h-4 text-accent" />
                      </button>
                      <button onClick={() => setComparatorProduct(product)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Comparar preços" title="Comparar Preços">
                        <BarChart3 className="w-4 h-4 text-info" />
                      </button>
                      <button onClick={() => openEdit(product)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar produto"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                      <button onClick={() => handleDelete(product.id)} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir produto"><Trash2 className="w-4 h-4 text-destructive" /></button>
                    </div>
                  </td>
                </motion.tr>
              ))}
            </tbody>
          </table>
        </div>
        
        {/* Pagination Footer */}
        {totalPages > 0 && (
          <div className="p-4 border-t border-border flex items-center justify-between bg-card text-sm">
            <span className="text-muted-foreground">
              Mostrando {(currentPage - 1) * ITEMS_PER_PAGE + 1} a {Math.min(currentPage * ITEMS_PER_PAGE, filteredProducts.length)} de <span className="font-semibold text-foreground">{filteredProducts.length}</span> resultados
            </span>
            <div className="flex gap-2">
              <button
                onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                disabled={currentPage === 1}
                className="px-3 py-1.5 rounded-lg border border-border hover:bg-secondary disabled:opacity-50 text-foreground transition-colors font-medium"
              >
                Anterior
              </button>
              <button
                onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                disabled={currentPage === totalPages}
                className="px-3 py-1.5 rounded-lg border border-border hover:bg-secondary disabled:opacity-50 text-foreground transition-colors font-medium"
              >
                Próxima
              </button>
            </div>
          </div>
        )}
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
                <label className="text-xs font-semibold text-foreground mb-1 block">Galeria ({form.gallery_urls?.length || 0}/15)</label>
                <div className="flex flex-wrap gap-2 mb-2 items-center">
                  <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
                    <SortableContext items={form.gallery_urls || []} strategy={rectSortingStrategy}>
                      {form.gallery_urls?.map((url, i) => (
                        <SortableImage 
                          key={url} 
                          url={url} 
                          onRemove={() => setForm(f => ({ ...f, gallery_urls: f.gallery_urls?.filter((_, index) => index !== i) }))} 
                        />
                      ))}
                    </SortableContext>
                  </DndContext>
                  
                  {(form.gallery_urls?.length || 0) < 15 && (
                    <label className="w-24 h-24 rounded-lg border-2 border-dashed border-border flex flex-col items-center justify-center cursor-pointer hover:bg-secondary/50 transition-colors shrink-0">
                      <Upload className="w-6 h-6 text-muted-foreground mb-1" />
                      <span className="text-[10px] text-muted-foreground font-medium text-center px-1">Adicionar<br />várias fotos</span>
                      <input type="file" className="hidden" accept="image/*" multiple onChange={handleGalleryUpload} disabled={importingImage} />
                    </label>
                  )}
                </div>
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

              <div className="grid grid-cols-3 gap-3">
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Desconto (%) — auto</label>
                  <input value={form.discount} onChange={(e) => setForm({ ...form, discount: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Calculado auto" />
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Comissão (%)</label>
                  <input value={form.commission_rate} onChange={(e) => setForm({ ...form, commission_rate: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Ex: 11.5" />
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
                  <select value={form.category_id} onChange={(e) => setForm({ ...form, category_id: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
                    <option value="">Selecione</option>
                    {categories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
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
                  <Popover open={brandOpen} onOpenChange={setBrandOpen}>
                    <PopoverTrigger asChild>
                      <button
                        role="combobox"
                        aria-expanded={brandOpen}
                        className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 flex items-center justify-between truncate"
                      >
                        {form.brand_id ? brands.find((b) => b.id === form.brand_id)?.name : "Selecione a marca"}
                        <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                      </button>
                    </PopoverTrigger>
                    <PopoverContent className="w-[300px] sm:w-[350px] p-0 shadow-xl" align="start">
                      <Command>
                        <CommandInput placeholder="Buscar marca..." value={brandSearch} onValueChange={setBrandSearch} />
                        <CommandList>
                          <CommandEmpty className="py-2 text-center text-sm">
                            <p className="text-muted-foreground mb-2">Marca não encontrada.</p>
                            {brandSearch && (
                              <button onClick={() => handleCreateBrand(brandSearch)} className="text-accent hover:underline font-medium text-xs">
                                + Criar marca "{brandSearch}"
                              </button>
                            )}
                          </CommandEmpty>
                          <CommandGroup>
                            <CommandItem
                              key="none"
                              value=""
                              onSelect={() => {
                                setForm({ ...form, brand_id: "", model_id: "" });
                                setBrandOpen(false);
                              }}
                            >
                              <Check className={cn("mr-2 h-4 w-4", form.brand_id === "" ? "opacity-100" : "opacity-0")} />
                              Nenhuma
                            </CommandItem>
                            {brands.map((b) => (
                              <CommandItem
                                key={b.id}
                                value={b.name}
                                onSelect={() => {
                                  setForm({ ...form, brand_id: b.id, model_id: "" });
                                  setBrandOpen(false);
                                }}
                              >
                                <Check className={cn("mr-2 h-4 w-4", form.brand_id === b.id ? "opacity-100" : "opacity-0")} />
                                {b.name}
                              </CommandItem>
                            ))}
                          </CommandGroup>
                        </CommandList>
                      </Command>
                    </PopoverContent>
                  </Popover>
                </div>
                <div>
                  <label className="text-xs font-semibold text-foreground mb-1 block">Modelo</label>
                  <Popover open={modelOpen} onOpenChange={setModelOpen}>
                    <PopoverTrigger asChild>
                      <button
                        role="combobox"
                        aria-expanded={modelOpen}
                        disabled={!form.brand_id}
                        className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 flex items-center justify-between truncate disabled:opacity-50"
                      >
                        {form.model_id ? models.find((m) => m.id === form.model_id)?.name : "Selecione o modelo"}
                        <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                      </button>
                    </PopoverTrigger>
                    <PopoverContent className="w-[300px] sm:w-[350px] p-0 shadow-xl" align="start">
                      <Command>
                        <CommandInput placeholder="Buscar modelo..." value={modelSearch} onValueChange={setModelSearch} />
                        <CommandList>
                          {form.brand_id ? (
                            <CommandEmpty className="py-2 text-center text-sm">
                              <p className="text-muted-foreground mb-2">Modelo não encontrado.</p>
                              {modelSearch && (
                                <button onClick={() => handleCreateModel(modelSearch)} className="text-accent hover:underline font-medium text-xs">
                                  + Criar modelo "{modelSearch}"
                                </button>
                              )}
                            </CommandEmpty>
                          ) : (
                            <CommandEmpty className="py-6 text-center text-sm text-muted-foreground">Select a brand first.</CommandEmpty>
                          )}
                          <CommandGroup>
                            <CommandItem
                              key="none"
                              value=""
                              onSelect={() => {
                                setForm({ ...form, model_id: "" });
                                setModelOpen(false);
                              }}
                            >
                              <Check className={cn("mr-2 h-4 w-4", form.model_id === "" ? "opacity-100" : "opacity-0")} />
                              Nenhum
                            </CommandItem>
                            {models.map((m) => (
                              <CommandItem
                                key={m.id}
                                value={m.name}
                                onSelect={() => {
                                  setForm({ ...form, model_id: m.id });
                                  setModelOpen(false);
                                }}
                              >
                                <Check className={cn("mr-2 h-4 w-4", form.model_id === m.id ? "opacity-100" : "opacity-0")} />
                                {m.name}
                              </CommandItem>
                            ))}
                          </CommandGroup>
                        </CommandList>
                      </Command>
                    </PopoverContent>
                  </Popover>
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

      {/* Social Copy Generator Modal */}
      {socialCopyProduct && (
        <SocialCopyGenerator
          product={socialCopyProduct}
          open={!!socialCopyProduct}
          onClose={() => setSocialCopyProduct(null)}
        />
      )}

      {/* Price Comparator Modal */}
      {comparatorProduct && (
        <PriceComparator
          productId={comparatorProduct.id}
          productTitle={comparatorProduct.title}
          open={!!comparatorProduct}
          onClose={() => setComparatorProduct(null)}
        />
      )}
    </div>
  );
};

export default AdminProducts;
