import { useState } from "react";
import { Outlet, Link, useLocation, Navigate } from "react-router-dom";
import { LayoutDashboard, Package, Users, AlertTriangle, BarChart3, ChevronLeft, ChevronRight, ShoppingBag, LogOut, Image, MessageSquare, Tag, Layers, Monitor, FolderOpen, FileText, MessageCircle, Menu, Mail, ShoppingCart, Box, Sparkles, Code } from "lucide-react";
import { motion } from "framer-motion";
import { useAuth } from "@/hooks/useAuth";
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet";

const menuItems = [
  { icon: LayoutDashboard, label: "Dashboard", path: "/admin" },
  { icon: Image, label: "Banners", path: "/admin/banners" },
  { icon: Package, label: "Produtos", path: "/admin/produtos" },
  { icon: Tag, label: "Marcas", path: "/admin/marcas" },
  { icon: Layers, label: "Modelos", path: "/admin/modelos" },
  { icon: FolderOpen, label: "Categorias", path: "/admin/categorias" },
  { icon: Monitor, label: "Plataformas", path: "/admin/plataformas" },
  { icon: FileText, label: "Páginas Especiais", path: "/admin/paginas-especiais" },
  { icon: FileText, label: "Páginas Institucionais", path: "/admin/paginas-institucionais" },
  { icon: Tag, label: "Cupons", path: "/admin/cupons" },
  { icon: ShoppingCart, label: "Shopee Affiliate", path: "/admin/shopee" },
  { icon: ShoppingCart, label: "Mercado Livre", path: "/admin/mercadolivre" },
  { icon: Box, label: "Amazon Brasil", path: "/admin/amazon" },
  { icon: ShoppingCart, label: "Natura & Avon", path: "/admin/natura" },
  { icon: MessageCircle, label: "WhatsApp", path: "/admin/whatsapp" },
  { icon: Mail, label: "Newsletters", path: "/admin/newsletters" },
  { icon: Users, label: "Usuários", path: "/admin/usuarios" },
  { icon: MessageSquare, label: "Avaliações", path: "/admin/avaliacoes" },
  { icon: AlertTriangle, label: "Denúncias", path: "/admin/denuncias" },
  { icon: BarChart3, label: "Estatísticas", path: "/admin/estatisticas" },
  { icon: Sparkles, label: "IA / Conteúdo", path: "/admin/ia" },
  { icon: Sparkles, label: "IA Pro", path: "/admin/ai/dashboard" },
  { icon: Code, label: "API & Integrações", path: "/admin/api" },
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
      {/* Desktop Sidebar */}
      <motion.aside
        animate={{ width: collapsed ? 72 : 256 }}
        transition={{ duration: 0.2 }}
        className="hidden md:flex bg-sidebar text-sidebar-foreground flex-col shrink-0 border-r border-sidebar-border"
      >
        <div className="p-4 flex items-center gap-3 border-b border-sidebar-border h-16">
          <div className="w-8 h-8 rounded-lg bg-sidebar-primary flex items-center justify-center shrink-0">
            <ShoppingBag className="w-4 h-4 text-sidebar-primary-foreground" />
          </div>
          {!collapsed && <span className="font-display font-bold text-lg text-sidebar-foreground">OfertaShop</span>}
        </div>

        <nav className="flex-1 p-3 space-y-1 overflow-y-auto">
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
        <header className="h-16 bg-card border-b border-border px-6 flex items-center gap-4">
          {/* Mobile Menu Trigger */}
          <div className="md:hidden">
            <Sheet>
              <SheetTrigger asChild>
                <button className="p-2 -ml-2 text-foreground/60 hover:text-foreground">
                  <Menu className="w-5 h-5" />
                </button>
              </SheetTrigger>
              <SheetContent side="left" className="p-0 w-72 bg-sidebar border-r-sidebar-border text-sidebar-foreground">
                <div className="p-4 flex items-center gap-3 border-b border-sidebar-border h-16">
                  <div className="w-8 h-8 rounded-lg bg-sidebar-primary flex items-center justify-center shrink-0">
                    <ShoppingBag className="w-4 h-4 text-sidebar-primary-foreground" />
                  </div>
                  <span className="font-display font-bold text-lg text-sidebar-foreground">OfertaShop</span>
                </div>
                <nav className="flex-1 p-3 space-y-1 overflow-y-auto max-h-[calc(100vh-140px)]">
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
                        <span>{item.label}</span>
                      </Link>
                    );
                  })}
                </nav>
                <div className="p-3 border-t border-sidebar-border space-y-1 mt-auto">
                  <Link to="/" className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-sidebar-foreground/60 hover:bg-sidebar-accent hover:text-sidebar-foreground transition-all">
                    <ShoppingBag className="w-5 h-5 shrink-0" />
                    <span>Voltar ao Site</span>
                  </Link>
                  <button onClick={signOut} className="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm text-sidebar-foreground/60 hover:bg-sidebar-accent hover:text-sidebar-foreground transition-all w-full text-left">
                    <LogOut className="w-5 h-5 shrink-0" />
                    <span>Sair</span>
                  </button>
                </div>
              </SheetContent>
            </Sheet>
          </div>
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
