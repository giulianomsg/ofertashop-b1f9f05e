import { useState } from "react";
import { Mail, Save, FileText, Check, PackageSearch, Users } from "lucide-react";
import { useProducts } from "@/hooks/useProducts";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { motion } from "framer-motion";

const AdminNewsletters = () => {
  const [subject, setSubject] = useState("");
  const [content, setContent] = useState("<p>Olá,</p><p>Confira nossas ofertas imperdíveis desta semana!</p>");
  const [selectedProducts, setSelectedProducts] = useState<string[]>([]);
  const [saving, setSaving] = useState(false);
  const [subscribers, setSubscribers] = useState<any[]>([]);
  const [showSubscribers, setShowSubscribers] = useState(false);

  const { data: products = [], isLoading } = useProducts();

  const toggleProduct = (productId: string) => {
    setSelectedProducts(prev => 
      prev.includes(productId) 
        ? prev.filter(id => id !== productId)
        : [...prev, productId]
    );
  };

  const loadSubscribers = async () => {
    const { data, error } = await supabase
      .from("profiles")
      .select("user_id, full_name, newsletter_opt_in")
      .eq("newsletter_opt_in", true);
    if (!error && data) setSubscribers(data);
    setShowSubscribers(true);
  };

  const handleSaveDraft = async () => {
    if (!subject.trim()) {
      toast.error("O assunto é obrigatório.");
      return;
    }
    
    setSaving(true);
    try {
      const { data: newsletter, error: newsletterError } = await (supabase as any)
        .from("newsletters")
        .insert({
          subject,
          html_content: content,
          status: "draft"
        })
        .select()
        .single();

      if (newsletterError) throw newsletterError;

      if (selectedProducts.length > 0 && newsletter) {
        const pivotData = selectedProducts.map(productId => ({
          newsletter_id: newsletter.id,
          product_id: productId
        }));

        const { error: pivotError } = await (supabase as any)
          .from("newsletter_products")
          .insert(pivotData);

        if (pivotError) throw pivotError;
      }

      toast.success("Rascunho salvo com sucesso!");
      setSubject("");
      setContent("<p>Olá,</p><p>Confira nossas ofertas imperdíveis desta semana!</p>");
      setSelectedProducts([]);
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : "Erro desconhecido";
      console.error(error);
      toast.error("Erro ao salvar newsletter: " + message);
    } finally {
      setSaving(false);
    }
  };

  const handleDispatchToQueue = async () => {
    if (!subject.trim()) {
      toast.error("O assunto é obrigatório.");
      return;
    }

    setSaving(true);
    try {
      // Get all newsletter subscribers
      const { data: subs, error: subError } = await supabase
        .from("profiles")
        .select("user_id")
        .eq("newsletter_opt_in", true);

      if (subError) throw subError;
      if (!subs || subs.length === 0) {
        toast.error("Nenhum assinante de newsletter encontrado.");
        setSaving(false);
        return;
      }

      const fullHtml = content + productsPreviewHTML;

      const queueData = subs.map((sub) => ({
        user_id: sub.user_id,
        subject,
        html_content: fullHtml,
        status: "pending"
      }));

      const { error: queueError } = await (supabase as any)
        .from("email_queue")
        .insert(queueData);

      if (queueError) throw queueError;

      toast.success(`${subs.length} e-mails adicionados à fila!`);
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : "Erro desconhecido";
      toast.error("Erro ao enviar: " + message);
    } finally {
      setSaving(false);
    }
  };

  const productsPreviewHTML = `
    <table style="width: 100%; max-width: 600px; margin: 0 auto; border-collapse: collapse; font-family: sans-serif;">
      <tbody>
        ${selectedProducts.map((productId) => {
          const p = products.find(p => p.id === productId);
          if (!p) return '';
          const img = p.image_url || 'https://via.placeholder.com/150';
          const price = Number(p.price).toFixed(2).replace('.', ',');
          return `
            <tr>
              <td style="padding: 15px; border-bottom: 1px solid #eee; text-align: left; vertical-align: top;">
                <img src="${img}" alt="${p.title}" style="width: 120px; border-radius: 8px;">
              </td>
              <td style="padding: 15px; border-bottom: 1px solid #eee; text-align: left; vertical-align: top;">
                <h3 style="margin: 0 0 10px 0; font-size: 16px; color: #333;">${p.title}</h3>
                <p style="margin: 0 0 10px 0; font-size: 18px; font-weight: bold; color: #e11d48;">R$ ${price}</p>
                <a href="${p.affiliate_url}" style="display: inline-block; padding: 10px 20px; background-color: #3b82f6; color: #ffffff; text-decoration: none; border-radius: 5px; font-weight: bold;">Ver Oferta</a>
              </td>
            </tr>
          `;
        }).join('')}
      </tbody>
    </table>
  `;

  return (
    <div className="space-y-8">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-display font-bold text-foreground">Criador de Newsletters</h2>
          <p className="text-muted-foreground mt-1">Monte e-mails com ofertas e salve como rascunho ou envie para a fila.</p>
        </div>
        <button onClick={loadSubscribers} className="flex items-center gap-2 text-sm px-3 py-2 rounded-lg bg-secondary hover:bg-secondary/80 text-foreground transition-colors" aria-label="Ver assinantes">
          <Users className="w-4 h-4" /> Assinantes
        </button>
      </div>

      {showSubscribers && (
        <div className="bg-card border border-border rounded-xl p-5 shadow-sm">
          <h3 className="font-semibold text-sm mb-3">Assinantes da Newsletter ({subscribers.length})</h3>
          {subscribers.length === 0 ? (
            <p className="text-sm text-muted-foreground">Nenhum assinante encontrado.</p>
          ) : (
            <div className="max-h-40 overflow-y-auto space-y-1">
              {subscribers.map((s: any) => (
                <div key={s.user_id} className="text-sm text-muted-foreground">{s.full_name || s.user_id}</div>
              ))}
            </div>
          )}
        </div>
      )}

      <div className="grid lg:grid-cols-2 gap-8">
        <div className="space-y-6">
          <div className="bg-card border border-border rounded-xl p-5 shadow-sm space-y-4">
            <h3 className="font-semibold flex items-center gap-2"><FileText className="w-4 h-4" /> Informações do E-mail</h3>
            <div>
              <label className="block text-sm font-medium mb-1">Assunto do E-mail</label>
              <input 
                type="text" 
                value={subject} 
                onChange={(e) => setSubject(e.target.value)} 
                className="w-full h-10 px-3 rounded-md border border-input bg-background text-sm"
                placeholder="Ex: Ofertas Exclusivas da Semana!"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Conteúdo Inicial (HTML tolerado)</label>
              <textarea 
                value={content} 
                onChange={(e) => setContent(e.target.value)} 
                className="w-full h-32 px-3 py-2 rounded-md border border-input bg-background auto-resize scrollbar-none text-sm"
                placeholder="<p>Texto do e-mail...</p>"
              />
            </div>
          </div>

          <div className="bg-card border border-border rounded-xl p-5 shadow-sm space-y-4 h-[400px] flex flex-col">
            <h3 className="font-semibold flex items-center gap-2"><PackageSearch className="w-4 h-4" /> Selecionar Produtos ({selectedProducts.length})</h3>
            
            <div className="flex-1 overflow-y-auto space-y-2 pr-2">
              {isLoading && <p className="text-sm text-muted-foreground">Carregando produtos...</p>}
              {products.map(p => {
                const isSelected = selectedProducts.includes(p.id);
                return (
                  <div 
                    key={p.id}
                    onClick={() => toggleProduct(p.id)}
                    className={`flex items-center gap-3 p-3 rounded-lg border cursor-pointer transition-colors ${isSelected ? 'border-accent bg-accent/5' : 'border-border hover:bg-secondary'}`}
                  >
                    <div className={`w-5 h-5 rounded border flex items-center justify-center shrink-0 ${isSelected ? 'bg-accent border-accent text-white' : 'border-input bg-background'}`}>
                      {isSelected && <Check className="w-3.5 h-3.5" />}
                    </div>
                    <img src={p.image_url || '/placeholder.svg'} alt="" className="w-10 h-10 object-contain rounded bg-white" />
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium truncate">{p.title}</p>
                      <p className="text-xs text-muted-foreground">R$ {Number(p.price).toFixed(2)}</p>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        </div>

        <div className="space-y-6">
          <div className="bg-card border border-border rounded-xl p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between flex-wrap gap-2">
              <h3 className="font-semibold flex items-center gap-2"><Mail className="w-4 h-4" /> Pré-visualização</h3>
              <div className="flex gap-2">
                <button 
                  onClick={handleSaveDraft}
                  disabled={saving}
                  className="btn-accent flex items-center gap-2 disabled:opacity-50 text-sm"
                  aria-label="Salvar rascunho"
                >
                  <Save className="w-4 h-4" /> {saving ? "Salvando..." : "Salvar Rascunho"}
                </button>
                <button
                  onClick={handleDispatchToQueue}
                  disabled={saving}
                  className="flex items-center gap-2 px-3 py-2 rounded-lg bg-success text-success-foreground text-sm font-medium disabled:opacity-50 hover:bg-success/90 transition-colors"
                  aria-label="Enviar para fila"
                >
                  <Mail className="w-4 h-4" /> Enviar para Fila
                </button>
              </div>
            </div>
            
            <div className="border border-border rounded-lg bg-white text-gray-800 p-8 min-h-[500px] overflow-y-auto">
              <div dangerouslySetInnerHTML={{ __html: content }} />
              <div className="mt-6">
                <div dangerouslySetInnerHTML={{ __html: productsPreviewHTML }} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminNewsletters;
