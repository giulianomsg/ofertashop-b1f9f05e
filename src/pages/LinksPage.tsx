import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { motion } from "framer-motion";
import { ExternalLink } from "lucide-react";
import { Helmet } from "react-helmet-async";

const LinksPage = () => {
  // Fetch Logo
  const { data: siteLogo } = useQuery({
    queryKey: ['siteSettings', 'site_logo'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('admin_settings')
        .select('value')
        .eq('key', 'site_logo')
        .maybeSingle();
      if (error) throw error;
      return data?.value ? String(data.value).replace(/['"]/g, '') : '';
    }
  });

  // Fetch Links
  const { data: links = [], isLoading } = useQuery({
    queryKey: ['publicLinks'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('links')
        .select('*')
        .eq('is_active', true)
        .order('sort_order', { ascending: true });
      if (error) throw error;
      return data || [];
    }
  });

  return (
    <>
      <Helmet>
        <title>OfertaShop | Nossos Links</title>
        <meta name="description" content="Acesse todos os nossos canais, ofertas e redes sociais em um só lugar." />
      </Helmet>
      
      <div className="min-h-screen bg-background flex flex-col items-center py-16 px-4 sm:px-6 relative overflow-hidden">
        {/* Background styling for premium feel */}
        <div className="absolute inset-0 z-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-accent/20 via-background to-background pointer-events-none" />

        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="relative z-10 w-full max-w-[500px] flex flex-col items-center"
        >
          {/* Logo and Title */}
          <div className="text-center mb-10 space-y-4 w-full">
            {siteLogo ? (
              <motion.div
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ delay: 0.1, duration: 0.5 }}
                className="w-24 h-24 mx-auto rounded-full bg-card/80 backdrop-blur border-2 border-accent/30 shadow-[0_0_30px_rgba(var(--accent),0.15)] flex items-center justify-center overflow-hidden p-2"
              >
                <img src={siteLogo} alt="OfertaShop Logo" className="w-full h-full object-contain" />
              </motion.div>
            ) : (
               <div className="w-24 h-24 mx-auto rounded-full bg-accent/10 flex items-center justify-center border-2 border-accent/20">
                 <span className="text-3xl font-display font-bold text-accent">OS</span>
               </div>
            )}
            
            <motion.h1 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.2 }}
              className="text-2xl font-display font-bold text-foreground mt-4"
            >
              OfertaShop
            </motion.h1>
            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.3 }}
              className="text-muted-foreground text-[15px] font-medium max-w-[280px] mx-auto"
            >
              As melhores ofertas, cupons e achadinhos em um só lugar.
            </motion.p>
          </div>

          {/* Links */}
          <div className="w-full space-y-4">
            {isLoading ? (
              <div className="space-y-4">
                 {[1, 2, 3, 4].map((i) => (
                   <div key={i} className="h-[68px] bg-card/50 backdrop-blur rounded-2xl animate-pulse" />
                 ))}
              </div>
            ) : links.length === 0 ? (
              <div className="text-center p-8 bg-card/30 backdrop-blur rounded-2xl border border-border/50">
                <p className="text-muted-foreground">Nenhum link disponível no momento.</p>
              </div>
            ) : (
              links.map((link, index) => (
                <motion.a
                  key={link.id}
                  href={link.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  initial={{ opacity: 0, y: 15 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.1 * index + 0.3, duration: 0.4 }}
                  whileHover={{ scale: 1.02, y: -2 }}
                  whileTap={{ scale: 0.98 }}
                  className="group relative flex items-center justify-between p-5 bg-card hover:bg-accent border border-border/80 text-foreground hover:text-accent-foreground backdrop-blur-md rounded-2xl transition-all shadow-[0_4px_20px_rgba(0,0,0,0.03)] hover:shadow-[0_8px_25px_rgba(var(--accent),0.2)] overflow-hidden"
                >
                  {/* Subtle hover gradient overflow */}
                  <div className="absolute inset-0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-1000 bg-gradient-to-r from-transparent via-white/10 to-transparent pointer-events-none" />
                  
                  <span className="font-semibold text-[15px] z-10 flex-1 text-center font-display pr-6 pl-12 line-clamp-1">
                    {link.title}
                  </span>
                  
                  <div className="absolute right-5 bg-foreground/5 group-hover:bg-background/20 rounded-full p-1.5 transition-colors">
                      <ExternalLink className="w-4 h-4" />
                  </div>
                </motion.a>
              ))
            )}
          </div>
          
          <motion.div 
            initial={{ opacity: 0 }} 
            animate={{ opacity: 1 }} 
            transition={{ delay: 0.8 }}
            className="mt-12 text-center"
          >
             <p className="text-xs text-muted-foreground/60 font-medium tracking-wide">
                © {new Date().getFullYear()} OfertaShop
             </p>
          </motion.div>

        </motion.div>
      </div>
    </>
  );
};

export default LinksPage;
