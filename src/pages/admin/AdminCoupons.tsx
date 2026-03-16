import { useState } from "react";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X } from "lucide-react";
import { motion } from "framer-motion";
import { useCoupons, useCreateCoupon, useUpdateCoupon, useDeleteCoupon, usePlatforms } from "@/hooks/useEntities";
import { toast } from "sonner";

const AdminCoupons = () => {
  const { data: coupons = [], isLoading } = useCoupons();
  const { data: platforms = [] } = usePlatforms();
  const createCoupon = useCreateCoupon();
  const updateCoupon = useUpdateCoupon();
  const deleteCoupon = useDeleteCoupon();

  const [showModal, setShowModal] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState({ title: "", code: "", platform_id: "", discount_amount: "", active: true });

  const openCreate = () => {
    setEditingId(null);
    setForm({ title: "", code: "", platform_id: "", discount_amount: "", active: true });
    setShowModal(true);
  };

  const openEdit = (coupon: any) => {
    setEditingId(coupon.id);
    setForm({ 
      title: coupon.title, 
      code: coupon.code, 
      platform_id: coupon.platform_id, 
      discount_amount: coupon.discount_amount || "", 
      active: coupon.active 
    });
    setShowModal(true);
  };

  const handleSave = async () => {
    if (!form.title || !form.code || !form.platform_id) {
      toast.error("Preencha título, código e plataforma.");
      return;
    }
    try {
      if (editingId) {
        await updateCoupon.mutateAsync({ id: editingId, ...form });
        toast.success("Cupom atualizado.");
      } else {
        await createCoupon.mutateAsync(form);
        toast.success("Cupom criado.");
      }
      setShowModal(false);
    } catch {
      toast.error("Erro ao salvar cupom.");
    }
  };

  const handleToggle = async (id: string, currentActive: boolean) => {
    try {
      await updateCoupon.mutateAsync({ id, active: !currentActive });
    } catch {
      toast.error("Erro ao alterar status.");
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Excluir este cupom?")) return;
    try {
      await deleteCoupon.mutateAsync(id);
      toast.success("Cupom excluído.");
    } catch {
      toast.error("Erro ao excluir.");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="font-display font-bold text-xl text-foreground">Cupons</h2>
        <button onClick={openCreate} className="btn-accent flex items-center gap-2 text-sm" aria-label="Novo Cupom">
          <Plus className="w-4 h-4" /> Adicionar Cupom
        </button>
      </div>

      <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border bg-secondary">
              <th className="text-left p-4 font-semibold text-foreground">Plataforma</th>
              <th className="text-left p-4 font-semibold text-foreground">Título</th>
              <th className="text-left p-4 font-semibold text-foreground">Código</th>
              <th className="text-center p-4 font-semibold text-foreground">Ativo</th>
              <th className="text-right p-4 font-semibold text-foreground">Ações</th>
            </tr>
          </thead>
          <tbody>
            {isLoading ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Carregando...</td></tr> :
              coupons.length === 0 ? <tr><td colSpan={5} className="p-8 text-center text-muted-foreground">Nenhum cupom.</td></tr> :
                coupons.map((c: any) => (
                  <tr key={c.id} className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors">
                    <td className="p-4 text-muted-foreground">{c.platforms?.name}</td>
                    <td className="p-4 font-medium text-foreground">{c.title}</td>
                    <td className="p-4 font-mono text-xs text-muted-foreground"><span className="bg-secondary px-2 py-1 rounded">{c.code}</span></td>
                    <td className="p-4 text-center">
                      <button onClick={() => handleToggle(c.id, c.active)} aria-label="Alternar status">
                        {c.active ? <ToggleRight className="w-7 h-7 text-success" /> : <ToggleLeft className="w-7 h-7 text-muted-foreground" />}
                      </button>
                    </td>
                    <td className="p-4 text-right">
                      <div className="flex justify-end gap-1">
                        <button onClick={() => openEdit(c)} className="p-2 rounded-lg hover:bg-secondary" aria-label="Editar cupom"><Pencil className="w-4 h-4 text-muted-foreground" /></button>
                        <button onClick={() => handleDelete(c.id)} className="p-2 rounded-lg hover:bg-destructive/10" aria-label="Excluir cupom"><Trash2 className="w-4 h-4 text-destructive" /></button>
                      </div>
                    </td>
                  </tr>
                ))}
          </tbody>
        </table>
      </div>

      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-foreground/20 backdrop-blur-sm">
          <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} className="bg-card rounded-2xl border border-border p-6 w-full max-w-md space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="font-display font-bold text-lg text-foreground">{editingId ? "Editar Cupom" : "Novo Cupom"}</h3>
              <button onClick={() => setShowModal(false)} className="p-1 rounded-lg hover:bg-secondary" aria-label="Fechar"><X className="w-5 h-5" /></button>
            </div>
            <div className="space-y-4">
              <div>
                <label className="text-xs font-semibold block mb-1">Plataforma</label>
                <select value={form.platform_id} onChange={(e) => setForm({ ...form, platform_id: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none">
                  <option value="">Selecione...</option>
                  {platforms.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
                </select>
              </div>
              <div>
                <label className="text-xs font-semibold block mb-1">Título</label>
                <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} placeholder="Ex: 10% OFF no PIX" className="w-full h-10 px-3 rounded-lg bg-secondary border-none" />
              </div>
              <div>
                <label className="text-xs font-semibold block mb-1">Código</label>
                <input value={form.code} onChange={(e) => setForm({ ...form, code: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none uppercase font-mono text-sm" />
              </div>
              <div>
                <label className="text-xs font-semibold block mb-1">Valor do Desconto (Opcional)</label>
                <input value={form.discount_amount} onChange={(e) => setForm({ ...form, discount_amount: e.target.value })} placeholder="Ex: 10%" className="w-full h-10 px-3 rounded-lg bg-secondary border-none" />
              </div>
            </div>
            <button onClick={handleSave} className="btn-accent w-full mt-4" aria-label="Salvar">Salvar</button>
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default AdminCoupons;
