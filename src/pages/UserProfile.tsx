import { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { User as UserIcon, LogOut, Settings, Heart, Bell, Newspaper, ShoppingBag, Loader2 } from "lucide-react";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";
import ProductCard from "@/components/ProductCard";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { useProducts } from "@/hooks/useProducts";
import { useWishlist } from "@/hooks/useEntities";

const UserProfile = () => {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<"settings" | "wishlist">("settings");
  
  const [loadingProfile, setLoadingProfile] = useState(true);
  const [profile, setProfile] = useState<{ price_alert_opt_in: boolean; newsletter_opt_in: boolean; full_name: string | null }>({
    price_alert_opt_in: false,
    newsletter_opt_in: false,
    full_name: "",
  });

  const { data: wishlistIds = [], isLoading: loadingWishlist } = useWishlist(user?.id);
  const { data: allProducts = [] } = useProducts();
  const wishedProducts = allProducts.filter(p => wishlistIds.includes(p.id));

  useEffect(() => {
    if (!user) {
      navigate("/login");
      return;
    }

    const fetchProfile = async () => {
      const { data, error } = await supabase
        .from("profiles")
        .select("price_alert_opt_in, newsletter_opt_in, full_name")
        .eq("user_id", user.id)
        .single();

      if (!error && data) {
        setProfile({
          price_alert_opt_in: data.price_alert_opt_in ?? false,
          newsletter_opt_in: data.newsletter_opt_in ?? false,
          full_name: data.full_name,
        });
      }
      setLoadingProfile(false);
    };

    fetchProfile();
  }, [user, navigate]);

  const handleToggleOptIn = async (field: "price_alert_opt_in" | "newsletter_opt_in") => {
    if (!user) return;
    const newValue = !profile[field];
    
    // Optimistic update
    setProfile(prev => ({ ...prev, [field]: newValue }));

    const { error } = await supabase
      .from("profiles")
      .update({ [field]: newValue })
      .eq("user_id", user.id);

    if (error) {
      toast.error("Erro ao atualizar preferências.");
      setProfile(prev => ({ ...prev, [field]: !newValue })); // Revert on error
    } else {
      toast.success("Preferências atualizadas!");
    }
  };

  const handleLogout = async () => {
    await signOut();
    navigate("/");
  };

  if (loadingProfile) {
    return (
      <div className="min-h-screen border-t border-border bg-background">
        <SiteHeader />
        <div className="flex h-[60vh] items-center justify-center">
          <Loader2 className="h-8 w-8 animate-spin text-accent" />
        </div>
        <SiteFooter />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background flex flex-col">
      <SiteHeader />
      
      <main className="flex-1 container max-w-6xl mx-auto px-4 py-8 lg:py-12">
        <div className="flex flex-col md:flex-row gap-8">
          
          {/* Sidebar */}
          <motion.aside 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="w-full md:w-64 shrink-0 space-y-6"
          >
            <div className="bg-card rounded-2xl border border-border p-6 text-center shadow-sm">
              <div className="w-16 h-16 bg-accent/10 text-accent rounded-full flex items-center justify-center mx-auto mb-4">
                <UserIcon className="w-8 h-8" />
              </div>
              <h2 className="font-display font-bold text-lg text-foreground truncate">
                {profile.full_name || user?.email?.split('@')[0] || "Usuário"}
              </h2>
              <p className="text-sm text-muted-foreground truncate">{user?.email}</p>
            </div>

            <nav className="space-y-1">
              <button
                onClick={() => setActiveTab("settings")}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors ${activeTab === 'settings' ? 'bg-accent/10 text-accent' : 'text-muted-foreground hover:bg-secondary hover:text-foreground'}`}
              >
                <Settings className="w-4 h-4" /> Configurações da Conta
              </button>
              <button
                onClick={() => setActiveTab("wishlist")}
                className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors ${activeTab === 'wishlist' ? 'bg-accent/10 text-accent' : 'text-muted-foreground hover:bg-secondary hover:text-foreground'}`}
              >
                <Heart className="w-4 h-4" /> Meus Favoritos
              </button>
              <button
                onClick={handleLogout}
                className="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-destructive hover:bg-destructive/10 transition-colors mt-4"
              >
                <LogOut className="w-4 h-4" /> Sair
              </button>
            </nav>
          </motion.aside>

          {/* Main Content */}
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex-1 min-w-0"
          >
            {activeTab === "settings" && (
              <div className="space-y-6">
                <div>
                  <h1 className="font-display font-bold text-2xl text-foreground mb-2">Configurações da Conta</h1>
                  <p className="text-muted-foreground text-sm mb-6">Gira as preferências da sua conta e recebimentos de e-mails.</p>
                </div>

                <div className="bg-card border border-border rounded-2xl p-6 shadow-sm space-y-6">
                  <h3 className="font-semibold text-base border-b border-border pb-4">Preferências de Contato</h3>
                  
                  <div className="flex items-start justify-between gap-4 py-2">
                    <div className="space-y-1">
                      <div className="flex items-center gap-2">
                        <Bell className="w-4 h-4 text-accent" />
                        <span className="font-medium text-sm text-foreground">Avisos de Preço</span>
                      </div>
                      <p className="text-xs text-muted-foreground">Receba alertas quando os produtos que você favoritou entrarem em promoção profunda.</p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer shrink-0">
                      <input 
                        type="checkbox" 
                        className="sr-only peer" 
                        checked={profile.price_alert_opt_in}
                        onChange={() => handleToggleOptIn('price_alert_opt_in')} 
                      />
                      <div className="w-11 h-6 bg-secondary peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-accent border border-border"></div>
                    </label>
                  </div>

                  <div className="flex items-start justify-between gap-4 py-2">
                    <div className="space-y-1">
                      <div className="flex items-center gap-2">
                        <Newspaper className="w-4 h-4 text-accent" />
                        <span className="font-medium text-sm text-foreground">Assinatura da Newsletter</span>
                      </div>
                      <p className="text-xs text-muted-foreground">Fique por dentro das melhores ofertas da semana, reviews exclusivas e cupões.</p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer shrink-0">
                      <input 
                        type="checkbox" 
                        className="sr-only peer" 
                        checked={profile.newsletter_opt_in}
                        onChange={() => handleToggleOptIn('newsletter_opt_in')} 
                      />
                      <div className="w-11 h-6 bg-secondary peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-accent border border-border"></div>
                    </label>
                  </div>

                </div>
              </div>
            )}

            {activeTab === "wishlist" && (
              <div>
                <div className="mb-6">
                  <h1 className="font-display font-bold text-2xl text-foreground mb-2">Meus Favoritos</h1>
                  <p className="text-muted-foreground text-sm">Os produtos que você guardou para checar depois.</p>
                </div>
                
                {loadingWishlist ? (
                   <div className="flex py-10 items-center justify-center">
                     <Loader2 className="h-6 w-6 animate-spin text-accent" />
                   </div>
                ) : wishedProducts.length > 0 ? (
                  <div className="grid grid-cols-2 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
                    {wishedProducts.map((product, index) => (
                      <ProductCard key={product.id} product={product} index={index} />
                    ))}
                  </div>
                ) : (
                  <div className="bg-card border border-border border-dashed rounded-2xl py-16 flex flex-col items-center justify-center text-center px-4">
                    <div className="w-16 h-16 bg-secondary rounded-full flex items-center justify-center mb-4">
                      <Heart className="w-8 h-8 text-muted-foreground" />
                    </div>
                    <h3 className="font-display font-bold text-lg text-foreground mb-2">Nenhum favorito salvo</h3>
                    <p className="text-muted-foreground text-sm max-w-sm mb-6">Você ainda não adicionou nenhum produto à sua lista de desejos. Navegue pela loja e guarde as suas ofertas favoritas!</p>
                    <Link to="/" className="btn-accent flex items-center gap-2">
                      <ShoppingBag className="w-4 h-4" /> Buscar Ofertas
                    </Link>
                  </div>
                )}
              </div>
            )}
          </motion.div>
        </div>
      </main>

      <SiteFooter />
    </div>
  );
};

export default UserProfile;
