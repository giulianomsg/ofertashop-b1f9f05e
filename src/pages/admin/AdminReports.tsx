import { motion } from "framer-motion";
import { AlertTriangle, CheckCircle, Clock, ExternalLink } from "lucide-react";

const reports = [
  { id: 1, product: "Fone Bluetooth Premium NC-700", type: "Oferta Expirada", date: "2026-03-07", status: "pending", reporter: "usuario@email.com" },
  { id: 2, product: "Smartwatch Ultra Fit Pro", type: "Link Inválido", date: "2026-03-06", status: "pending", reporter: "ana@email.com" },
  { id: 3, product: "Caixa de Som Portátil SoundMax", type: "Preço Incorreto", date: "2026-03-05", status: "resolved", reporter: "carlos@email.com" },
  { id: 4, product: "Teclado Mecânico RGB Gamer Pro", type: "Oferta Expirada", date: "2026-03-04", status: "resolved", reporter: "maria@email.com" },
];

const AdminReports = () => (
  <div className="space-y-6">
    <h2 className="font-display font-bold text-xl text-foreground">Denúncias</h2>

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
            <p className="font-semibold text-sm text-foreground">{report.product}</p>
            <p className="text-xs text-muted-foreground">{report.type} · {report.date} · {report.reporter}</p>
          </div>
          {report.status === "pending" ? (
            <button className="btn-accent text-xs shrink-0">Resolver</button>
          ) : (
            <span className="badge-verified shrink-0">Resolvida</span>
          )}
        </motion.div>
      ))}
    </div>
  </div>
);

export default AdminReports;
