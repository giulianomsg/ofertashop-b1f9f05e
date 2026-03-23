import { useState, useEffect } from "react";
import { Search, Download, RefreshCw, Loader2, ExternalLink, Check, Package, Settings, X } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { motion, AnimatePresence } from "framer-motion";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";

interface MLItem {
  id: string; title: string; price: number; original_price: number | null;
  currency_id: string; thumbnail: string; permalink: string; condition: string;
  sold_quantity: number; available_quantity: number; seller: { id: number | string; nickname: string };
  category_id: string; shipping_free: boolean; already_imported?: boolean;
  description?: string; rating?: number; reviewCount?: number;
}
/* ... logic remains exactly the same ... */
const AdminMercadoLivre = () => {
  const { user } = useAuth();
  const qc = useQueryClient();

  // Estados Limpos (Sem cache do navegador, a pedido)
  const [keyword, setKeyword] = useState("");
  const [currentSearchType, setCurrentSearchType] = useState<"default"|"ofertas"|"relampago"|"maisVendidos">("default");
  const [currentCategoryId, setCurrentCategoryId] = useState("");
  const [results, setResults] = useState<MLItem[]>([]);
  const [currentOffset, setCurrentOffset] = useState(0);

  const [searching, setSearching] = useState(false);
  const [importing, setImporting] = useState<Set<string>>(new Set());
  const [imported, setImported] = useState<Set<string>>(new Set());
  const [syncing, setSyncing] = useState(false);
  const [authorizing, setAuthorizing] = useState(false);

  // Scraper Settings State
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [activeProvider, setActiveProvider] = useState("scrapingbee");
  const [scraperKeys, setScraperKeys] = useState<Record<string, string>>({
     "scrapingbee": "", "scrape.do": "", "scrapingant": "", "scraperapi": ""
  });
  const [savingScraper, setSavingScraper] = useState(false);

  useEffect(() => {
    // Carrega a configuração multiplexada (todas chaves + ativo)
    (supabase as any).from("admin_settings").select("value").eq("key", "scraper_config").maybeSingle()
      .then(({ data }: any) => {
        if (data?.value) {
          setActiveProvider(data.value.activeProvider || "scrapingbee");
          if (data.value.keys) setScraperKeys(data.value.keys);
        } else {
           // Fallback backwards compatibility with last schema
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

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const code = params.get("code");
    if (code) {
      setAuthorizing(true);
      // Remove code from URL
      window.history.replaceState({}, document.title, window.location.pathname);
      supabase.functions.invoke("ml-auth", {
        body: { code, redirect_uri: window.location.origin + window.location.pathname }
      }).then(({ data, error }) => {
        setAuthorizing(false);
        if (error || !data?.success) {
          toast.error("Erro na Autorização", { description: error?.message || data?.error });
        } else {
          toast.success("Sucesso!", { description: "Autorização do Mercado Livre renovada." });
        }
      });
    }
  }, [toast]);

  const { data: mappingsCount = 0 } = useQuery({
    queryKey: ["ml_mappings_count"],
    queryFn: async () => {
      const { count } = await supabase.from("ml_product_mappings").select("id", { count: "exact", head: true });
      return count || 0;
    },
  });

  const { data: mappingsList = [], isLoading: loadingMappings } = useQuery({
    queryKey: ["ml_mappings_list"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("ml_product_mappings")
        .select("*, products(id, title, price, badge, image_url, is_active)")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

  const handleSearch = async (offset = 0, overrideType?: "default"|"ofertas"|"relampago"|"maisVendidos", overrideCategory?: string) => {
    const typeToUse = overrideType || currentSearchType;
    if (overrideType && overrideType !== currentSearchType) {
       setCurrentSearchType(overrideType);
    }
    
    const categoryToUse = overrideCategory !== undefined ? overrideCategory : currentCategoryId;
    if (overrideCategory !== undefined && overrideCategory !== currentCategoryId) {
       setCurrentCategoryId(overrideCategory);
    }

    if (typeToUse === "default" && !keyword.trim()) return toast.error("Digite uma palavra-chave.");
    if (typeToUse === "maisVendidos" && !categoryToUse) return toast.error("Selecione uma categoria para Mais Vendidos.");

    // Se for uma busca nova, zera os resultados anteriores
    if (offset === 0) setResults([]);
    setSearching(true);

    try {
      const { data, error } = await supabase.functions.invoke("ml-search-products", {
        body: { keyword: keyword.trim(), offset, searchType: typeToUse, categoryId: categoryToUse },
      });

      if (error) throw error;
      if (data?.error) throw new Error(data.error);

      const items = data.results || [];
      if (items.length === 0) toast.warning("Nenhum produto encontrado.");

      setResults(offset === 0 ? items : [...results, ...items]);
      setCurrentOffset(offset);

      const newlyImported = new Set(imported);
      items.forEach((item: MLItem) => { if (item.already_imported) newlyImported.add(item.id); });
      setImported(newlyImported);

    } catch (err: any) {
      toast.error(err.message || "A busca falhou.");
    } finally {
      setSearching(false);
    }
  };

  const handleImport = async (item: MLItem) => {
    if (importing.has(item.id) || imported.has(item.id)) return;
    setImporting((prev) => new Set(prev).add(item.id));

    try {
      const { data, error } = await supabase.functions.invoke("ml-import-product", {
        body: { item, userId: user?.id },
      });
      if (error) throw error;
      if (data?.error && !data.product_id) throw new Error(data.error);

      toast.success(`"${item.title?.slice(0, 30)}..." importado!`);
      setImported((prev) => new Set(prev).add(item.id));
      qc.invalidateQueries({ queryKey: ["products"] });
      qc.invalidateQueries({ queryKey: ["ml_mappings_count"] });
    } catch (err: any) {
      toast.error("Erro ao importar: " + (err.message || "Falha"));
    } finally {
      setImporting((prev) => { const s = new Set(prev); s.delete(item.id); return s; });
    }
  };

  const handleOAuthRedirect = async () => {
    try {
      setAuthorizing(true);
      const redirectUri = window.location.origin + window.location.pathname;
      const { data, error } = await supabase.functions.invoke("ml-auth", {
        body: { action: "auth_url", redirect_uri: redirectUri }
      });
      if (error) throw error;
      if (data?.url) {
        window.location.href = data.url;
      }
    } catch (error: any) {
      console.error(error);
      toast.error("Erro", { description: "Não foi possível gerar a URL de autorização." });
      setAuthorizing(false);
    }
  };

  const handleSyncAll = async () => {
    setSyncing(true);
    try {
      const { data, error } = await supabase.functions.invoke("ml-batch-sync", { body: { userId: user?.id } });
      if (error || data?.error) throw error || new Error(data?.error);
      toast.success(`Sincronização concluída!`);
      
      if (data?.debug_trace) {
        console.group("=== ML BATCH SYNC DEBUG TRACE ===");
        console.log(data.debug_trace);
        console.groupEnd();
      }

      qc.invalidateQueries({ queryKey: ["ml_mappings_list"] });
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
          key: "scraper_config",
          value: { activeProvider, keys: scraperKeys }
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
            <Package className="w-5 h-5 text-yellow-500" /> Mercado Livre
          </h2>
          <p className="text-sm text-muted-foreground mt-1">Busque e importe via API de extração cacheada.</p>
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
            <Button variant="outline" onClick={handleOAuthRedirect} disabled={authorizing}>
              {authorizing ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <ExternalLink className="mr-2 h-4 w-4" />}
              Autorizar API
            </Button>
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
              <p className="text-xs text-muted-foreground mb-4">Mantenha todas as suas chaves cadastradas e alterne de provedor com apenas um clique quando seus bônus diários acabarem.</p>
              
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
                    <label className="text-sm font-semibold">2. Cofre de Tokens</label>
                    
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
                    {savingScraper ? <Loader2 className="w-4 h-4 animate-spin mr-2"/> : null} 
                    Salvar e Aplicar
                 </Button>
                 {!scraperKeys[activeProvider] && (
                   <div className="text-xs text-red-500 text-center font-medium mt-2">Você precisa preencher a chave do provedor que está ativando.</div>
                 )}
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
              placeholder="Ex: Tênis Nike, iPhone 15"
              className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm focus:ring-2 focus:ring-yellow-500/30 outline-none"
            />
          </div>
          <button onClick={() => handleSearch(0, "default")} disabled={searching} className="h-10 px-5 rounded-lg bg-yellow-500 text-white font-semibold hover:bg-yellow-600 disabled:opacity-50 flex items-center gap-2">
            {searching && results.length === 0 ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />} Buscar
          </button>
        </div>
        
        <div className="flex flex-wrap items-center gap-2 mt-3 pt-1 border-t border-border/50">
           <button onClick={() => { setKeyword(""); handleSearch(0, "ofertas"); }} disabled={searching} className={`h-8 px-3 rounded-full text-xs font-bold transition-colors flex items-center gap-1.5 ${currentSearchType === "ofertas" ? "bg-orange-500 text-white shadow-md shadow-orange-500/20" : "bg-orange-500/10 text-orange-600 border border-orange-500/20 hover:bg-orange-500/20"}`}>
              🔥 Ofertas do Dia
           </button>
           <button onClick={() => { setKeyword(""); handleSearch(0, "relampago"); }} disabled={searching} className={`h-8 px-3 rounded-full text-xs font-bold transition-colors flex items-center gap-1.5 ${currentSearchType === "relampago" ? "bg-blue-500 text-white shadow-md shadow-blue-500/20" : "bg-blue-500/10 text-blue-600 border border-blue-500/20 hover:bg-blue-500/20"}`}>
              ⚡ Ofertas Relâmpago
           </button>
           
           <div className={`flex items-center rounded-full border transition-colors ${currentSearchType === "maisVendidos" ? "bg-purple-500/10 border-purple-500/30 ring-1 ring-purple-500/20" : "bg-secondary border-border"}`}>
              <div className="px-3 py-1.5 text-xs font-bold text-purple-600 flex items-center gap-1.5 border-r border-border/50">
                 🏆 Mais Vendidos
              </div>
              <select 
                title="Categorias de Mais Vendidos"
                className="bg-transparent text-xs font-medium text-foreground py-1.5 px-2 outline-none cursor-pointer w-[180px] truncate"
                value={currentCategoryId}
                onChange={(e) => {
                  const val = e.target.value;
                  if (val) {
                    setKeyword(""); handleSearch(0, "maisVendidos", val);
                  } else {
                    setCurrentCategoryId("");
                    setCurrentSearchType("default");
                  }
                }}
                disabled={searching}
              >
                <option value="">Selecione...</option>
                <option value="MLB5672">Acessórios para Veículos</option>
                <option value="MLB271599">Agro</option>
                <option value="MLB1403">Alimentos e Bebidas</option>
                <option value="MLB1367">Antiguidades e Coleções</option>
                <option value="MLB1368">Arte, Papelaria e Armarinho</option>
                <option value="MLB1384">Bebês</option>
                <option value="MLB1246">Beleza e Cuidado Pessoal</option>
                <option value="MLB1132">Brinquedos e Hobbies</option>
                <option value="MLB1430">Calçados, Roupas e Bolsas</option>
                <option value="MLB1574">Casa, Móveis e Decoração</option>
                <option value="MLB1051">Celulares e Telefones</option>
                <option value="MLB1500">Construção</option>
                <option value="MLB1039">Câmeras e Acessórios</option>
                <option value="MLB5726">Eletrodomésticos</option>
                <option value="MLB1000">Eletrônicos, Áudio e Vídeo</option>
                <option value="MLB1276">Esportes e Fitness</option>
                <option value="MLB263532">Ferramentas</option>
                <option value="MLB12404">Festas e Lembrancinhas</option>
                <option value="MLB1144">Games</option>
                <option value="MLB1499">Indústria e Comércio</option>
                <option value="MLB1648">Informática</option>
                <option value="MLB1182">Instrumentos Musicais</option>
                <option value="MLB3937">Joias e Relógios</option>
                <option value="MLB1196">Livros, Revistas e Comics</option>
                <option value="MLB1168">Música, Filmes e Seriados</option>
                <option value="MLB1071">Pet Shop</option>
                <option value="MLB264586">Saúde</option>
              </select>
           </div>
           
           {currentSearchType !== "default" && (
              <span className="text-xs text-muted-foreground ml-2 my-auto font-medium">✨ Você está visualizando o catálogo especial do Mercado Livre.</span>
           )}
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
                      <div className="w-20 h-20 rounded-lg bg-secondary shrink-0">
                        {item.thumbnail && <img src={item.thumbnail} className="w-full h-full object-cover rounded-lg" />}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-sm line-clamp-2">{item.title}</h4>
                        <div className="font-bold text-sm mt-1.5">R$ {Number(item.price).toFixed(2).replace(".", ",")}</div>
                        
                        <div className="text-xs text-muted-foreground mt-1.5 flex flex-wrap gap-1.5">
                          {item.seller?.nickname && item.seller.nickname !== "Vendedor Local" && (
                            <span className="bg-secondary px-1.5 py-0.5 rounded border shadow-sm break-all">{item.seller.nickname}</span>
                          )}
                          {item.condition === 'new' ? (
                            <span className="bg-blue-500/10 text-blue-600 px-1.5 py-0.5 rounded border border-blue-500/20">Novo</span>
                          ) : item.condition === 'used' ? (
                            <span className="bg-orange-500/10 text-orange-600 px-1.5 py-0.5 rounded border border-orange-500/20">Usado</span>
                          ) : item.condition === 'refurbished' ? (
                            <span className="bg-purple-500/10 text-purple-600 px-1.5 py-0.5 rounded border border-purple-500/20">Recondicionado</span>
                          ) : null}
                          {item.sold_quantity > 0 && (
                            <span className="bg-secondary px-1.5 py-0.5 rounded border shadow-sm">{item.sold_quantity}+ vend.</span>
                          )}
                          {item.rating ? (
                            <span className="bg-yellow-500/10 text-yellow-600 px-1.5 py-0.5 rounded border border-yellow-500/20 flex items-center gap-1">
                              ⭐ {item.rating} {item.reviewCount ? `(${item.reviewCount})` : ''}
                            </span>
                          ) : null}
                        </div>

                        {item.description && (
                          <p className="text-xs text-muted-foreground mt-2 line-clamp-2" title={item.description}>
                            {item.description}
                          </p>
                        )}

                        {item.shipping_free && (
                           <span className="text-xs bg-green-500/10 text-green-600 px-1.5 py-0.5 rounded mt-2 inline-block border border-green-500/20">
                             Frete grátis
                           </span>
                        )}
                      </div>
                    </div>
                    <div className="px-4 pb-4 flex gap-2">
                      <button onClick={() => handleImport(item)} disabled={isImporting || isImported} className={`flex-1 h-9 rounded-lg text-xs font-semibold flex items-center justify-center gap-1.5 ${isImported ? "bg-green-500/10 text-green-600" : "bg-yellow-500 text-white hover:bg-yellow-600 disabled:opacity-50"}`}>
                        {isImported ? <><Check className="w-3.5 h-3.5" /> Importado</> : isImporting ? <><Loader2 className="w-3.5 h-3.5 animate-spin" /> Importando</> : <><Download className="w-3.5 h-3.5" /> Importar</>}
                      </button>
                      <a href={item.permalink} target="_blank" className="h-9 w-9 border rounded-lg flex items-center justify-center hover:bg-secondary"><ExternalLink className="w-3.5 h-3.5" /></a>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>
          <div className="flex justify-center mt-6">
            <button onClick={() => handleSearch(currentOffset + 50)} disabled={searching} className="px-6 py-2 border rounded-lg hover:bg-secondary flex gap-2">
              {searching ? <><Loader2 className="w-4 h-4 animate-spin" /> Carregando...</> : "Carregar Próxima Página"}
            </button>
          </div>
        </div>
      )}

      {mappingsList.length > 0 && !searching && results.length === 0 && (
        <div className="mt-8">
          <h3 className="font-display font-bold text-lg mb-4 text-foreground">Produtos Sincronizados ({mappingsCount})</h3>
          <div className="bg-card rounded-xl border border-border shadow-sm divide-y divide-border">
            {mappingsList.map((m: any) => (
              <div key={m.id} className="flex flex-col sm:flex-row gap-4 p-4 items-start sm:items-center hover:bg-secondary/40 transition-colors">
                 <div className="w-14 h-14 bg-secondary rounded-lg shrink-0 border">
                   {m.products?.image_url && <img src={m.products.image_url} className="w-full h-full object-cover rounded-lg" />}
                 </div>
                 <div className="flex-1 min-w-0">
                   <p className="text-sm font-medium line-clamp-2">{m.products?.title}</p>
                   <div className="flex flex-wrap gap-2 text-xs text-muted-foreground mt-1.5 items-center">
                     <span className="font-mono bg-blue-500/10 text-blue-600 px-1.5 py-0.5 rounded border border-blue-500/20">ID: {m.ml_item_id}</span>
                     <span className="bg-secondary px-1.5 py-0.5 rounded border">Status ML: {m.ml_status}</span>
                     {m.ml_sold_quantity > 0 && <span className="bg-secondary px-1.5 py-0.5 rounded border">Vendeu: {m.ml_sold_quantity}</span>}
                     {m.ml_condition && <span className="uppercase bg-secondary px-1.5 py-0.5 rounded border">{m.ml_condition}</span>}
                   </div>
                 </div>
                 <div className="text-right w-full sm:w-auto flex sm:flex-col justify-between sm:justify-center items-center sm:items-end gap-2">
                   <div className="text-sm font-bold">R$ {Number(m.products?.price || m.ml_current_price).toFixed(2).replace('.', ',')}</div>
                   {m.products?.is_active ? <span className="text-xs font-medium text-green-600 bg-green-500/10 px-2 py-0.5 rounded border border-green-500/20">Site Ativo</span> : <span className="text-xs font-medium text-red-600 bg-red-500/10 px-2 py-0.5 rounded border border-red-500/20">Site Inativo</span>}
                 </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminMercadoLivre;