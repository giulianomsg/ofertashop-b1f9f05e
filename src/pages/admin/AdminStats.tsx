import { Users, Info, Flag, Package, CheckCircle, Clock } from "lucide-react";
import { useProducts, useReports, useAllReviews, useUsers } from "@/hooks/useProducts";

const AdminStats = () => {
  const { data: products = [] } = useProducts(false); // Retorna todos os produtos inclusive não ativos
  const { data: reports = [] } = useReports();
  const { data: reviews = [] } = useAllReviews();
  const { data: users = [] } = useUsers();

  const totalProducts = products.length;
  const activeProducts = products.filter(p => p.is_active).length;

  const pendingReports = reports.filter(r => r.status === "pending").length;
  const resolvedReports = reports.filter(r => r.status !== "pending").length;

  const totalReviews = reviews.length;
  const totalUsers = users.length;
  const activeUsers = users.filter((u: any) => u.is_active).length;

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Estatísticas Gerais</h2>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-card rounded-xl border border-border p-5 relative overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
          <Package className="w-8 h-8 text-primary/20 absolute -bottom-2 -right-2" />
          <p className="text-sm font-medium text-muted-foreground flex items-center gap-2">
            <Package className="w-4 h-4 text-primary" /> Produtos
          </p>
          <p className="text-2xl font-bold text-foreground mt-2">{totalProducts}</p>
          <p className="text-xs text-muted-foreground mt-1">({activeProducts} ativos)</p>
        </div>

        <div className="bg-card rounded-xl border border-border p-5 relative overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
          <Users className="w-8 h-8 text-secondary-foreground/10 absolute -bottom-2 -right-2" />
          <p className="text-sm font-medium text-muted-foreground flex items-center gap-2">
            <Users className="w-4 h-4 text-secondary-foreground" /> Usuários
          </p>
          <p className="text-2xl font-bold text-foreground mt-2">{totalUsers}</p>
          <p className="text-xs text-muted-foreground mt-1">({activeUsers} com acesso permitido)</p>
        </div>

        <div className="bg-card rounded-xl border border-border p-5 relative overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
          <Info className="w-8 h-8 text-accent/20 absolute -bottom-2 -right-2" />
          <p className="text-sm font-medium text-muted-foreground flex items-center gap-2">
            <Info className="w-4 h-4 text-accent" /> Avaliações
          </p>
          <p className="text-2xl font-bold text-foreground mt-2">{totalReviews}</p>
          <p className="text-xs text-muted-foreground mt-1">No total registradas</p>
        </div>

        <div className="bg-card rounded-xl border border-border p-5 relative overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
          <Flag className="w-8 h-8 text-destructive/20 absolute -bottom-2 -right-2" />
          <p className="text-sm font-medium text-muted-foreground flex items-center gap-2">
            <Flag className="w-4 h-4 text-destructive" /> Denúncias
          </p>
          <div className="flex items-center gap-2 mt-2">
            <div className="flex-1 bg-warning/10 rounded px-2 py-1 text-center">
              <span className="text-lg font-bold text-warning">{pendingReports}</span>
              <p className="text-[10px] text-warning/80 flex items-center justify-center gap-1"><Clock className="w-3 h-3" />Pendentes</p>
            </div>
            <div className="flex-1 bg-success/10 rounded px-2 py-1 text-center">
              <span className="text-lg font-bold text-success">{resolvedReports}</span>
              <p className="text-[10px] text-success/80 flex items-center justify-center gap-1"><CheckCircle className="w-3 h-3" />Resolvidas</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminStats;
