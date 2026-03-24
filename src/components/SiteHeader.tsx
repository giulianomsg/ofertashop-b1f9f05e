import { Search, User, Bell, ShoppingBag, LogOut, Settings, LayoutDashboard } from "lucide-react";
import { useState, useEffect } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useNotifications } from "@/hooks/useNotifications";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const SiteHeader = () => {
  const [searchParams] = useSearchParams();
  const [searchQuery, setSearchQuery] = useState(searchParams.get("q") || "");
  const [suggestions, setSuggestions] = useState<{ id: string; title: string }[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const navigate = useNavigate();
  const { user, userRole, signOut } = useAuth();
  const { notifications, unreadCount, markAllAsRead, markAsRead } = useNotifications();

  useEffect(() => {
    setSearchQuery(searchParams.get("q") || "");
  }, [searchParams]);

  useEffect(() => {
    if (searchQuery.length < 2) { setSuggestions([]); return; }
    const timeout = setTimeout(async () => {
      const { data } = await supabase
        .from("products")
        .select("id, title")
        .eq("is_active", true)
        .ilike("title", `%${searchQuery}%`)
        .limit(5);
      setSuggestions(data || []);
    }, 300);
    return () => clearTimeout(timeout);
  }, [searchQuery]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      setShowSuggestions(false);
      navigate(`/?q=${encodeURIComponent(searchQuery.trim())}`);
    } else {
      navigate(`/`);
    }
  };

  return (
    <header className="sticky top-0 z-50 bg-card/80 backdrop-blur-xl border-b border-border">
      <div className="container mx-auto px-4 lg:px-8">
        <div className="flex items-center justify-between h-16 gap-4">
          <Link to="/" className="flex items-center gap-2 shrink-0">
            <div className="w-8 h-8 rounded-lg bg-accent flex items-center justify-center">
              <ShoppingBag className="w-4 h-4 text-accent-foreground" />
            </div>
            <span className="font-display font-bold text-xl text-foreground hidden sm:block">
              Oferta<span className="gradient-text">Shop</span>
            </span>
          </Link>

          <div className="relative flex-1 max-w-xl">
            <form onSubmit={handleSearch} className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
              <input
                type="text"
                placeholder="Buscar ofertas..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                onFocus={() => setShowSuggestions(true)}
                onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
                className="w-full h-10 pl-10 pr-4 rounded-xl bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30 transition-all"
              />
            </form>
            <AnimatePresence>
              {showSuggestions && suggestions.length > 0 && (
                <motion.div
                  initial={{ opacity: 0, y: -4 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -4 }}
                  className="absolute top-full left-0 right-0 mt-1 bg-card rounded-xl border border-border shadow-lg overflow-hidden"
                  style={{ boxShadow: "var(--shadow-elevated)" }}
                >
                  {suggestions.map((s) => (
                    <button
                      key={s.id}
                      onClick={() => navigate(`/produto/${s.id}`)}
                      className="w-full px-4 py-2.5 text-left text-sm hover:bg-secondary transition-colors flex items-center gap-2 text-foreground"
                    >
                      <Search className="w-3.5 h-3.5 text-muted-foreground" />
                      {s.title}
                    </button>
                  ))}
                </motion.div>
              )}
            </AnimatePresence>
          </div>

          <div className="flex items-center gap-1">
            <Popover>
              <PopoverTrigger asChild>
                <button 
                  onClick={() => unreadCount > 0 && markAllAsRead()}
                  className="relative p-2.5 rounded-xl hover:bg-secondary transition-colors"
                >
                  <Bell className="w-5 h-5 text-muted-foreground" />
                  {unreadCount > 0 && (
                    <span className="absolute top-2.5 right-2.5 w-2 h-2 rounded-full bg-destructive outline outline-2 outline-card" />
                  )}
                </button>
              </PopoverTrigger>
              <PopoverContent align="end" className="w-80 p-0 shadow-xl border border-border">
                <div className="flex items-center justify-between px-4 py-3 border-b border-border bg-card">
                  <span className="font-semibold text-sm text-foreground">Notificações</span>
                  {unreadCount > 0 && (
                    <span className="text-xs font-medium text-destructive">{unreadCount} novas</span>
                  )}
                </div>
                <div className="max-h-[350px] overflow-y-auto bg-card">
                  {notifications.length === 0 ? (
                    <div className="p-6 text-center text-sm text-muted-foreground">
                      Nenhuma notificação no momento.
                    </div>
                  ) : (
                    notifications.map((notif) => (
                      <div 
                        key={notif.id} 
                        className={`p-4 border-b border-border last:border-0 hover:bg-secondary/70 transition-colors cursor-pointer ${!notif.read ? 'bg-accent/5' : ''}`}
                        onClick={() => {
                          markAsRead(notif.id);
                          if (notif.link) navigate(notif.link);
                        }}
                      >
                        <h4 className={`text-sm mb-1 ${!notif.read ? 'font-bold text-foreground' : 'font-semibold text-foreground/80'}`}>
                          {notif.title}
                        </h4>
                        <p className="text-xs text-muted-foreground/90 mb-2 leading-relaxed">
                          {notif.message}
                        </p>
                        <span className="text-[10px] text-muted-foreground font-medium">
                          {notif.date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })}
                        </span>
                      </div>
                    ))
                  )}
                </div>
              </PopoverContent>
            </Popover>
            {user ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <button className="p-2.5 rounded-xl hover:bg-secondary transition-colors outline-none">
                    <User className="w-5 h-5 text-muted-foreground" />
                  </button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="w-56">
                  <DropdownMenuLabel>
                    <div className="flex flex-col space-y-1">
                      <p className="text-sm font-medium leading-none">{user.user_metadata?.full_name || 'Usuário'}</p>
                      <p className="text-xs leading-none text-muted-foreground">{user.email}</p>
                    </div>
                  </DropdownMenuLabel>
                  <DropdownMenuSeparator />
                  {userRole === "admin" && (
                    <DropdownMenuItem asChild>
                      <Link to="/admin" className="cursor-pointer w-full flex items-center">
                        <LayoutDashboard className="mr-2 h-4 w-4" />
                        <span>Painel Admin</span>
                      </Link>
                    </DropdownMenuItem>
                  )}
                  <DropdownMenuItem asChild>
                    <Link to="/perfil" className="cursor-pointer w-full flex items-center">
                      <Settings className="mr-2 h-4 w-4" />
                      <span>Meu Perfil</span>
                    </Link>
                  </DropdownMenuItem>
                  <DropdownMenuItem onClick={async () => { await signOut(); navigate("/"); }} className="cursor-pointer text-red-600 focus:text-red-600 w-full flex items-center">
                    <LogOut className="mr-2 h-4 w-4" />
                    <span>Sair</span>
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <Link to="/login" className="p-2.5 rounded-xl hover:bg-secondary transition-colors">
                <User className="w-5 h-5 text-muted-foreground" />
              </Link>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};

export default SiteHeader;
