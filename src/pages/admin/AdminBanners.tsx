import { useState, useRef } from "react";
import { motion } from "framer-motion";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X, Image, Upload, Loader2 } from "lucide-react";
import { useBanners, useCreateBanner, useUpdateBanner, useDeleteBanner } from "@/hooks/useBanners";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const emptyForm = {
    image_url: "",
    title: "",
    subtitle: "",
    cta_text: "",
    link_url: "",
    sort_order: "0",
};

const AdminBanners = () => {
    const { data: banners = [], isLoading } = useBanners(false);
    const createBanner = useCreateBanner();
    const updateBanner = useUpdateBanner();
    const deleteBanner = useDeleteBanner();

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

    const openEdit = (banner: (typeof banners)[0]) => {
        setEditingId(banner.id);
        setForm({
            image_url: banner.image_url,
            title: banner.title || "",
            subtitle: banner.subtitle || "",
            cta_text: banner.cta_text || "",
            link_url: banner.link_url || "",
            sort_order: String(banner.sort_order),
        });
        setShowModal(true);
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
                .from("banners")
                .upload(fileName, file, { contentType: file.type });

            if (uploadError) throw uploadError;

            const { data: urlData } = supabase.storage
                .from("banners")
                .getPublicUrl(fileName);

            setForm((f) => ({ ...f, image_url: urlData.publicUrl }));
            toast.success("Imagem do banner enviada!");
        } catch (err) {
            console.error(err);
            toast.error("Erro ao enviar imagem do banner.");
        } finally {
            setImportingImage(false);
            if (fileInputRef.current) fileInputRef.current.value = "";
        }
    };

    const handleSave = async () => {
        if (!form.image_url) {
            toast.error("A imagem do banner é obrigatória.");
            return;
        }

        const payload = {
            image_url: form.image_url,
            title: form.title || null,
            subtitle: form.subtitle || null,
            cta_text: form.cta_text || null,
            link_url: form.link_url || null,
            sort_order: parseInt(form.sort_order) || 0,
        };

        try {
            if (editingId) {
                await updateBanner.mutateAsync({ id: editingId, ...payload });
                toast.success("Banner atualizado!");
            } else {
                await createBanner.mutateAsync(payload);
                toast.success("Banner criado!");
            }
            setShowModal(false);
            setForm(emptyForm);
            setEditingId(null);
        } catch (err) {
            console.error("Save error:", err);
            toast.error("Erro ao salvar banner. Verifique suas permissões.");
        }
    };

    const handleToggle = async (id: string, currentActive: boolean) => {
        try {
            await updateBanner.mutateAsync({ id, is_active: !currentActive });
        } catch {
            toast.error("Erro ao atualizar status.");
        }
    };

    const handleDelete = async (id: string) => {
        if (!confirm("Tem certeza que deseja excluir este banner?")) return;
        try {
            await deleteBanner.mutateAsync(id);
            toast.success("Banner excluído.");
        } catch {
            toast.error("Erro ao excluir banner.");
        }
    };

    const isSaving = createBanner.isPending || updateBanner.isPending;

    return (
        <div className="space-y-6">
            <div className="flex items-center justify-between">
                <h2 className="font-display font-bold text-xl text-foreground">Banners Carrossel</h2>
                <button onClick={openCreate} className="btn-accent flex items-center gap-2 text-sm">
                    <Plus className="w-4 h-4" /> Novo Banner
                </button>
            </div>

            <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
                <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                        <thead>
                            <tr className="border-b border-border bg-secondary">
                                <th className="text-left p-4 font-semibold text-foreground">Imagem</th>
                                <th className="text-left p-4 font-semibold text-foreground">Título</th>
                                <th className="text-center p-4 font-semibold text-foreground">Ordem</th>
                                <th className="text-center p-4 font-semibold text-foreground">Status</th>
                                <th className="text-right p-4 font-semibold text-foreground">Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            {isLoading ? (
                                <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Carregando...</td></tr>
                            ) : banners.length === 0 ? (
                                <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Nenhum banner cadastrado.</td></tr>
                            ) : banners.map((banner) => (
                                <motion.tr
                                    key={banner.id}
                                    initial={{ opacity: 0 }}
                                    animate={{ opacity: 1 }}
                                    className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors"
                                >
                                    <td className="p-4">
                                        <img src={banner.image_url} alt="" className="w-24 h-10 rounded object-cover bg-secondary" />
                                    </td>
                                    <td className="p-4 font-medium text-foreground">{banner.title || "-"}</td>
                                    <td className="p-4 text-center text-muted-foreground">{banner.sort_order}</td>
                                    <td className="p-4 text-center">
                                        <button onClick={() => handleToggle(banner.id, banner.is_active)} className="inline-flex">
                                            {banner.is_active ? (
                                                <ToggleRight className="w-7 h-7 text-success" />
                                            ) : (
                                                <ToggleLeft className="w-7 h-7 text-muted-foreground" />
                                            )}
                                        </button>
                                    </td>
                                    <td className="p-4 text-right">
                                        <div className="flex items-center justify-end gap-1">
                                            <button onClick={() => openEdit(banner)} className="p-2 rounded-lg hover:bg-secondary transition-colors">
                                                <Pencil className="w-4 h-4 text-muted-foreground" />
                                            </button>
                                            <button onClick={() => handleDelete(banner.id)} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors">
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
                                {editingId ? "Editar Banner" : "Novo Banner"}
                            </h3>
                            <button onClick={() => setShowModal(false)} className="p-1.5 rounded-lg hover:bg-secondary"><X className="w-4 h-4" /></button>
                        </div>

                        <div className="space-y-3">
                            <div>
                                <label className="text-xs font-semibold text-foreground mb-1 block">Imagem do Banner *</label>
                                {form.image_url && (
                                    <div className="mb-2 rounded-lg overflow-hidden border border-border bg-secondary">
                                        <img src={form.image_url} alt="Preview" className="w-full h-32 object-cover aspect-[21/8]" />
                                    </div>
                                )}
                                <div className="flex gap-2">
                                    <input
                                        value={form.image_url}
                                        onChange={(e) => setForm({ ...form, image_url: e.target.value })}
                                        className="flex-1 h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                                        placeholder="URL direta da imagem"
                                    />
                                </div>
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
                                    {importingImage ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Upload className="w-3.5 h-3.5" />}
                                    Enviar foto (Recomendado 1920x730px)
                                </button>
                            </div>

                            <div>
                                <label className="text-xs font-semibold text-foreground mb-1 block">Título</label>
                                <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Título sobre o banner (opcional)" />
                            </div>

                            <div>
                                <label className="text-xs font-semibold text-foreground mb-1 block">Subtítulo</label>
                                <input value={form.subtitle} onChange={(e) => setForm({ ...form, subtitle: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Texto que vem abaixo do título (opcional)" />
                            </div>

                            <div className="grid grid-cols-2 gap-3">
                                <div>
                                    <label className="text-xs font-semibold text-foreground mb-1 block">Texto do Botão (CTA)</label>
                                    <input value={form.cta_text} onChange={(e) => setForm({ ...form, cta_text: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Ex: Ver Ofertas" />
                                </div>
                                <div>
                                    <label className="text-xs font-semibold text-foreground mb-1 block">Ordem (Sort)</label>
                                    <input type="number" value={form.sort_order} onChange={(e) => setForm({ ...form, sort_order: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" />
                                </div>
                            </div>

                            <div>
                                <label className="text-xs font-semibold text-foreground mb-1 block">Link de Destino do Botão</label>
                                <input value={form.link_url} onChange={(e) => setForm({ ...form, link_url: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="/produto/... ou https://..." />
                            </div>
                        </div>

                        <button onClick={handleSave} disabled={isSaving} className="btn-accent w-full disabled:opacity-50 mt-6">
                            {isSaving ? "Salvando..." : editingId ? "Salvar Alterações" : "Salvar Banner"}
                        </button>
                    </motion.div>
                </div>
            )}
        </div>
    );
};

export default AdminBanners;
