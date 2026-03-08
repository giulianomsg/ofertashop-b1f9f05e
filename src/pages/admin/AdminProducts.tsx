import { useState } from "react";
import { motion } from "framer-motion";
import { Plus, Pencil, Trash2, ToggleLeft, ToggleRight, X } from "lucide-react";
import { products } from "@/data/products";

const AdminProducts = () => {
  const [showModal, setShowModal] = useState(false);
  const [activeProducts, setActiveProducts] = useState<Record<string, boolean>>(
    Object.fromEntries(products.map((p) => [p.id, true]))
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="font-display font-bold text-xl text-foreground">Produtos</h2>
        <button onClick={() => setShowModal(true)} className="btn-accent flex items-center gap-2 text-sm">
          <Plus className="w-4 h-4" /> Novo Produto
        </button>
      </div>

      {/* Table */}
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
              {products.map((product) => (
                <motion.tr
                  key={product.id}
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className="border-b border-border last:border-0 hover:bg-secondary/50 transition-colors"
                >
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <img src={product.image} alt="" className="w-10 h-10 rounded-lg object-cover" />
                      <span className="font-medium text-foreground line-clamp-1">{product.title}</span>
                    </div>
                  </td>
                  <td className="p-4 text-muted-foreground hidden md:table-cell">{product.store}</td>
                  <td className="p-4 font-semibold text-foreground">R$ {product.price.toFixed(2).replace(".", ",")}</td>
                  <td className="p-4 text-center text-muted-foreground hidden md:table-cell">{product.clicks.toLocaleString()}</td>
                  <td className="p-4 text-center">
                    <button
                      onClick={() => setActiveProducts((s) => ({ ...s, [product.id]: !s[product.id] }))}
                      className="inline-flex"
                    >
                      {activeProducts[product.id] ? (
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
                      <button className="p-2 rounded-lg hover:bg-destructive/10 transition-colors">
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

      {/* Modal */}
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
              {[
                { label: "Título", placeholder: "Nome do produto" },
                { label: "Link de Afiliado", placeholder: "https://..." },
                { label: "Preço (R$)", placeholder: "99,90" },
                { label: "Loja", placeholder: "Nome da loja" },
              ].map((field) => (
                <div key={field.label}>
                  <label className="text-xs font-semibold text-foreground mb-1 block">{field.label}</label>
                  <input className="w-full h-10 px-3 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30" placeholder={field.placeholder} />
                </div>
              ))}
              <div>
                <label className="text-xs font-semibold text-foreground mb-1 block">Imagem</label>
                <div className="border-2 border-dashed border-border rounded-lg p-8 text-center text-sm text-muted-foreground">
                  Arraste uma imagem ou clique para selecionar
                </div>
              </div>
            </div>
            <button className="btn-accent w-full">Salvar Produto</button>
          </motion.div>
        </div>
      )}
    </div>
  );
};

export default AdminProducts;
