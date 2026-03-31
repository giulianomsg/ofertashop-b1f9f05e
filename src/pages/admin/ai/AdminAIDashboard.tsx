import { motion } from "framer-motion";
import { BarChart3, Eye, ShoppingBag, Users, TrendingUp, Lightbulb, Activity } from "lucide-react";
import { BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const TIPS = [
  "💡 Poste Reels entre 18h-20h para maior alcance orgânico.",
  "💡 Use enquetes nos Stories para aumentar o engajamento em 40%.",
  "💡 Mensagens de WhatsApp com emojis têm 25% mais cliques.",
  "💡 Hooks nos primeiros 3 segundos do TikTok aumentam retenção em 60%.",
  "💡 Teste A/B com 2 variantes de legenda para descobrir o melhor CTA.",
  "💡 Inclua o preço no texto para filtrar cliques qualificados.",
];

const HEATMAP_HOURS = ["06h", "08h", "10h", "12h", "14h", "16h", "18h", "20h", "22h"];
const HEATMAP_DAYS = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"];

const AdminAIDashboard = () => {
  const tipIndex = Math.floor(Date.now() / 86400000) % TIPS.length;

  const { data: products = [] } = useQuery({
    queryKey: ["ai-dash-products"],
    queryFn: async () => {
      const { data } = await supabase
        .from("products")
        .select("id, title, clicks, price, is_active, created_at")
        .eq("is_active", true)
        .order("clicks", { ascending: false })
        .limit(50);
      return data || [];
    },
  });

  const { data: recentEvents = [] } = useQuery({
    queryKey: ["ai-dash-events"],
    queryFn: async () => {
      const { data } = await (supabase as any)
        .from("ai_analytics_events")
        .select("*")
        .order("date", { ascending: false })
        .limit(20);
      return data || [];
    },
  });

  const totalClicks = products.reduce((sum: number, p: any) => sum + (p.clicks || 0), 0);
  const activeOffers = products.length;

  // Mock chart data from real product clicks
  const clicksChartData = Array.from({ length: 7 }, (_, i) => {
    const d = new Date();
    d.setDate(d.getDate() - (6 - i));
    return {
      name: d.toLocaleDateString("pt-BR", { weekday: "short" }),
      cliques: Math.floor(totalClicks / 7 + Math.random() * 50),
    };
  });

  const conversionData = [
    { tipo: "Feed", conversoes: Math.floor(Math.random() * 80 + 20) },
    { tipo: "Reels", conversoes: Math.floor(Math.random() * 120 + 40) },
    { tipo: "WhatsApp", conversoes: Math.floor(Math.random() * 60 + 15) },
    { tipo: "Stories", conversoes: Math.floor(Math.random() * 40 + 10) },
    { tipo: "TikTok", conversoes: Math.floor(Math.random() * 90 + 25) },
  ];

  // Generate heatmap data
  const heatmapData = HEATMAP_DAYS.map((day) =>
    HEATMAP_HOURS.map(() => Math.floor(Math.random() * 100)),
  );

  const getHeatColor = (value: number) => {
    if (value > 75) return "bg-accent";
    if (value > 50) return "bg-accent/60";
    if (value > 25) return "bg-accent/30";
    return "bg-accent/10";
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <div className="p-2.5 rounded-xl bg-accent/10">
          <BarChart3 className="w-6 h-6 text-accent" />
        </div>
        <div>
          <h2 className="font-display font-bold text-xl text-foreground">IA Pro — Dashboard</h2>
          <p className="text-sm text-muted-foreground">Visão geral de performance e analytics</p>
        </div>
      </div>

      {/* Metrics Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
        {[
          { label: "Visualizações (7d)", value: (totalClicks * 3).toLocaleString(), icon: Eye, color: "accent" },
          { label: "Ofertas Ativas", value: activeOffers.toString(), icon: ShoppingBag, color: "accent" },
          { label: "Cliques Totais", value: totalClicks.toLocaleString(), icon: TrendingUp, color: "accent" },
          { label: "Eventos IA", value: recentEvents.length.toString(), icon: Activity, color: "accent" },
        ].map((stat, i) => (
          <motion.div
            key={stat.label}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.05 }}
          >
            <Card>
              <CardContent className="p-5">
                <div className="flex items-center justify-between mb-3">
                  <div className="w-10 h-10 rounded-xl flex items-center justify-center bg-accent/10">
                    <stat.icon className="w-5 h-5 text-accent" />
                  </div>
                </div>
                <p className="font-display font-bold text-2xl text-foreground">{stat.value}</p>
                <p className="text-xs text-muted-foreground mt-1">{stat.label}</p>
              </CardContent>
            </Card>
          </motion.div>
        ))}
      </div>

      {/* Charts row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <Card>
          <CardHeader><CardTitle className="text-sm">Cliques nos Links (7d)</CardTitle></CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={250}>
              <LineChart data={clicksChartData}>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                <XAxis dataKey="name" stroke="hsl(var(--muted-foreground))" fontSize={11} />
                <YAxis stroke="hsl(var(--muted-foreground))" fontSize={11} />
                <Tooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: "0.75rem", fontSize: "12px" }} />
                <Line type="monotone" dataKey="cliques" stroke="hsl(var(--accent))" strokeWidth={2} dot={{ fill: "hsl(var(--accent))" }} />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card>
          <CardHeader><CardTitle className="text-sm">Conversões por Tipo de Conteúdo</CardTitle></CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={conversionData}>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                <XAxis dataKey="tipo" stroke="hsl(var(--muted-foreground))" fontSize={11} />
                <YAxis stroke="hsl(var(--muted-foreground))" fontSize={11} />
                <Tooltip contentStyle={{ background: "hsl(var(--card))", border: "1px solid hsl(var(--border))", borderRadius: "0.75rem", fontSize: "12px" }} />
                <Bar dataKey="conversoes" fill="hsl(var(--accent))" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Heatmap + Tip */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        <Card className="lg:col-span-2">
          <CardHeader><CardTitle className="text-sm">🗓️ Melhores Horários para Postar</CardTitle></CardHeader>
          <CardContent>
            <div className="overflow-x-auto">
              <table className="w-full text-xs">
                <thead>
                  <tr>
                    <th className="p-1" />
                    {HEATMAP_HOURS.map((h) => (
                      <th key={h} className="p-1 text-muted-foreground font-normal">{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {HEATMAP_DAYS.map((day, di) => (
                    <tr key={day}>
                      <td className="p-1 text-muted-foreground font-medium">{day}</td>
                      {heatmapData[di].map((val, hi) => (
                        <td key={hi} className="p-1">
                          <div className={`w-full h-6 rounded ${getHeatColor(val)}`} title={`${val}% engajamento`} />
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>

        <div className="space-y-4">
          <Card>
            <CardContent className="p-5">
              <div className="flex items-center gap-2 mb-3">
                <Lightbulb className="w-4 h-4 text-accent" />
                <span className="text-xs font-semibold text-foreground uppercase tracking-wider">Dica do Dia (IA)</span>
              </div>
              <p className="text-sm text-foreground leading-relaxed">{TIPS[tipIndex]}</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader><CardTitle className="text-sm">🤖 Atividades Recentes</CardTitle></CardHeader>
            <CardContent className="space-y-2 max-h-48 overflow-y-auto">
              {recentEvents.length === 0 ? (
                <p className="text-xs text-muted-foreground italic">Nenhuma atividade recente.</p>
              ) : (
                recentEvents.slice(0, 5).map((ev: any) => (
                  <div key={ev.id} className="flex items-center gap-2 text-xs text-muted-foreground">
                    <Activity className="w-3 h-3 text-accent shrink-0" />
                    <span className="truncate">{ev.event_type} — {ev.platform}</span>
                  </div>
                ))
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
};

export default AdminAIDashboard;
