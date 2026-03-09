import { Search, User, Bell, ShoppingBag } from "lucide-react";
import { useState, useEffect } from "react";
import { Link, useNavigate, useSearchParams } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import { supabase } from "@/integrations/supabase/client";

const SiteHeader = () => {
  const [searchParams] = useSearchParams();
  const [searchQuery, setSearchQuery] = useState(searchParams.get("q") || "");
  const [suggestions, setSuggestions] = useState<{ id: string; title: string }[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const navigate = useNavigate();

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
            <button className="relative p-2.5 rounded-xl hover:bg-secondary transition-colors">
              <Bell className="w-5 h-5 text-muted-foreground" />
            </button>
            <Link to="/admin" className="p-2.5 rounded-xl hover:bg-secondary transition-colors">
              <User className="w-5 h-5 text-muted-foreground" />
            </Link>
          </div>
        </div>
      </div>
    </header>
  );
};

export default SiteHeader;
