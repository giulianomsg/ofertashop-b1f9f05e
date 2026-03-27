import { useState, useEffect } from "react";
import { Search, Download, RefreshCw, Loader2, ExternalLink, Check, Settings, X, Leaf } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";

interface NaturaItem {
  id: string; title: string; price: number; original_price: number | null;
  thumbnail: string; permalink: string;
  seller: { nickname: string };
  already_imported?: boolean;
  rating?: number; reviewCount?: number; badge?: string;
}

const AdminNatura = () => {
  const { user } = useAuth();
  const qc = useQueryClient();

  // Estados Limpos
  const [keyword, setKeyword] = useState("");
  const [brand, setBrand] = useState<"natura" | "avon">("natura");
  const [currentSearchType, setCurrentSearchType] = useState<"default"|"ofertas"|"maisVendidos">("default");
  const [results, setResults] = useState<NaturaItem[]>([]);
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
    queryKey: ["natura_mappings_count"],
    queryFn: async () => {
      const { count } = await supabase.from("natura_product_mappings").select("id", { count: "exact", head: true });
      return count || 0;
    },
  });

  const { data: mappingsList = [], isLoading: loadingMappings } = useQuery({
    queryKey: ["natura_mappings_list"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("natura_product_mappings")
        .select("*, products(id, title, price, original_price, badge, image_url, is_active)")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

  const handleSearch = async (offset = 0) => {
    if (!keyword.trim()) return toast.error("Digite uma palavra-chave.");

    if (offset === 0) setResults([]);
    setSearching(true);

    try {
      const { data, error } = await supabase.functions.invoke("natura-search-offers", {
        body: { keyword: keyword.trim(), offset, searchType: currentSearchType, brand: brand },
      });

      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      const items = data.results || [];
      if (items.length === 0) toast.warning("Nenhum produto encontrado. Verifique a busca ou proxy.");

      setResults(offset === 0 ? items : [...results, ...items]);
      setCurrentOffset(offset);

      const newlyImported = new Set(imported);
      items.forEach((item: NaturaItem) => { if (item.already_imported) newlyImported.add(item.id); });
      setImported(newlyImported);

    } catch (err: any) {
      toast.error(err.message || "A busca falhou.");
    } finally {
      setSearching(false);
    }
  };

  const handleImport = async (item: NaturaItem) => {
    if (importing.has(item.id) || imported.has(item.id)) return;
    setImporting((prev) => new Set(prev).add(item.id));

    try {
      const { data, error } = await supabase.functions.invoke("natura-import-product", {
        body: { item, userId: user?.id },
      });
      if (error) throw error;
      if (data?.error && !data.product_id) throw new Error(data.error);

      toast.success(`"${item.title?.slice(0, 30)}..." importado!`);
      setImported((prev) => new Set(prev).add(item.id));
      qc.invalidateQueries({ queryKey: ["products"] });
      qc.invalidateQueries({ queryKey: ["natura_mappings_count"] });
    } catch (err: any) {
      toast.error("Erro ao importar: " + (err.message || "Falha"));
    } finally {
      setImporting((prev) => { const s = new Set(prev); s.delete(item.id); return s; });
    }
  };

  const handleSyncAll = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("natura-batch-sync", { body: { userId: user?.id } });
      if (error || data?.error) throw error || new Error(data?.error);
      toast.success(`Sincronização concluída!`);
      
      if (data?.debug_trace) {
        console.group("=== NATURA BATCH SYNC DEBUG TRACE ===");
        console.log(data.debug_trace);
        console.groupEnd();
      }

      qc.invalidateQueries({ queryKey: ["natura_mappings_list"] });
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
            <Leaf className="w-5 h-5 text-emerald-500" /> Natura & Avon
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

      {/* Proxy Settings Modal */}
      {isSettingsOpen && (
        <div className="fixed inset-0 bg-background/80 backdrop-blur-sm z-50 flex items-center justify-center p-4">
           <div className="bg-card border shadow-lg rounded-xl p-6 w-full max-w-lg relative animate-in fade-in zoom-in-95 duration-200">
              <button onClick={() => setIsSettingsOpen(false)} className="absolute top-4 right-4 text-muted-foreground hover:text-foreground">
                <X className="w-5 h-5"/>
              </button>
              <h3 className="font-bold text-lg mb-4 flex items-center gap-2"><Settings className="w-5 h-5"/> Configuração Multi-Scraper</h3>
              <p className="text-xs text-muted-foreground mb-4">Natura & Avon podem exigir proxies residenciais para acesso às ofertas. Se for bloqueado, ative o ScrapingBee.</p>
              
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
                    <label className="text-sm font-semibold">2. Cofre de Tokens (Compartilhado com Amazon/ML)</label>
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

      {/* Search Bar */}
      <div className="bg-card rounded-xl border border-border p-4 shadow-sm">
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="flex gap-2 shrink-0">
             <button
               onClick={() => { setBrand("natura"); setResults([]); }}
               className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors border ${brand === "natura" ? "bg-emerald-50 text-emerald-600 border-emerald-200" : "bg-transparent text-foreground hover:bg-secondary"}`}
             >
               🌿 Natura
             </button>
             <button
               onClick={() => { setBrand("avon"); setResults([]); }}
               className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors border ${brand === "avon" ? "bg-pink-50 text-pink-600 border-pink-200" : "bg-transparent text-foreground hover:bg-secondary"}`}
             >
               💄 Avon
             </button>
          </div>
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
            <input
              value={keyword}
              onChange={(e) => setKeyword(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && handleSearch(0)}
              placeholder={`Buscar em ${brand === 'natura' ? 'Natura' : 'Avon'}...`}
              className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm focus:ring-2 focus:ring-emerald-500/30 outline-none"
            />
          </div>
          <button onClick={() => handleSearch(0)} disabled={searching} className="h-10 px-5 rounded-lg bg-emerald-500 text-white font-semibold hover:bg-emerald-600 disabled:opacity-50 flex items-center justify-center gap-2 shrink-0">
            {searching && results.length === 0 ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />} Buscar
          </button>
        </div>
      </div>

      {/* API Results */}
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
                      <div className="w-20 h-20 rounded-lg bg-white shrink-0 p-1 border flex items-center justify-center">
                        {item.thumbnail ? <img src={item.thumbnail} className="w-full h-full object-contain mix-blend-multiply" /> : <span className="text-[10px] text-muted-foreground">Sem Foto</span>}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-sm line-clamp-2" title={item.title}>{item.title}</h4>
                        <div className="font-bold text-sm mt-1.5 text-emerald-600">
                           {item.price > 0 ? `R$ ${Number(item.price).toFixed(2).replace(".", ",")}` : "Indisponível"}
                        </div>
                        {item.original_price && item.original_price > item.price && (
                           <div className="text-xs text-muted-foreground line-through">R$ {Number(item.original_price).toFixed(2).replace(".", ",")}</div>
                        )}
                        
                        <div className="text-xs text-muted-foreground mt-1.5 flex flex-wrap gap-1.5">
                           <span className={`px-1.5 py-0.5 rounded border shadow-sm ${item.seller?.nickname === 'Avon' ? 'bg-pink-50 text-pink-600 border-pink-100' : 'bg-emerald-50 text-emerald-600 border-emerald-100'}`}>
                             {item.seller?.nickname}
                           </span>
                           {item.rating && item.rating > 0 ? (
                             <span className="bg-yellow-500/10 text-yellow-600 px-1.5 py-0.5 rounded border border-yellow-500/20 flex items-center gap-1">
                               ⭐ {item.rating}
                             </span>
                           ) : null}
                        </div>
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                       <button onClick={() => handleImport(item)} disabled={isImporting || isImported || item.price === 0} className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 ${isImported ? "bg-green-500/10 text-green-600" : "bg-emerald-500 text-white hover:bg-emerald-600 disabled:opacity-50"}`}>
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
               {searching ? <><Loader2 className="w-4 h-4 animate-spin" /> Carregando proxy...</> : "Buscar Mais"}
             </button>
          </div>
        </div>
      )}

      {/* Mapped DB Items */}
      {mappingsList.length > 0 && !searching && results.length === 0 && (
        <div className="mt-8">
          <h3 className="font-display font-bold text-lg mb-4 text-foreground">Produtos Natura/Avon Cadastrados ({mappingsCount})</h3>
          <div className="bg-card rounded-xl border border-border shadow-sm divide-y divide-border">
            {mappingsList.map((m: any) => (
              <div key={m.id} className="flex flex-col sm:flex-row gap-4 p-4 items-start sm:items-center hover:bg-secondary/40 transition-colors">
                 <div className="w-14 h-14 bg-white rounded-lg shrink-0 border p-1">
                   {m.products?.image_url ? <img src={m.products.image_url} className="w-full h-full object-contain mix-blend-multiply" /> : <Leaf className="w-full h-full p-2 text-emerald-200" />}
                 </div>
                 <div className="flex-1 min-w-0">
                   <p className="text-sm font-medium line-clamp-2">{m.products?.title}</p>
                   <div className="flex flex-wrap gap-2 text-xs text-muted-foreground mt-1.5 items-center">
                     <span className="font-mono bg-emerald-500/10 text-emerald-600 px-1.5 py-0.5 rounded border border-emerald-500/20">ID: {m.natura_item_id}</span>
                     <span className="bg-secondary px-1.5 py-0.5 rounded border">Status (Scraping): {m.natura_status}</span>
                     {m.last_synced_at && <span className="bg-secondary px-1.5 py-0.5 border rounded" title={new Date(m.last_synced_at).toLocaleString()}>Sync: {new Date(m.last_synced_at).toLocaleDateString()}</span>}
                   </div>
                 </div>
                 <div className="text-right w-full sm:w-auto flex sm:flex-col justify-between sm:justify-center items-center sm:items-end gap-2">
                   <div className="text-sm font-bold text-emerald-600">R$ {Number(m.products?.price || m.natura_current_price).toFixed(2).replace('.', ',')}</div>
                   {m.products?.original_price && m.products.original_price > (m.products?.price || m.natura_current_price) && (
                      <div className="text-xs line-through text-muted-foreground">
                        R$ {Number(m.products.original_price).toFixed(2).replace('.', ',')}
                      </div>
                   )}
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

export default AdminNatura;
