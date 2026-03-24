import { useState, useEffect } from "react";
import { Search, Download, RefreshCw, Loader2, ExternalLink, Check, Package, Settings, X, ShoppingCart } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";

interface AmazonItem {
  id: string; title: string; price: number; original_price: number | null;
  thumbnail: string; permalink: string;
  seller: { nickname: string };
  already_imported?: boolean;
  rating?: number; reviewCount?: number; badge?: string;
}

const AdminAmazon = () => {
  const { user } = useAuth();
  const qc = useQueryClient();

  // Estados Limpos
  const [keyword, setKeyword] = useState("");
  const [currentSearchType, setCurrentSearchType] = useState<"default"|"ofertas"|"maisVendidos">("default");
  const [currentCategoryId, setCurrentCategoryId] = useState("");
  const [results, setResults] = useState<AmazonItem[]>([]);
  const [currentOffset, setCurrentOffset] = useState(0);

  const [searching, setSearching] = useState(false);
  const [importing, setImporting] = useState<Set<string>>(new Set());
  const [imported, setImported] = useState<Set<string>>(new Set());
  const [syncing, setSyncing] = useState(false);

  // Scraper Settings State
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [activeProvider, setActiveProvider] = useState("scrapingbee");
  const [scraperKeys, setScraperKeys] = useState<Record<string, string>>({
     "scrapingbee": "", "scrape.do": "", "scrapingant": "", "scraperapi": ""
  });
  const [savingScraper, setSavingScraper] = useState(false);

  useEffect(() => {
    (supabase as any).from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle()
      .then(({ data }: any) => {
        if (data?.value) {
          setActiveProvider(data.value.activeProvider || "scrapingbee");
          if (data.value.keys) setScraperKeys(data.value.keys);
        } else {
           (supabase as any).from("admin_settings").select("value").eq("key", "active_scraper").maybeSingle()
            .then(({ data: legacy }: any) => {
               if (legacy?.value) {
                  setActiveProvider(legacy.value.provider || "scrapingbee");
                  if (legacy.value.provider && legacy.value.apiKey) {
                     setScraperKeys(prev => ({ ...prev, [legacy.value.provider]: legacy.value.apiKey }));
                  }
               }
            });
        }
      });
  }, []);

  const { data: mappingsCount = 0 } = useQuery({
    queryKey: ["amazon_mappings_count"],
    queryFn: async () => {
      const { count } = await supabase.from("amazon_product_mappings").select("id", { count: "exact", head: true });
      return count || 0;
    },
  });

  const { data: mappingsList = [], isLoading: loadingMappings } = useQuery({
    queryKey: ["amazon_mappings_list"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("amazon_product_mappings")
        .select("*, products(id, title, price, badge, image_url, is_active)")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

  const handleSearch = async (offset = 0, overrideType?: "default"|"ofertas"|"maisVendidos", overrideCategory?: string) => {
    const typeToUse = overrideType || currentSearchType;
    if (overrideType && overrideType !== currentSearchType) setCurrentSearchType(overrideType);
    
    const categoryToUse = overrideCategory !== undefined ? overrideCategory : currentCategoryId;
    if (overrideCategory !== undefined && overrideCategory !== currentCategoryId) setCurrentCategoryId(overrideCategory);

    if (typeToUse === "default" && !keyword.trim()) return toast.error("Digite uma palavra-chave.");

    if (offset === 0) setResults([]);
    setSearching(true);

    try {
      const { data, error } = await supabase.functions.invoke("amazon-search-offers", {
        body: { keyword: keyword.trim(), offset, searchType: typeToUse, categoryId: categoryToUse },
      });

      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      const items = data.results || [];
      if (items.length === 0) toast.warning("Nenhum produto encontrado. A Amazon pode ter bloqueado o proxy temporariamente.");

      setResults(offset === 0 ? items : [...results, ...items]);
      setCurrentOffset(offset);

      const newlyImported = new Set(imported);
      items.forEach((item: AmazonItem) => { if (item.already_imported) newlyImported.add(item.id); });
      setImported(newlyImported);

    } catch (err: any) {
      toast.error(err.message || "A busca falhou.");
    } finally {
      setSearching(false);
    }
  };

  const handleImport = async (item: AmazonItem) => {
    if (importing.has(item.id) || imported.has(item.id)) return;
    setImporting((prev) => new Set(prev).add(item.id));

    try {
      const { data, error } = await supabase.functions.invoke("amazon-import-product", {
        body: { item, userId: user?.id },
      });
      if (error) throw error;
      if (data?.error && !data.product_id) throw new Error(data.error);

      toast.success(`"${item.title?.slice(0, 30)}..." importado!`);
      setImported((prev) => new Set(prev).add(item.id));
      qc.invalidateQueries({ queryKey: ["products"] });
      qc.invalidateQueries({ queryKey: ["amazon_mappings_count"] });
    } catch (err: any) {
      toast.error("Erro ao importar: " + (err.message || "Falha"));
    } finally {
      setImporting((prev) => { const s = new Set(prev); s.delete(item.id); return s; });
    }
  };

  const handleSyncAll = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("amazon-batch-sync", { body: { userId: user?.id } });
      if (error || data?.error) throw error || new Error(data?.error);
      toast.success(`Sincronização concluída!`);
      
      if (data?.debug_trace) {
        console.group("=== AMAZON BATCH SYNC DEBUG TRACE ===");
        console.log(data.debug_trace);
        console.groupEnd();
      }

      qc.invalidateQueries({ queryKey: ["amazon_mappings_list"] });
    } catch (err: any) {
      toast.error("Erro na sincronização.");
    } finally {
      setSyncing(false);
    }
  };

  const handleSaveScraper = async () => {
    setSavingScraper(true);
    try {
       const { error } = await (supabase as any).from("admin_settings").upsert({
          key: "scraper_config", value: { activeProvider, keys: scraperKeys }
       }, { onConflict: "key" });
       
       if (error) throw error;
       toast.success("Configuração de Scraper atualizada!");
       setIsSettingsOpen(false);
    } catch(err: any) {
       toast.error("Erro ao salvar config: " + err.message);
    } finally {
       setSavingScraper(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="font-display font-bold text-xl text-foreground flex items-center gap-2">
            <ShoppingCart className="w-5 h-5 text-orange-500" /> Amazon Brasil
          </h2>
          <p className="text-sm text-muted-foreground mt-1">Integração baseada em Web Scraping dinâmico.</p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs bg-secondary px-3 py-1.5 rounded-full text-muted-foreground">{mappingsCount} mapeados</span>
          <div className="flex gap-2 w-full md:w-auto">
            {mappingsCount > 0 && (
              <Button variant="outline" onClick={handleSyncAll} disabled={syncing}>
                {syncing ? <RefreshCw className="mr-2 h-4 w-4 animate-spin" /> : <RefreshCw className="mr-2 h-4 w-4" />}
                Sincronizar Preços
              </Button>
            )}
            <Button variant="default" className="bg-zinc-900 border" onClick={() => setIsSettingsOpen(true)}>
              <Settings className="mr-2 h-4 w-4" /> Proxy Scraper
            </Button>
          </div>
        </div>
      </div>

      {isSettingsOpen && (
        <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
           <div className="bg-card border shadow-lg rounded-xl p-6 w-full max-w-lg relative animate-in fade-in zoom-in-95 duration-200">
              <button onClick={() => setIsSettingsOpen(false)} className="absolute top-4 right-4 text-muted-foreground hover:text-foreground">
                <X className="w-5 h-5"/>
              </button>
              <h3 className="font-bold text-lg mb-4 flex items-center gap-2"><Settings className="w-5 h-5"/> Configuração Multi-Scraper</h3>
              <p className="text-xs text-muted-foreground mb-4">A Amazon exige proxies fortes (Residential). Use ScrapingBee ou ScrapingAnt para evitar CAPTCHAs e bloqueios 503.</p>
              
              <div className="space-y-4">
                 <div className="bg-secondary/50 p-3 rounded-lg border">
                    <label className="text-sm font-semibold mb-2 block">1. Provedor de Extração Ativo</label>
                    <div className="grid grid-cols-2 gap-2">
                       {['scrapingbee', 'scrape.do', 'scrapingant', 'scraperapi'].map((prov) => (
                         <label key={prov} className={`flex items-center gap-2 p-3 rounded-lg border cursor-pointer transition-colors ${activeProvider === prov ? 'bg-primary/5 border-primary text-primary font-medium' : 'bg-background hover:bg-secondary/80'}`}>
                           <input type="radio" name="active_provider" value={prov} checked={activeProvider === prov} onChange={() => setActiveProvider(prov)} className="accent-primary w-4 h-4"/>
                           <span className="capitalize">{prov.replace('.do', '.DO').replace('api', 'API').replace('ant', 'Ant').replace('bee', 'Bee')}</span>
                         </label>
                       ))}
                    </div>
                 </div>

                 <div className="space-y-3 pt-2">
                    <label className="text-sm font-semibold">2. Cofre de Tokens (Compartilhado com M.Livre)</label>
                    {[
                      { id: "scrapingbee", label: "ScrapingBee (api_key)" },
                      { id: "scrape.do", label: "Scrape.do (token)" },
                      { id: "scrapingant", label: "ScrapingAnt (x-api-key)" },
                      { id: "scraperapi", label: "ScraperAPI (api_key)" }
                    ].map((svc) => (
                      <div key={svc.id} className="flex flex-col gap-1.5">
                         <label className="text-xs text-muted-foreground font-medium">{svc.label}</label>
                         <input 
                           type="password" 
                           value={scraperKeys[svc.id] || ""} 
                           onChange={e => setScraperKeys(prev => ({ ...prev, [svc.id]: e.target.value.trim() }))} 
                           placeholder={`Cole a chave do ${svc.id} aqui...`} 
                           className={`w-full h-9 px-3 rounded-md bg-background border text-sm outline-none transition-all focus:ring-2 focus:ring-primary/20 ${activeProvider === svc.id ? 'border-primary shadow-sm' : 'border-border'}`} 
                         />
                      </div>
                    ))}
                 </div>
                 <Button className="w-full mt-4 h-11" onClick={handleSaveScraper} disabled={savingScraper || !scraperKeys[activeProvider]}>
                    {savingScraper ? <Loader2 className="w-4 h-4 animate-spin mr-2"/> : null} Salvar e Aplicar
                 </Button>
              </div>
           </div>
        </div>
      )}

      <div className="bg-card rounded-xl border border-border p-4 shadow-sm">
        <div className="flex gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
            <input
              value={keyword}
              onChange={(e) => { setKeyword(e.target.value); setCurrentSearchType("default"); }}
              onKeyDown={(e) => e.key === "Enter" && handleSearch(0, "default")}
              placeholder="Ex: Kindle Paperwhite, Echo Dot, PS5"
              className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm focus:ring-2 focus:ring-orange-500/30 outline-none"
            />
          </div>
          <button onClick={() => handleSearch(0, "default")} disabled={searching} className="h-10 px-5 rounded-lg bg-orange-500 text-white font-semibold hover:bg-orange-600 disabled:opacity-50 flex items-center gap-2">
            {searching && results.length === 0 ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />} Buscar
          </button>
        </div>
        
        <div className="flex flex-wrap items-center gap-2 mt-3 pt-1 border-t border-border/50">
           <button onClick={() => { setKeyword(""); handleSearch(0, "ofertas"); }} disabled={searching} className={`h-8 px-3 rounded-full text-xs font-bold transition-colors flex items-center gap-1.5 ${currentSearchType === "ofertas" ? "bg-red-500 text-white shadow-md shadow-red-500/20" : "bg-red-500/10 text-red-600 border border-red-500/20 hover:bg-red-500/20"}`}>
              🔥 Ofertas do Dia (Today's Deals)
           </button>
           
           <div className={`flex items-center rounded-full border transition-colors ${currentSearchType === "maisVendidos" ? "bg-purple-500/10 border-purple-500/30 ring-1 ring-purple-500/20" : "bg-secondary border-border"}`}>
              <div className="px-3 py-1.5 text-xs font-bold text-purple-600 flex items-center gap-1.5 border-r border-border/50">
                 🏆 Mais Vendidos
              </div>
              <select 
                title="Categorias de Mais Vendidos da Amazon"
                className="bg-transparent text-xs font-medium text-foreground py-1.5 px-2 outline-none cursor-pointer w-[180px] truncate"
                value={currentCategoryId}
                onChange={(e) => {
                  const val = e.target.value;
                  if (val) {
                    setKeyword(""); handleSearch(0, "maisVendidos", val);
                  } else {
                    setCurrentCategoryId(""); setCurrentSearchType("default");
                  }
                }}
                disabled={searching}
              >
                <option value="">Selecione...</option>
                <option value="computadores">Computadores e Informática</option>
                <option value="eletronicos">Eletrônicos e Tecnologia</option>
                <option value="videogames">Games e Consoles</option>
                <option value="livros">Livros</option>
                <option value="casa">Casa e Cozinha</option>
                <option value="beleza">Beleza</option>
                <option value="brinquedos">Brinquedos e Jogos</option>
              </select>
           </div>
        </div>
      </div>

      {results.length > 0 && (
        <div className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            <AnimatePresence>
              {results.map((item) => {
                const isImporting = importing.has(item.id);
                const isImported = imported.has(item.id);

                return (
                  <motion.div key={item.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className={`bg-card rounded-xl border border-border overflow-hidden ${isImported ? "opacity-60" : ""}`}>
                    <div className="flex gap-3 p-4">
                      <div className="w-20 h-20 rounded-lg bg-white shrink-0 p-1">
                        {item.thumbnail && <img src={item.thumbnail} className="w-full h-full object-contain rounded-lg mix-blend-multiply" />}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-sm line-clamp-2" title={item.title}>{item.title}</h4>
                        <div className="font-bold text-sm mt-1.5 text-orange-600">
                           {item.price > 0 ? `R$ ${Number(item.price).toFixed(2).replace(".", ",")}` : "Preço Indisponível"}
                        </div>
                        {item.original_price && item.original_price > item.price && (
                           <div className="text-xs text-muted-foreground line-through">R$ {Number(item.original_price).toFixed(2).replace(".", ",")}</div>
                        )}
                        
                        <div className="text-xs text-muted-foreground mt-1.5 flex flex-wrap gap-1.5">
                          <span className="bg-secondary px-1.5 py-0.5 rounded border shadow-sm">Amazon</span>
                          {item.rating && item.rating > 0 ? (
                            <span className="bg-yellow-500/10 text-yellow-600 px-1.5 py-0.5 rounded border border-yellow-500/20 flex items-center gap-1">
                              ⭐ {item.rating} ({item.reviewCount || 0})
                            </span>
                          ) : null}
                        </div>
                        {item.badge && (
                           <span className="text-[10px] bg-red-600 text-white font-bold px-1.5 py-0.5 rounded mt-2 inline-block">
                             {item.badge}
                           </span>
                        )}
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                      <button onClick={() => handleImport(item)} disabled={isImporting || isImported || item.price === 0} className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 ${isImported ? "bg-green-500/10 text-green-600" : "bg-orange-500 text-white hover:bg-orange-600 disabled:opacity-50"}`}>
                        {isImported ? <><Check className="w-3.5 h-3.5" /> Importado</> : isImporting ? <><Loader2 className="w-3.5 h-3.5 animate-spin" /> Extraindo</> : <><Download className="w-3.5 h-3.5" /> Importar</>}
                      </button>
                      <a href={item.permalink} target="_blank" className="h-9 w-9 border rounded-lg flex items-center justify-center hover:bg-secondary"><ExternalLink className="w-3.5 h-3.5" /></a>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>
          <div className="flex justify-center mt-6">
             <button onClick={() => handleSearch(currentOffset + 48)} disabled={searching} className="px-6 py-2 border rounded-lg hover:bg-secondary flex gap-2 text-sm font-medium">
               {searching ? <><Loader2 className="w-4 h-4 animate-spin" /> Carregando proxy...</> : "Buscar Mais (Próxima Página Amazon)"}
             </button>
          </div>
        </div>
      )}

      {mappingsList.length > 0 && !searching && results.length === 0 && (
        <div className="mt-8">
          <h3 className="font-display font-bold text-lg mb-4 text-foreground">Produtos Amazon Cadastrados ({mappingsCount})</h3>
          <div className="bg-card rounded-xl border border-border shadow-sm divide-y divide-border">
            {mappingsList.map((m: any) => (
              <div key={m.id} className="flex flex-col sm:flex-row gap-4 p-4 items-start sm:items-center hover:bg-secondary/40 transition-colors">
                 <div className="w-14 h-14 bg-white rounded-lg shrink-0 border p-1">
                   {m.products?.image_url && <img src={m.products.image_url} className="w-full h-full object-contain mix-blend-multiply" />}
                 </div>
                 <div className="flex-1 min-w-0">
                   <p className="text-sm font-medium line-clamp-2">{m.products?.title}</p>
                   <div className="flex flex-wrap gap-2 text-xs text-muted-foreground mt-1.5 items-center">
                     <span className="font-mono bg-orange-500/10 text-orange-600 px-1.5 py-0.5 rounded border border-orange-500/20">ASIN: {m.amazon_item_id}</span>
                     <span className="bg-secondary px-1.5 py-0.5 rounded border">Status (Scraping): {m.amazon_status}</span>
                     {m.last_synced_at && <span className="bg-secondary px-1.5 py-0.5 border rounded" title={new Date(m.last_synced_at).toLocaleString()}>Sync: {new Date(m.last_synced_at).toLocaleDateString()}</span>}
                   </div>
                 </div>
                 <div className="text-right w-full sm:w-auto flex sm:flex-col justify-between sm:justify-center items-center sm:items-end gap-2">
                   <div className="text-sm font-bold text-orange-600">R$ {Number(m.products?.price || m.amazon_current_price).toFixed(2).replace('.', ',')}</div>
                   {m.products?.is_active ? <span className="text-xs font-medium text-green-600 bg-green-500/10 px-2 py-0.5 rounded border border-green-500/20">Ativo na Loja</span> : <span className="text-xs font-medium text-red-600 bg-red-500/10 px-2 py-0.5 rounded border border-red-500/20">Oculto</span>}
                 </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminAmazon;
