import { motion } from "framer-motion";
import { MousePointerClick, TrendingUp, AlertTriangle, Package, ArrowUpRight } from "lucide-react";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";
import { useProducts, useReports } from "@/hooks/useProducts";

const AdminDashboard = () => {
  const { data: products = [] } = useProducts(false);
  const { data: reports = [] } = useReports();

  const totalClicks = products.reduce((sum, p) => sum + p.clicks, 0);
  const activeProducts = products.filter((p) => p.is_active).length;
  const pendingReports = reports.filter((r) => r.status === "pending").length;

  const stats = [
    { label: "Cliques Totais", value: totalClicks.toLocaleString(), icon: MousePointerClick, color: "accent" },
    { label: "Produtos Ativos", value: activeProducts.toString(), icon: Package, color: "info" },
    { label: "Denúncias Pendentes", value: pendingReports.toString(), icon: AlertTriangle, color: "destructive" },
    { label: "Total Produtos", value: products.length.toString(), icon: TrendingUp, color: "success" },
  ];

  const chartData = products.slice(0, 7).map((p) => ({
    name: p.title.substring(0, 15) + "...",
    cliques: p.clicks,
  }));

  return (
    <div className="space-y-6">
      <h2 className="font-display font-bold text-xl text-foreground">Dashboard</h2>

      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
        {stats.map((stat, i) => (
          <motion.div
            key={stat.label}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.05 }}
            className="bg-card rounded-xl border border-border p-5"
            style={{ boxShadow: "var(--shadow-card)" }}
          >
            <div className="flex items-center justify-between mb-3">
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center bg-${stat.color}/10`}>
                <stat.icon className={`w-5 h-5 text-${stat.color}`} />
              </div>
              <ArrowUpRight className="w-4 h-4 text-muted-foreground" />
            </div>
            <p className="font-display font-bold text-2xl text-foreground">{stat.value}</p>
            <p className="text-xs text-muted-foreground mt-1">{stat.label}</p>
          </motion.div>
        ))}
      </div>

      <div className="bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
        <h3 className="font-display font-semibold text-foreground mb-4">Cliques por Produto</h3>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
            <XAxis dataKey="name" stroke="hsl(var(--muted-foreground))" fontSize={11} />
            <YAxis stroke="hsl(var(--muted-foreground))" fontSize={12} />
            <Tooltip
              contentStyle={{
                background: "hsl(var(--card))",
                border: "1px solid hsl(var(--border))",
                borderRadius: "0.75rem",
                fontSize: "12px",
              }}
            />
            <Bar dataKey="cliques" fill="hsl(var(--accent))" radius={[6, 6, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
};

export default AdminDashboard;
