import { motion } from "framer-motion";
import { Shield, Eye, Pencil, Trash2, Plus } from "lucide-react";

const collaborators = [
  { id: 1, name: "João Silva", email: "joao@dealflow.com", role: "Admin", avatar: "JS" },
  { id: 2, name: "Maria Oliveira", email: "maria@dealflow.com", role: "Editor", avatar: "MO" },
  { id: 3, name: "Pedro Santos", email: "pedro@dealflow.com", role: "Visualizador", avatar: "PS" },
];

const roleColors: Record<string, string> = {
  Admin: "badge-hot",
  Editor: "badge-new",
  Visualizador: "badge-verified",
};

const AdminCollaborators = () => (
  <div className="space-y-6">
    <div className="flex items-center justify-between">
      <h2 className="font-display font-bold text-xl text-foreground">Colaboradores</h2>
      <button className="btn-accent flex items-center gap-2 text-sm">
        <Plus className="w-4 h-4" /> Convidar
      </button>
    </div>

    <div className="space-y-3">
      {collaborators.map((c, i) => (
        <motion.div
          key={c.id}
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: i * 0.05 }}
          className="bg-card rounded-xl border border-border p-5 flex items-center gap-4"
          style={{ boxShadow: "var(--shadow-card)" }}
        >
          <div className="w-10 h-10 rounded-full bg-accent/10 flex items-center justify-center font-display font-bold text-sm text-accent shrink-0">
            {c.avatar}
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-semibold text-sm text-foreground">{c.name}</p>
            <p className="text-xs text-muted-foreground">{c.email}</p>
          </div>
          <span className={roleColors[c.role]}>{c.role}</span>
          <div className="flex items-center gap-1">
            <button className="p-2 rounded-lg hover:bg-secondary transition-colors">
              <Pencil className="w-4 h-4 text-muted-foreground" />
            </button>
            <button className="p-2 rounded-lg hover:bg-destructive/10 transition-colors">
              <Trash2 className="w-4 h-4 text-destructive" />
            </button>
          </div>
        </motion.div>
      ))}
    </div>

    {/* Permissions info */}
    <div className="bg-secondary rounded-xl p-5 space-y-3">
      <h3 className="font-display font-semibold text-sm text-foreground flex items-center gap-2">
        <Shield className="w-4 h-4 text-accent" /> Níveis de Permissão
      </h3>
      <div className="space-y-2 text-sm text-muted-foreground">
        <p><span className="font-semibold text-foreground">Admin:</span> Acesso total ao painel, gerenciamento de usuários e configurações.</p>
        <p><span className="font-semibold text-foreground">Editor:</span> Gerenciar produtos, resolver denúncias, visualizar estatísticas.</p>
        <p><span className="font-semibold text-foreground">Visualizador:</span> Acesso somente leitura ao dashboard e estatísticas.</p>
      </div>
    </div>
  </div>
);

export default AdminCollaborators;
