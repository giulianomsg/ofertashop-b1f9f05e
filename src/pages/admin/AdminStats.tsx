import { BarChart3 } from "lucide-react";

const AdminStats = () => (
  <div className="space-y-6">
    <h2 className="font-display font-bold text-xl text-foreground">Estatísticas</h2>
    <div className="bg-card rounded-xl border border-border p-12 text-center" style={{ boxShadow: "var(--shadow-card)" }}>
      <BarChart3 className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
      <p className="text-muted-foreground">Estatísticas detalhadas em breve.</p>
    </div>
  </div>
);

export default AdminStats;
