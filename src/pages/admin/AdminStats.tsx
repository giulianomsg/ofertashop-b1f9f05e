import { Users, Info, Flag, Package, CheckCircle, Clock, Shield } from "lucide-react";
import { useProducts, useReports, useAllReviews, useUsers, useAllTrustVotes } from "@/hooks/useProducts";
import { usePlatforms, useTrustVotesByPlatform } from "@/hooks/useEntities";
import { PieChart, Pie, Cell, Tooltip, Legend, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid } from "recharts";
import { useMemo } from "react";

const AdminStats = () => {
  const { data: products = [] } = useProducts(false);
  const { data: reports = [] } = useReports();
  const { data: reviews = [] } = useAllReviews();
  const { data: users = [] } = useUsers();
  const { data: platforms = [] } = usePlatforms();

  const totalProducts = products.length;
  const activeProducts = products.filter(p => p.is_active).length;

  const pendingReports = reports.filter(r => r.status === "pending").length;
  const resolvedReports = reports.filter(r => r.status !== "pending").length;

  const totalReviews = reviews.length;
  const totalUsers = users.length;
  const activeUsers = users.filter((u: any) => u.is_active).length;

  const { data: trustVotes = [] } = useAllTrustVotes();
  const { data: trustByPlatform } = useTrustVotesByPlatform();
  
  const simVotes = trustVotes.filter((v: any) => v.is_trusted !== false).length;
  const naoVotes = trustVotes.filter((v: any) => v.is_trusted === false).length;

  const trustData = [
    { name: 'Confiam (Sim)', value: simVotes },
    { name: 'Não Confiam (Não)', value: naoVotes },
  ];
  
  const COLORS = ['#22c55e', '#ef4444'];

  // Trust by platform chart data
  const platformTrustData = useMemo(() => {
    if (!trustByPlatform) return [];
    const { votes, clicks } = trustByPlatform;

    const platformMap: Record<string, { positive: number; total: number; clicks: number }> = {};

    votes.forEach((v: any) => {
      const pid = v.products?.platform_id;
      if (!pid) return;
      if (!platformMap[pid]) platformMap[pid] = { positive: 0, total: 0, clicks: 0 };
      platformMap[pid].total++;
      if (v.is_trusted) platformMap[pid].positive++;
    });

    clicks.forEach((c: any) => {
      const pid = c.products?.platform_id;
      if (!pid) return;
      if (!platformMap[pid]) platformMap[pid] = { positive: 0, total: 0, clicks: 0 };
      platformMap[pid].clicks++;
    });

    return Object.entries(platformMap).map(([pid, data]) => {
      const platform = platforms.find(p => p.id === pid);
      return {
        name: platform?.name || "Desconhecido",
        confiança: data.total > 0 ? Math.round((data.positive / data.total) * 100) : 0,
        votos: data.total,
        cliques: data.clicks,
      };
    }).sort((a, b) => b.confiança - a.confiança);
  }, [trustByPlatform, platforms]);

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

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-6">
        {/* Global trust pie */}
        <div className="bg-card rounded-xl border border-border p-6" style={{ boxShadow: "var(--shadow-card)" }}>
          <h3 className="font-display font-bold text-lg text-foreground mb-4 flex items-center gap-2">
            <Shield className="w-5 h-5 text-success" /> Confiança Global
          </h3>
          <div className="h-64">
            {trustVotes.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={trustData} cx="50%" cy="50%" innerRadius={60} outerRadius={80} paddingAngle={5} dataKey="value">
                    {trustData.map((_, index) => (
                      <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip wrapperClassName="!bg-card !border-border !rounded-lg" />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            ) : (
              <div className="w-full h-full flex items-center justify-center text-muted-foreground text-sm">Sem dados de confiança ainda.</div>
            )}
          </div>
        </div>

        {/* Trust by Platform bar chart */}
        <div className="bg-card rounded-xl border border-border p-6" style={{ boxShadow: "var(--shadow-card)" }}>
          <h3 className="font-display font-bold text-lg text-foreground mb-4 flex items-center gap-2">
            <Shield className="w-5 h-5 text-accent" /> Confiança por Plataforma
          </h3>
          <div className="h-64">
            {platformTrustData.length > 0 ? (
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={platformTrustData} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="hsl(var(--border))" />
                  <XAxis dataKey="name" stroke="hsl(var(--muted-foreground))" fontSize={11} tickLine={false} axisLine={false} />
                  <YAxis stroke="hsl(var(--muted-foreground))" fontSize={11} tickLine={false} axisLine={false} tickFormatter={(v) => `${v}%`} domain={[0, 100]} />
                  <Tooltip
                    content={({ active, payload, label }: any) => {
                      if (active && payload && payload.length) {
                        return (
                          <div className="bg-card border border-border p-3 rounded-lg shadow-xl text-sm">
                            <p className="font-semibold text-foreground mb-1">{label}</p>
                            <p className="text-success">Confiança: {payload[0].value}%</p>
                            <p className="text-muted-foreground text-xs">{payload[0].payload.votos} votos · {payload[0].payload.cliques} cliques</p>
                          </div>
                        );
                      }
                      return null;
                    }}
                  />
                  <Bar dataKey="confiança" fill="hsl(var(--accent))" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <div className="w-full h-full flex items-center justify-center text-muted-foreground text-sm">Sem dados por plataforma ainda.</div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminStats;
