import { useState } from "react";
import { motion } from "framer-motion";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X } from "lucide-react";
import { useProducts, useCreateProduct, useUpdateProduct, useDeleteProduct } from "@/hooks/useProducts";
import { toast } from "sonner";

const AdminProducts = () => {
  const { data: products = [], isLoading } = useProducts(false);
  const createProduct = useCreateProduct();
  const updateProduct = useUpdateProduct();
  const deleteProduct = useDeleteProduct();
  const [showModal, setShowModal] = useState(false);
  const [form, setForm] = useState({ title: "", affiliate_url: "", price: "", store: "", category: "Eletrônicos", description: "" });

  const handleCreate = async () => {
    if (!form.title || !form.affiliate_url || !form.price || !form.store) {
      toast.error("Preencha todos os campos obrigatórios.");
      return;
    }
    try {
      await createProduct.mutateAsync({
        title: form.title,
        affiliate_url: form.affiliate_url,
        price: parseFloat(form.price.replace(",", ".")),
        store: form.store,
        category: form.category,
        description: form.description || null,
      });
      toast.success("Produto criado com sucesso!");
      setShowModal(false);
      setForm({ title: "", affiliate_url: "", price: "", store: "", category: "Eletrônicos", description: "" });
    } catch {
      toast.error("Erro ao criar produto. Verifique suas permissões.");
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

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="font-display font-bold text-xl text-foreground">Produtos</h2>
        <button onClick={() => setShowModal(true)} className="btn-accent flex items-center gap-2 text-sm">
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
              ) : products.map((product) => (
                <motion.tr
                  key={product.id}
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors"
                >
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <img src={product.image_url || "/placeholder.svg"} alt="" className="w-10 h-10 rounded-lg object-cover" />
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
                      <button className="p-2 rounded-lg hover:bg-secondary transition-colors">
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

      {showModal && (
        <div className="fixed inset-0 bg-foreground/20 backdrop-blur-sm z-50 flex items-center justify-center p-4" onClick={() => setShowModal(false)}>
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-card rounded-2xl border border-border p-6 w-full max-w-lg space-y-4"
            style={{ boxShadow: "var(--shadow-elevated)" }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between">
              <h3 className="font-display font-bold text-lg text-foreground">Novo Produto</h3>
              <button onClick={() => setShowModal(false)} className="p-1.5 rounded-lg hover:bg-secondary"><X className="w-4 h-4" /></button>
            </div>
            <div className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Título *</label>
                <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Nome do produto" />
              </div>
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Link de Afiliado *</label>
                <input value={form.affiliate_url} onChange={(e) => setForm({ ...form, affiliate_url: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="https://..." />
              </div>
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Preço (R$) *</label>
                <input value={form.price} onChange={(e) => setForm({ ...form, price: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="99,90" />
              </div>
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Loja *</label>
                <input value={form.store} onChange={(e) => setForm({ ...form, store: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder="Nome da loja" />
              </div>
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Categoria</label>
                <select value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-accent/30">
                  {["Eletrônicos", "Wearables", "Áudio", "Periféricos", "Acessórios", "Casa & Decoração", "Esportes"].map((c) => (
                    <option key={c} value={c}>{c}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Descrição</label>
                <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} className="w-full p-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 resize-none h-20" placeholder="Descrição do produto..." />
              </div>
            </div>
            <button onClick={handleCreate} disabled={createProduct.isPending} className="btn-accent w-full disabled:opacity-50">
              {createProduct.isPending ? "Salvando..." : "Salvar Produto"}
            </button>
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default AdminProducts;
