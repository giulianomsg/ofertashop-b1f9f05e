import { useState } from "react";
import { Outlet, Link, useLocation, Navigate } from "react-router-dom";
import { LayoutDashboard, Package, Users, AlertTriangle, BarChart3, ChevronLeft, ChevronRight, ShoppingBag, LogOut, Image } from "lucide-react";
import { motion } from "framer-motion";
import { useAuth } from "@/hooks/useAuth";

const menuItems = [
  { icon: LayoutDashboard, label: "Dashboard", path: "/admin" },
  { icon: Image, label: "Banners", path: "/admin/banners" },
  { icon: Package, label: "Produtos", path: "/admin/produtos" },
  { icon: Users, label: "Colaboradores", path: "/admin/colaboradores" },
  { icon: AlertTriangle, label: "Denúncias", path: "/admin/denuncias" },
  { icon: BarChart3, label: "Estatísticas", path: "/admin/estatisticas" },
];

const AdminLayout = () => {
  const [collapsed, setCollapsed] = useState(false);
  const location = useLocation();
  const { user, loading, signOut, userRole } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="animate-pulse w-12 h-12 rounded-full bg-accent/20" />
      </div>
    );
  }

  if (!loading && userRole !== "admin") {
    return <Navigate to="/" replace />;
  }

  if (!user) {
    return <Navigate to="/admin/login" replace />;
  }

  return (
    <div className="min-h-screen flex bg-background">
      <motion.aside
        animate={{ width: collapsed ? 72 : 256 }}
        transition={{ duration: 0.2 }}
        className="bg-sidebar text-sidebar-foreground flex flex-col shrink-0 border-r border-sidebar-border"
      >
        <div className="p-4 flex items-center gap-3 border-b border-sidebar-border h-16">
          <div className="w-8 h-8 rounded-lg bg-sidebar-primary flex items-center justify-center shrink-0">
            <ShoppingBag className="w-4 h-4 text-sidebar-primary-foreground" />
          </div>
          {!collapsed && <span className="font-display font-bold text-lg text-sidebar-foreground">OfertaShop</span>}
        </div>

        <nav className="flex-1 p-3 space-y-1">
          {menuItems.map((item) => {
            const active = location.pathname === item.path;
            return (
              <Link
                key={item.path}
                to={item.path}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-all ${active
                  ? "bg-sidebar-accent text-sidebar-primary font-medium"
                  : "text-sidebar-foreground/60 hover:bg-sidebar-accent hover:text-sidebar-foreground"
                  }`}
              >
                <item.icon className="w-5 h-5 shrink-0" />
                {!collapsed && <span>{item.label}</span>}
              </Link>
            );
          })}
        </nav>

        <div className="p-3 border-t border-sidebar-border space-y-1">
          {!collapsed && (
            <div className="px-3 py-2 text-xs text-sidebar-foreground/40">
              {user.email}
              {userRole && <span className="ml-1 capitalize">({userRole})</span>}
            </div>
          )}
          <Link to="/" className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-sidebar-foreground/60 hover:bg-sidebar-accent hover:text-sidebar-foreground transition-all">
            <ShoppingBag className="w-5 h-5 shrink-0" />
            {!collapsed && <span>Voltar ao Site</span>}
          </Link>
          <button
            onClick={signOut}
            className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-sidebar-foreground/60 hover:bg-sidebar-accent hover:text-sidebar-foreground transition-all w-full"
          >
            <LogOut className="w-5 h-5 shrink-0" />
            {!collapsed && <span>Sair</span>}
          </button>
          <button
            onClick={() => setCollapsed(!collapsed)}
            className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-sidebar-foreground/60 hover:bg-sidebar-accent hover:text-sidebar-foreground transition-all w-full"
          >
            {collapsed ? <ChevronRight className="w-5 h-5 shrink-0" /> : <ChevronLeft className="w-5 h-5 shrink-0" />}
            {!collapsed && <span>Recolher</span>}
          </button>
        </div>
      </motion.aside>

      <div className="flex-1 overflow-auto">
        <header className="h-16 bg-card border-b border-border px-6 flex items-center">
          <h1 className="font-display font-semibold text-foreground">Administração</h1>
        </header>
        <div className="p-6">
          <Outlet />
        </div>
      </div>
    </div>
  );
};

export default AdminLayout;
