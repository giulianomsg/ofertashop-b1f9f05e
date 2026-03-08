import { motion } from "framer-motion";
import { Clock, CheckCircle } from "lucide-react";
import { useReports } from "@/hooks/useProducts";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { useQueryClient } from "@tanstack/react-query";
import { useAuth } from "@/hooks/useAuth";

const AdminReports = () => {
  const { data: reports = [], isLoading } = useReports();
  const { user } = useAuth();
  const qc = useQueryClient();

  const handleResolve = async (id: string) => {
    const { error } = await supabase
      .from("reports")
      .update({ status: "resolved", resolved_by: user?.id })
      .eq("id", id);
    if (error) toast.error("Erro ao resolver denúncia.");
    else {
      toast.success("Denúncia resolvida!");
      qc.invalidateQueries({ queryKey: ["reports"] });
    }
  };

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Denúncias</h2>

      {isLoading ? (
        <p className="text-muted-foreground text-sm">Carregando...</p>
      ) : reports.length === 0 ? (
        <p className="text-muted-foreground text-sm text-center py-12">Nenhuma denúncia registrada.</p>
      ) : (
        <div className="space-y-3">
          {reports.map((report, i) => (
            <motion.div
              key={report.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.05 }}
              className="bg-card rounded-xl border border-border p-5 flex flex-col sm:flex-row sm:items-center gap-4"
              style={{ boxShadow: "var(--shadow-card)" }}
            >
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${report.status === "pending" ? "bg-warning/10" : "bg-success/10"}`}>
                {report.status === "pending" ? (
                  <Clock className="w-5 h-5 text-warning" />
                ) : (
                  <CheckCircle className="w-5 h-5 text-success" />
                )}
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-semibold text-sm text-foreground">
                  {(report as any).products?.title || "Produto removido"}
                </p>
                <p className="text-xs text-muted-foreground">
                  {report.report_type} · {new Date(report.created_at).toLocaleDateString("pt-BR")} · {report.reporter_email}
                </p>
              </div>
              {report.status === "pending" ? (
                <button onClick={() => handleResolve(report.id)} className="btn-accent text-xs shrink-0">Resolver</button>
              ) : (
                <span className="badge-verified shrink-0">Resolvida</span>
              )}
            </motion.div>
          ))}
        </div>
      )}
    </div>
  );
};

export default AdminReports;
