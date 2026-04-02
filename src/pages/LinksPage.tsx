import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { motion } from "framer-motion";
import { ExternalLink, Loader2 } from "lucide-react";
import { Helmet } from "react-helmet-async";
import ProductCard from "@/components/ProductCard";

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

  // Fetch campaign settings
  const { data: campaignSettings } = useQuery({
    queryKey: ['publicLinktreeCampaign'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('admin_settings')
        .select('*')
        .in('key', ['links_page_campaign_name', 'links_page_products']);
      if (error) throw error;
      
      const titleObj = data.find(d => d.key === 'links_page_campaign_name');
      const productsObj = data.find(d => d.key === 'links_page_products');
      
      return {
          title: titleObj?.value ? String(titleObj.value).replace(/^"(.*)"$/, '$1') : "",
          productIds: productsObj?.value ? JSON.parse(productsObj.value as string) : []
      };
    }
  });

  // Fetch Campaign Products
  const { data: campaignProducts = [], isLoading: isLoadingProducts } = useQuery({
    queryKey: ['publicLinktreeProducts', campaignSettings?.productIds],
    queryFn: async () => {
      if (!campaignSettings || !campaignSettings.productIds || campaignSettings.productIds.length === 0) return [];
      
      const { data, error } = await supabase
        .from('products')
        .select('*')
        .in('id', campaignSettings.productIds)
        .eq('is_active', true);
      
      if (error) throw error;
      
      // Keep original order from settings array
      return data.sort((a, b) => campaignSettings.productIds.indexOf(a.id) - campaignSettings.productIds.indexOf(b.id));
    },
    enabled: !!campaignSettings && campaignSettings.productIds.length > 0
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
                className="w-48 h-48 mx-auto rounded-full bg-card/80 backdrop-blur border-2 border-accent/30 shadow-[0_0_30px_rgba(var(--accent),0.15)] flex items-center justify-center overflow-hidden p-2"
              >
                <img src={siteLogo} alt="OfertaShop Logo" className="w-full h-full object-contain" />
              </motion.div>
            ) : (
               <div className="w-48 h-48 mx-auto rounded-full bg-accent/10 flex items-center justify-center border-2 border-accent/20">
                 <span className="text-6xl font-display font-bold text-accent">OS</span>
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
                  
                  {link.icon_url && (
                    <div className="absolute left-4 w-10 h-10 rounded-xl overflow-hidden shadow-sm bg-background border border-border/20">
                        <img src={link.icon_url} alt="" className="w-full h-full object-cover" />
                    </div>
                  )}

                  <span className={`font-semibold text-[15px] z-10 flex-1 text-center font-display pr-6 ${link.icon_url ? "pl-16" : "pl-12"} line-clamp-1`}>
                    {link.title}
                  </span>
                  
                  <div className="absolute right-4 bg-foreground/5 group-hover:bg-background/20 rounded-full p-1.5 transition-colors">
                      <ExternalLink className="w-4 h-4" />
                  </div>
                </motion.a>
              ))
            )}
          </div>
          
          {/* Campaign Section */}
          {campaignSettings && campaignSettings.productIds?.length > 0 && (
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5, duration: 0.6 }}
              className="w-full mt-10 p-6 bg-card/60 backdrop-blur-xl rounded-3xl border border-border/50 shadow-xl"
            >
               {campaignSettings.title && (
                 <h2 className="text-xl font-display font-bold text-center mb-6 text-foreground">
                   {campaignSettings.title}
                 </h2>
               )}
               
               {isLoadingProducts ? (
                 <div className="flex justify-center py-8"><Loader2 className="w-6 h-6 animate-spin text-muted-foreground" /></div>
               ) : (
                 <div className="grid grid-cols-2 gap-3 sm:gap-4">
                   {campaignProducts.map((p, index) => (
                     <ProductCard key={p.id} product={p as any} index={index} />
                   ))}
                 </div>
               )}
            </motion.div>
          )}

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
