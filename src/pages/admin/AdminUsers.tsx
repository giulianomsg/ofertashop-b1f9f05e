import { useState } from "react";
import { motion } from "framer-motion";
import { User, ShieldBan, ShieldCheck, Edit, Trash2, Plus } from "lucide-react";
import {
    useUsers,
    useUpdateUserStatus,
    useUpdateUserProfile,
    useDeleteUser,
    useCreateUser
} from "@/hooks/useProducts";
import { useAuth } from "@/hooks/useAuth";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogFooter,
} from "@/components/ui/dialog";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";

const AdminUsers = () => {
    const { user: currentUser } = useAuth();
    const { data: users = [], isLoading } = useUsers();

    const { mutate: updateStatus } = useUpdateUserStatus();
    const { mutate: updateUserProfile, isPending: isUpdating } = useUpdateUserProfile();
    const { mutate: deleteUser, isPending: isDeleting } = useDeleteUser();
    const { mutate: createUser, isPending: isCreating } = useCreateUser();

    // Dialog state
    const [isAddOpen, setIsAddOpen] = useState(false);
    const [isEditOpen, setIsEditOpen] = useState(false);
    const [selectedUser, setSelectedUser] = useState<any>(null);

    // Form state
    const [formData, setFormData] = useState({
        email: "",
        password: "",
        fullName: "",
        role: "viewer"
    });

    const resetForm = () => {
        setFormData({ email: "", password: "", fullName: "", role: "viewer" });
        setSelectedUser(null);
    };

    const handleCreateUser = (e: React.FormEvent) => {
        e.preventDefault();
        if (!formData.email || !formData.password || !formData.fullName) {
            toast.error("Preencha todos os campos obrigatórios.");
            return;
        }

        createUser(
            { ...formData },
            {
                onSuccess: () => {
                    toast.success("Usuário criado com sucesso!");
                    setIsAddOpen(false);
                    resetForm();
                },
                onError: (err: any) => {
                    toast.error(err.message || "Erro ao criar usuário.");
                }
            }
        );
    };

    const handleUpdateUser = (e: React.FormEvent) => {
        e.preventDefault();
        if (!selectedUser || !formData.fullName) {
            toast.error("Preencha o nome do usuário.");
            return;
        }

        // Prevent downgrading oneself
        if (selectedUser.user_id === currentUser?.id && formData.role !== 'admin' && selectedUser.role === 'admin') {
            toast.error("Você não pode remover seu próprio acesso de administrador.");
            return;
        }

        updateUserProfile(
            { userId: selectedUser.user_id, fullName: formData.fullName, email: formData.email, role: formData.role },
            {
                onSuccess: () => {
                    toast.success("Usuário atualizado com sucesso!");
                    setIsEditOpen(false);
                    resetForm();
                },
                onError: (err: any) => {
                    toast.error(err.message || "Erro ao atualizar usuário.");
                }
            }
        );
    };

    const handleDeleteUser = (userId: string) => {
        if (userId === currentUser?.id) {
            toast.error("Você não pode excluir sua própria conta.");
            return;
        }

        if (window.confirm("Tem certeza que deseja excluir permanentemente este usuário? Esta ação não pode ser desfeita.")) {
            deleteUser(userId, {
                onSuccess: () => {
                    toast.success("Usuário excluído com sucesso.");
                },
                onError: (err: any) => {
                    toast.error(err.message || "Erro ao excluir usuário.");
                }
            });
        }
    };

    const openEditDialog = (user: any) => {
        setSelectedUser(user);
        setFormData({
            email: user.email || "",
            password: "",
            fullName: user.full_name || "",
            role: user.role || "viewer"
        });
        setIsEditOpen(true);
    };

    return (
        <div className="space-y-6">
            <div className="flex items-center justify-between">
                <h2 className="font-display font-bold text-xl text-foreground">Usuários</h2>
                <Button onClick={() => { resetForm(); setIsAddOpen(true); }} className="gap-2">
                    <Plus className="w-4 h-4" />
                    Adicionar
                </Button>
            </div>

            {isLoading ? (
                <p className="text-muted-foreground text-sm">Carregando...</p>
            ) : users.length === 0 ? (
                <p className="text-muted-foreground text-sm text-center py-12">Nenhum usuário encontrado.</p>
            ) : (
                <div className="space-y-3">
                    {users.map((u: any, i: number) => {
                        const isMe = u.user_id === currentUser?.id;

                        return (
                            <motion.div
                                key={u.profile_id || u.id}
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
                                        <p className="font-semibold text-sm text-foreground">
                                            {u.full_name || "Sem nome"}
                                            {isMe && <span className="ml-2 text-xs text-muted-foreground font-normal">(Você)</span>}
                                        </p>
                                        {u.role === "admin" && (
                                            <span className="badge-hot text-[10px]">Admin</span>
                                        )}
                                        {u.role === "editor" && (
                                            <span className="badge-verified text-[10px] bg-blue-500/10 text-blue-500 border-blue-500/20">Editor</span>
                                        )}
                                    </div>
                                    <p className="text-xs text-muted-foreground">{u.user_id}</p>
                                </div>

                                <div className="flex items-center gap-2 shrink-0">
                                    <span className={`px-2 py-1 rounded text-[10px] font-semibold ${u.is_active ? 'bg-success/10 text-success' : 'bg-destructive/10 text-destructive'}`}>
                                        {u.is_active ? "Ativo" : "Suspenso"}
                                    </span>

                                    {!isMe && (
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

                                    <button
                                        title="Editar usuário"
                                        className="p-1.5 hover:bg-secondary rounded text-muted-foreground hover:text-foreground transition-colors"
                                        onClick={() => openEditDialog(u)}
                                    >
                                        <Edit className="w-4 h-4" />
                                    </button>

                                    <button
                                        title="Excluir usuário"
                                        disabled={isMe || isDeleting}
                                        className="p-1.5 hover:bg-destructive/10 rounded text-muted-foreground hover:text-destructive transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                                        onClick={() => handleDeleteUser(u.user_id)}
                                    >
                                        <Trash2 className="w-4 h-4" />
                                    </button>
                                </div>
                            </motion.div>
                        )
                    })}
                </div>
            )}

            {/* Modal Add User */}
            <Dialog open={isAddOpen} onOpenChange={setIsAddOpen}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>Adicionar Novo Usuário</DialogTitle>
                    </DialogHeader>
                    <form onSubmit={handleCreateUser} className="space-y-4 pt-4">
                        <div className="space-y-2">
                            <Label htmlFor="fullname">Nome Completo</Label>
                            <Input
                                id="fullname"
                                value={formData.fullName}
                                onChange={e => setFormData({ ...formData, fullName: e.target.value })}
                                required
                            />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="email">E-mail</Label>
                            <Input
                                id="email"
                                type="email"
                                value={formData.email}
                                onChange={e => setFormData({ ...formData, email: e.target.value })}
                                required
                            />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="password">Senha Temporária</Label>
                            <Input
                                id="password"
                                type="password"
                                value={formData.password}
                                onChange={e => setFormData({ ...formData, password: e.target.value })}
                                required
                            />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="role">Nível de Acesso</Label>
                            <Select value={formData.role} onValueChange={v => setFormData({ ...formData, role: v })}>
                                <SelectTrigger>
                                    <SelectValue placeholder="Selecione o acesso" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="admin">Administrador</SelectItem>
                                    <SelectItem value="editor">Editor</SelectItem>
                                    <SelectItem value="viewer">Visualizador</SelectItem>
                                </SelectContent>
                            </Select>
                        </div>
                        <DialogFooter className="mt-6">
                            <Button type="button" variant="outline" onClick={() => setIsAddOpen(false)}>Cancelar</Button>
                            <Button type="submit" disabled={isCreating}>
                                {isCreating ? "Criando..." : "Criar Usuário"}
                            </Button>
                        </DialogFooter>
                    </form>
                </DialogContent>
            </Dialog>

            {/* Modal Edit User */}
            <Dialog open={isEditOpen} onOpenChange={setIsEditOpen}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>Editar Usuário</DialogTitle>
                    </DialogHeader>
                    <form onSubmit={handleUpdateUser} className="space-y-4 pt-4">
                        <div className="space-y-2">
                            <Label htmlFor="edit-fullname">Nome Completo</Label>
                            <Input
                                id="edit-fullname"
                                value={formData.fullName}
                                onChange={e => setFormData({ ...formData, fullName: e.target.value })}
                                required
                            />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="edit-email">E-mail</Label>
                            <Input
                                id="edit-email"
                                type="email"
                                value={formData.email}
                                onChange={e => setFormData({ ...formData, email: e.target.value })}
                                required
                            />
                        </div>
                        <div className="space-y-2">
                            <Label htmlFor="edit-role">Nível de Acesso</Label>
                            <Select value={formData.role} onValueChange={v => setFormData({ ...formData, role: v })}>
                                <SelectTrigger>
                                    <SelectValue placeholder="Selecione o acesso" />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="admin">Administrador</SelectItem>
                                    <SelectItem value="editor">Editor</SelectItem>
                                    <SelectItem value="viewer">Visualizador</SelectItem>
                                </SelectContent>
                            </Select>
                            {selectedUser?.user_id === currentUser?.id && formData.role !== 'admin' && (
                                <p className="text-xs text-destructive mt-1">Atenção: Você perderá acesso de administrador.</p>
                            )}
                        </div>
                        <DialogFooter className="mt-6">
                            <Button type="button" variant="outline" onClick={() => setIsEditOpen(false)}>Cancelar</Button>
                            <Button type="submit" disabled={isUpdating}>
                                {isUpdating ? "Salvando..." : "Salvar Alterações"}
                            </Button>
                        </DialogFooter>
                    </form>
                </DialogContent>
            </Dialog>

        </div>
    );
};

export default AdminUsers;
