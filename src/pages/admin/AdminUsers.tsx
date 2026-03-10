import { motion } from "framer-motion";
import { User, ShieldBan, ShieldCheck } from "lucide-react";
import { useUsers, useUpdateUserStatus } from "@/hooks/useProducts";

const AdminUsers = () => {
    const { data: users = [], isLoading } = useUsers();
    const { mutate: updateStatus } = useUpdateUserStatus();

    return (
        <div className="space-y-6">
            <div className="flex items-center justify-between">
                <h2 className="font-display font-bold text-xl text-foreground">Usuários</h2>
            </div>

            {isLoading ? (
                <p className="text-muted-foreground text-sm">Carregando...</p>
            ) : users.length === 0 ? (
                <p className="text-muted-foreground text-sm text-center py-12">Nenhum usuário encontrado.</p>
            ) : (
                <div className="space-y-3">
                    {users.map((u, i) => (
                        <motion.div
                            key={u.id}
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: i * 0.05 }}
                            className="bg-card rounded-xl border border-border p-5 flex flex-col sm:flex-row sm:items-center gap-4"
                            style={{ boxShadow: "var(--shadow-card)" }}
                        >
                            <div className="w-10 h-10 rounded-full bg-accent/10 flex items-center justify-center font-display font-bold text-sm text-accent shrink-0">
                                {u.full_name ? u.full_name[0].toUpperCase() : "U"}
                            </div>

                            <div className="flex-1 min-w-0">
                                <div className="flex items-center gap-2">
                                    <p className="font-semibold text-sm text-foreground">{u.full_name || "Sem nome"}</p>
                                    {(u.user_roles as any)?.[0]?.role === "admin" && (
                                        <span className="badge-hot text-[10px]">Admin</span>
                                    )}
                                </div>
                                <p className="text-xs text-muted-foreground">{u.user_id}</p>
                            </div>

                            <div className="flex items-center gap-2 shrink-0">
                                <span className={`px-2 py-1 rounded text-[10px] font-semibold ${u.is_active ? 'bg-success/10 text-success' : 'bg-destructive/10 text-destructive'}`}>
                                    {u.is_active ? "Ativo" : "Suspenso"}
                                </span>

                                {(u.user_roles as any)?.[0]?.role !== "admin" && (
                                    <button
                                        title={u.is_active ? "Suspender acesso" : "Restaurar acesso"}
                                        className="p-1.5 hover:bg-secondary rounded"
                                        onClick={() => updateStatus({ userId: u.user_id, isActive: !u.is_active })}
                                    >
                                        {u.is_active ? (
                                            <ShieldBan className="w-4 h-4 text-destructive" />
                                        ) : (
                                            <ShieldCheck className="w-4 h-4 text-success" />
                                        )}
                                    </button>
                                )}
                            </div>
                        </motion.div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default AdminUsers;
