import { motion } from "framer-motion";
import { Shield, Trash2, Edit2, ChevronDown } from "lucide-react";
import { useCollaborators, useUpdateCollaboratorRole, useRemoveCollaborator } from "@/hooks/useProducts";
import { toast } from "sonner";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const roleColors: Record<string, string> = {
  admin: "badge-hot",
  editor: "badge-new",
  viewer: "badge-verified",
};

const roleLabels: Record<string, string> = {
  admin: "Admin",
  editor: "Editor",
  viewer: "Visualizador",
};

const { data: collaborators = [], isLoading } = useCollaborators();
const { mutate: updateRole } = useUpdateCollaboratorRole();
const { mutate: removeRole } = useRemoveCollaborator();

const handleUpdateRole = (userId: string, newRole: string) => {
  updateRole({ userId, role: newRole }, {
    onSuccess: () => toast.success(`Cargo atualizado com sucesso.`),
    onError: () => toast.error(`Erro ao atualizar cargo.`),
  });
};

const handleRemove = (userId: string) => {
  if (confirm("Deseja remover este colaborador e torná-o visualizador?")) {
    removeRole(userId, {
      onSuccess: () => toast.success("Colaborador removido."),
      onError: () => toast.error("Falha ao remover colaborador."),
    });
  }
};

return (
  <div className="space-y-6">
    <div className="flex items-center justify-between">
      <h2 className="font-display font-bold text-xl text-foreground">Colaboradores</h2>
    </div>

    {isLoading ? (
      <p className="text-muted-foreground text-sm">Carregando...</p>
    ) : collaborators.length === 0 ? (
      <p className="text-muted-foreground text-sm text-center py-12">Nenhum colaborador cadastrado. Atribua roles aos usuários pelo banco de dados.</p>
    ) : (
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
              {((c as any).profiles?.full_name || "U")[0].toUpperCase()}
            </div>
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-sm text-foreground">{(c as any).profiles?.full_name || "Sem nome"}</p>
              <p className="text-xs text-muted-foreground">{(c as any).profiles?.user_id}</p>
            </div>
            <div className="flex items-center gap-2">
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <button className={`flex items-center gap-1 px-2 py-1 rounded text-xs font-semibold ${roleColors[c.role] || "badge-verified"}`}>
                    {roleLabels[c.role] || c.role}
                    <ChevronDown className="w-3 h-3 ml-1" />
                  </button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  <DropdownMenuItem onClick={() => handleUpdateRole(c.user_id, "admin")}>Admin</DropdownMenuItem>
                  <DropdownMenuItem onClick={() => handleUpdateRole(c.user_id, "editor")}>Editor</DropdownMenuItem>
                  <DropdownMenuItem onClick={() => handleUpdateRole(c.user_id, "viewer")}>Visualizador</DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>

              <button
                title="Remover Administrador"
                onClick={() => handleRemove(c.user_id)}
                className="p-1.5 hover:bg-destructive/10 rounded text-destructive"
              >
                <Trash2 className="w-4 h-4" />
              </button>
            </div>
          </motion.div>
        ))}
      </div>
    )}

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
};

export default AdminCollaborators;
