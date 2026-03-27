import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Search, ShoppingBag, Loader2, Download, ExternalLink, Leaf } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";

interface NaturaProduct {
  title: string;
  price: number;
  originalPrice: number | null;
  imageUrl: string;
  productLink: string;
  brand: string;
}

const AdminNatura = () => {
  const { user } = useAuth();
  const [brand, setBrand] = useState<"natura" | "avon">("natura");
  const [loading, setLoading] = useState(false);
  const [importing, setImporting] = useState<string | null>(null);
  const [products, setProducts] = useState<NaturaProduct[]>([]);
  const [importedLinks, setImportedLinks] = useState<Set<string>>(new Set());

  const handleSearch = async () => {
    setLoading(true);
    try {
      const { data, error } = await supabase.functions.invoke("natura-import-product", {
        body: { action: "search", brand },
      });
      if (error) throw error;
      if (data?.products) {
        setProducts(data.products);
        if (data.products.length === 0) {
          toast.info("Nenhum produto encontrado. A página pode ter estrutura diferente.");
        } else {
          toast.success(`${data.products.length} produto(s) encontrado(s)!`);
        }
      }
    } catch (err: any) {
      toast.error(err.message || "Erro ao buscar produtos");
    } finally {
      setLoading(false);
    }
  };

  const handleImport = async (product: NaturaProduct) => {
    setImporting(product.productLink);
    try {
      const { data, error } = await supabase.functions.invoke("natura-import-product", {
        body: { action: "import", product, userId: user?.id },
      });
      if (error) throw error;
      if (data?.error) {
        if (data.error.includes("já importado")) {
          toast.info("Produto já foi importado.");
        } else {
          throw new Error(data.error);
        }
      } else {
        toast.success(`"${product.title}" importado com sucesso!`);
        setImportedLinks(prev => new Set(prev).add(product.productLink));
      }
    } catch (err: any) {
      toast.error(err.message || "Erro ao importar produto");
    } finally {
      setImporting(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="font-display font-bold text-xl text-foreground flex items-center gap-2">
            <Leaf className="w-5 h-5 text-emerald-500" />
            Natura & Avon
          </h2>
          <p className="text-sm text-muted-foreground mt-1">
            Importe produtos via web scraping da sua loja Natura/Avon
          </p>
        </div>
      </div>

      {/* Search Controls */}
      <div className="bg-card rounded-xl border border-border p-5 space-y-4" style={{ boxShadow: "var(--shadow-card)" }}>
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex gap-2">
            <button
              onClick={() => setBrand("natura")}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${brand === "natura" ? "bg-emerald-500 text-white" : "bg-secondary text-foreground hover:bg-secondary/80"}`}
            >
              🌿 Natura
            </button>
            <button
              onClick={() => setBrand("avon")}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${brand === "avon" ? "bg-pink-500 text-white" : "bg-secondary text-foreground hover:bg-secondary/80"}`}
            >
              💄 Avon
            </button>
          </div>
          <button
            onClick={handleSearch}
            disabled={loading}
            className="btn-accent flex items-center gap-2 text-sm"
          >
            {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />}
            {loading ? "Buscando..." : "Buscar Produtos"}
          </button>
        </div>
        <p className="text-xs text-muted-foreground">
          URL: https://www.minhaloja.natura.com/consultoria/ofertashop?marca={brand}
        </p>
      </div>

      {/* Results */}
      {products.length > 0 && (
        <div className="bg-card rounded-xl border border-border overflow-hidden" style={{ boxShadow: "var(--shadow-card)" }}>
          <div className="p-4 border-b border-border bg-secondary">
            <h3 className="font-semibold text-sm">{products.length} produto(s) encontrado(s)</h3>
          </div>
          <div className="divide-y divide-border">
            <AnimatePresence>
              {products.map((product, index) => {
                const isImported = importedLinks.has(product.productLink);
                const isImporting = importing === product.productLink;
                return (
                  <motion.div
                    key={index}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.03 }}
                    className="flex items-center gap-4 p-4 hover:bg-secondary/50 transition-colors"
                  >
                    {product.imageUrl && (
                      <img src={product.imageUrl} alt={product.title} className="w-16 h-16 rounded-lg object-cover bg-secondary shrink-0" />
                    )}
                    <div className="flex-1 min-w-0">
                      <p className="font-medium text-sm text-foreground line-clamp-2">{product.title}</p>
                      <div className="flex items-center gap-2 mt-1">
                        {product.originalPrice && (
                          <span className="text-xs text-muted-foreground line-through">
                            R$ {product.originalPrice.toFixed(2).replace(".", ",")}
                          </span>
                        )}
                        {product.price > 0 && (
                          <span className="text-sm font-bold text-accent">
                            R$ {product.price.toFixed(2).replace(".", ",")}
                          </span>
                        )}
                        <span className="text-xs px-2 py-0.5 rounded-full bg-secondary text-muted-foreground">
                          {product.brand}
                        </span>
                      </div>
                    </div>
                    <div className="flex items-center gap-2 shrink-0">
                      {product.productLink && (
                        <a href={product.productLink} target="_blank" rel="noopener noreferrer" className="p-2 rounded-lg bg-secondary hover:bg-secondary/80 transition-colors">
                          <ExternalLink className="w-4 h-4 text-muted-foreground" />
                        </a>
                      )}
                      <button
                        onClick={() => handleImport(product)}
                        disabled={isImported || isImporting}
                        className={`flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-colors ${isImported ? "bg-emerald-500/10 text-emerald-600 cursor-default" : "btn-accent"}`}
                      >
                        {isImporting ? (
                          <Loader2 className="w-4 h-4 animate-spin" />
                        ) : isImported ? (
                          "✓ Importado"
                        ) : (
                          <><Download className="w-4 h-4" /> Importar</>
                        )}
                      </button>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdminNatura;
