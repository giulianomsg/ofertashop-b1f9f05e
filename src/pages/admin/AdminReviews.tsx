import { motion } from "framer-motion";
import { MessageSquareOff, Trash2, Eye } from "lucide-react";
import { useAllReviews, useUpdateReviewStatus, useDeleteReview } from "@/hooks/useProducts";
import { toast } from "sonner";

const AdminReviews = () => {
    const { data: reviews = [], isLoading } = useAllReviews();
    const { mutate: updateStatus } = useUpdateReviewStatus();
    const { mutate: deleteReview } = useDeleteReview();

    const handleUpdateStatus = (id: string, status: string) => {
        updateStatus({ id, status }, {
            onSuccess: () => toast.success(`Avaliação marcada como ${status}`),
            onError: () => toast.error("Falha ao atualizar status"),
        });
    };

    const handleDelete = (id: string) => {
        if (confirm("Tem certeza que deseja apagar essa avaliação permanentemente?")) {
            deleteReview(id, {
                onSuccess: () => toast.success("Avaliação apagada."),
                onError: () => toast.error("Falha ao apagar avaliação."),
            });
        }
    };

    return (
        <div className="space-y-6">
            <div className="flex items-center justify-between">
                <h2 className="font-display font-bold text-xl text-foreground">Avaliações</h2>
            </div>

            {isLoading ? (
                <p className="text-muted-foreground text-sm">Carregando...</p>
            ) : reviews.length === 0 ? (
                <p className="text-muted-foreground text-sm text-center py-12">Nenhuma avaliação encontrada.</p>
            ) : (
                <div className="space-y-3">
                    {reviews.map((r, i) => (
                        <motion.div
                            key={r.id}
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: i * 0.05 }}
                            className={`bg-card rounded-xl border border-border p-5 flex flex-col sm:flex-row sm:items-center gap-4 ${r.status !== 'approved' ? 'opacity-60' : ''}`}
                            style={{ boxShadow: "var(--shadow-card)" }}
                        >
                            <div className="flex-1 min-w-0">
                                <div className="flex items-center gap-2 mb-1">
                                    <p className="font-semibold text-sm text-foreground">{r.user_name || "Anônimo"}</p>
                                    <span className="text-xs font-semibold text-accentbg-accent/10 px-2 py-0.5 rounded">
                                        ★ {r.rating}
                                    </span>
                                    {(r as any).products?.title && (
                                        <span className="text-xs text-muted-foreground line-clamp-1">
                                            em {(r as any).products.title}
                                        </span>
                                    )}
                                </div>
                                <p className="text-sm text-foreground/80 mt-1">{r.comment || <span className="italic text-muted-foreground">Sem comentário</span>}</p>
                                <p className="text-xs text-muted-foreground mt-2">{new Date(r.created_at).toLocaleString()}</p>
                            </div>

                            <div className="flex items-center gap-2 shrink-0">
                                <span className={`text-[10px] font-semibold px-2 py-1 rounded ${r.status === 'approved' ? 'bg-success/10 text-success' : 'bg-warning/10 text-warning'}`}>
                                    {r.status === 'approved' ? 'Visível' : 'Oculta'}
                                </span>

                                <button
                                    title={r.status === 'approved' ? 'Ocultar' : 'Exibir'}
                                    onClick={() => handleUpdateStatus(r.id, r.status === 'approved' ? 'hidden' : 'approved')}
                                    className="p-1.5 hover:bg-secondary rounded text-muted-foreground"
                                >
                                    {r.status === 'approved' ? <MessageSquareOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                                </button>
                                <button
                                    title="Excluir permanentemente"
                                    onClick={() => handleDelete(r.id)}
                                    className="p-1.5 hover:bg-destructive/10 rounded text-destructive"
                                >
                                    <Trash2 className="w-4 h-4" />
                                </button>
                            </div>
                        </motion.div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default AdminReviews;
