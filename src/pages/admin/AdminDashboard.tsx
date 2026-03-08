import { motion } from "framer-motion";
import { MousePointerClick, TrendingUp, AlertTriangle, Package, ArrowUpRight, ArrowDownRight } from "lucide-react";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line } from "recharts";

const stats = [
  { label: "Cliques Totais", value: "41.430", change: "+12%", up: true, icon: MousePointerClick, color: "accent" },
  { label: "Conversões", value: "2.847", change: "+8%", up: true, icon: TrendingUp, color: "success" },
  { label: "Denúncias", value: "23", change: "-15%", up: false, icon: AlertTriangle, color: "destructive" },
  { label: "Produtos Ativos", value: "156", change: "+3", up: true, icon: Package, color: "info" },
];

const chartData = [
  { name: "Seg", cliques: 4000, conversoes: 240 },
  { name: "Ter", cliques: 3000, conversoes: 139 },
  { name: "Qua", cliques: 5000, conversoes: 380 },
  { name: "Qui", cliques: 2780, conversoes: 190 },
  { name: "Sex", cliques: 6890, conversoes: 480 },
  { name: "Sáb", cliques: 5390, conversoes: 380 },
  { name: "Dom", cliques: 3490, conversoes: 230 },
];

const AdminDashboard = () => (
  <div className="space-y-6">
    <h2 className="font-display font-bold text-xl text-foreground">Dashboard</h2>

    {/* Stats */}
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
            <span className={`flex items-center gap-0.5 text-xs font-semibold ${stat.up ? "text-success" : "text-destructive"}`}>
              {stat.up ? <ArrowUpRight className="w-3 h-3" /> : <ArrowDownRight className="w-3 h-3" />}
              {stat.change}
            </span>
          </div>
          <p className="font-display font-bold text-2xl text-foreground">{stat.value}</p>
          <p className="text-xs text-muted-foreground mt-1">{stat.label}</p>
        </motion.div>
      ))}
    </div>

    {/* Charts */}
    <div className="grid lg:grid-cols-2 gap-6">
      <div className="bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
        <h3 className="font-display font-semibold text-foreground mb-4">Cliques por Dia</h3>
        <ResponsiveContainer width="100%" height={250}>
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
            <XAxis dataKey="name" stroke="hsl(var(--muted-foreground))" fontSize={12} />
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
      <div className="bg-card rounded-xl border border-border p-5" style={{ boxShadow: "var(--shadow-card)" }}>
        <h3 className="font-display font-semibold text-foreground mb-4">Conversões</h3>
        <ResponsiveContainer width="100%" height={250}>
          <LineChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
            <XAxis dataKey="name" stroke="hsl(var(--muted-foreground))" fontSize={12} />
            <YAxis stroke="hsl(var(--muted-foreground))" fontSize={12} />
            <Tooltip
              contentStyle={{
                background: "hsl(var(--card))",
                border: "1px solid hsl(var(--border))",
                borderRadius: "0.75rem",
                fontSize: "12px",
              }}
            />
            <Line type="monotone" dataKey="conversoes" stroke="hsl(var(--success))" strokeWidth={2} dot={{ fill: "hsl(var(--success))", r: 4 }} />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  </div>
);

export default AdminDashboard;
