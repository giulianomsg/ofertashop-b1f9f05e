import { useState, useEffect, useCallback, useMemo, useRef } from "react";
import { Mail, Save, FileText, Check, PackageSearch, Users, Trash2, Send, InboxIcon, Pencil, ChevronDown, ChevronUp, Search, Filter, X, Calendar, Settings2, Image, Upload, Loader2 } from "lucide-react";
import { useProducts } from "@/hooks/useProducts";
import { usePlatforms } from "@/hooks/useEntities";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { motion, AnimatePresence } from "framer-motion";
// @ts-ignore
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";

interface Draft {
  id: string;
  subject: string;
  html_content: string;
  status: string;
  created_at: string;
}

const AdminNewsletters = () => {
  const [subject, setSubject] = useState("");
  const [content, setContent] = useState("<p>Confira nossas ofertas imperdíveis desta semana!</p>");
  const [selectedProducts, setSelectedProducts] = useState<string[]>([]);
  const [saving, setSaving] = useState(false);
  const [subscribers, setSubscribers] = useState<any[]>([]);
  const [showSubscribers, setShowSubscribers] = useState(false);

  const [drafts, setDrafts] = useState<Draft[]>([]);
  const [queueStats, setQueueStats] = useState<Record<string, { pending: number, sent: number, failed: number, scheduledAt?: string }>>({});
  const [loadingDrafts, setLoadingDrafts] = useState(false);
  const [isProcessingQueue, setIsProcessingQueue] = useState(false);
  const [newsletterLogoUrl, setNewsletterLogoUrl] = useState<string>("");
  const [isUploadingLogo, setIsUploadingLogo] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [selectedDrafts, setSelectedDrafts] = useState<string[]>([]);
  const [sendingQueue, setSendingQueue] = useState(false);
  const [editingDraftId, setEditingDraftId] = useState<string | null>(null);
  const [showDrafts, setShowDrafts] = useState(true);
  const [scheduledAt, setScheduledAt] = useState("");
  const [rescheduleData, setRescheduleData] = useState<Record<string, string>>({});
  const { data: products = [], isLoading } = useProducts();
  const { data: dbPlatforms = [] } = usePlatforms();

  const [sentThisMonth, setSentThisMonth] = useState(0);
  const [sentToday, setSentToday] = useState(0);
  const [totalContacts, setTotalContacts] = useState(0);

  const [searchProduct, setSearchProduct] = useState("");
  const [storeFilter, setStoreFilter] = useState("");

  const stores = useMemo(() => {
    return Array.from(new Set(dbPlatforms.map(p => p.name).filter(Boolean))) as string[];
  }, [dbPlatforms]);

  const filteredProducts = useMemo(() => {
    return products.filter(p => {
      const matchSearch = p.title?.toLowerCase().includes(searchProduct.toLowerCase());
      const matchStore = storeFilter ? p.store === storeFilter : true;
      return matchSearch && matchStore;
    });
  }, [products, searchProduct, storeFilter]);

  const clearSelectedProducts = () => {
    setSelectedProducts([]);
  };

  // ── Load drafts ──
  const loadDrafts = useCallback(async () => {
    setLoadingDrafts(true);
    try {
      const { data, error } = await (supabase as any)
        .from("newsletters")
        .select("*")
        .order("created_at", { ascending: false });
      if (error) throw error;
      setDrafts(data || []);

      const { data: logoSetting } = await (supabase as any)
        .from("admin_settings")
        .select("value")
        .eq("key", "newsletter_logo_url")
        .maybeSingle();
      if (logoSetting?.value) {
        setNewsletterLogoUrl(logoSetting.value);
      }

      // Load queue stats
      const { data: statsData, error: statsError } = await (supabase as any)
        .from("email_queue")
        .select("newsletter_id, status, scheduled_at")
        .not("newsletter_id", "is", null);

      if (!statsError && statsData) {
        const stats: Record<string, { pending: number, sent: number, failed: number, scheduledAt?: string }> = {};
        statsData.forEach((row: any) => {
          if (!row.newsletter_id) return;
          if (!stats[row.newsletter_id]) stats[row.newsletter_id] = { pending: 0, sent: 0, failed: 0 };
          const s = row.status as keyof typeof stats[string];
          if (stats[row.newsletter_id][s] !== undefined) {
            stats[row.newsletter_id][s]++;
          }
          if (row.scheduled_at && row.status === "pending") {
            stats[row.newsletter_id].scheduledAt = row.scheduled_at;
          }
        });
        setQueueStats(stats);
      }
    } catch (err) {
      console.error("Error loading drafts:", err);
    } finally {
      setLoadingDrafts(false);
    }
  }, []);

  const loadLimits = useCallback(async () => {
    // Current month start
    const startOfMonth = new Date();
    startOfMonth.setDate(1);
    startOfMonth.setHours(0, 0, 0, 0);

    // Current day start
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const currentMonthIso = startOfMonth.toISOString().split("T")[0];
    const todayIso = startOfDay.toISOString().split("T")[0];

    const { data: usageData } = await (supabase as any)
      .from("resend_usage_logs")
      .select("date, sent_count")
      .gte("date", currentMonthIso);

    let mCount = 0;
    let dCount = 0;

    if (usageData) {
      usageData.forEach((row: any) => {
        mCount += row.sent_count;
        if (row.date === todayIso) {
          dCount += row.sent_count;
        }
      });
    }
    const { count: profilesCount } = await supabase
      .from("profiles")
      .select("*", { count: "exact", head: true })
      .eq("newsletter_opt_in", true);

    const { count: anonCount } = await (supabase as any)
      .from("newsletter_subscribers")
      .select("*", { count: "exact", head: true });

    setSentThisMonth(mCount);
    setSentToday(dCount);
    setTotalContacts((profilesCount || 0) + (anonCount || 0));
  }, []);

  useEffect(() => {
    loadDrafts();
    loadLimits();
  }, [loadDrafts, loadLimits]);

  const toggleProduct = (productId: string) => {
    setSelectedProducts(prev =>
      prev.includes(productId)
        ? prev.filter(id => id !== productId)
        : [...prev, productId]
    );
  };

  const loadSubscribers = async () => {
    const { data: profilesData, error: profilesError } = await supabase
      .from("profiles")
      .select("user_id, full_name, newsletter_opt_in")
      .eq("newsletter_opt_in", true);

    const { data: anonData, error: anonError } = await (supabase as any)
      .from("newsletter_subscribers")
      .select("email, created_at");

    const subs = [];
    if (!profilesError && profilesData) {
      subs.push(...profilesData.map(p => ({ user_id: p.user_id, full_name: p.full_name || p.user_id })));
    }
    if (!anonError && anonData) {
      subs.push(...anonData.map((a: any) => ({ user_id: a.email, full_name: a.email })));
    }

    setSubscribers(subs);
    setShowSubscribers(true);
  };

  // ── Save draft (new or update existing) ──
  const handleSaveDraft = async () => {
    if (!subject.trim()) {
      toast.error("O assunto é obrigatório.");
      return;
    }

    setSaving(true);
    try {
      if (editingDraftId) {
        // Update existing draft
        const { error } = await (supabase as any)
          .from("newsletters")
          .update({ subject, html_content: content })
          .eq("id", editingDraftId);
        if (error) throw error;

        // Update associated products
        await (supabase as any)
          .from("newsletter_products")
          .delete()
          .eq("newsletter_id", editingDraftId);

        if (selectedProducts.length > 0) {
          const pivotData = selectedProducts.map(productId => ({
            newsletter_id: editingDraftId,
            product_id: productId
          }));
          await (supabase as any).from("newsletter_products").insert(pivotData);
        }

        toast.success("Rascunho atualizado!");
      } else {
        // Create new draft
        const { data: newsletter, error: newsletterError } = await (supabase as any)
          .from("newsletters")
          .insert({ subject, html_content: content, status: "draft" })
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

        toast.success("Rascunho salvo!");
      }

      resetForm();
      loadDrafts();
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : "Erro desconhecido";
      toast.error("Erro ao salvar: " + message);
    } finally {
      setSaving(false);
    }
  };

  const resetForm = () => {
    setSubject("");
    setContent("<p>Olá,</p><p>Confira nossas ofertas imperdíveis desta semana!</p>");
    setSelectedProducts([]);
    setEditingDraftId(null);
  };

  // ── Load draft into form for editing ──
  const editDraft = async (draft: Draft) => {
    setEditingDraftId(draft.id);
    setSubject(draft.subject);
    setContent(draft.html_content || "");

    // Load associated products
    const { data: pivotData } = await (supabase as any)
      .from("newsletter_products")
      .select("product_id")
      .eq("newsletter_id", draft.id);

    setSelectedProducts((pivotData || []).map((p: any) => p.product_id));
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  // ── Delete draft ──
  const deleteDraft = async (id: string) => {
    if (!confirm("Excluir este rascunho?")) return;
    try {
      const { error } = await (supabase as any)
        .from("newsletters")
        .delete()
        .eq("id", id);
      if (error) throw error;
      toast.success("Rascunho excluído.");
      setSelectedDrafts(prev => prev.filter(d => d !== id));
      loadDrafts();
      if (editingDraftId === id) resetForm();
    } catch { toast.error("Erro ao excluir rascunho."); }
  };

  // ── Revert queued draft to draft status ──
  const revertDraft = async (id: string) => {
    try {
      await (supabase as any).from("email_queue").delete().eq("newsletter_id", id);
      await (supabase as any).from("newsletters").update({ status: "draft" }).eq("id", id);
      toast.success("Newsletter revertida para rascunho.");
      loadDrafts();
    } catch { toast.error("Erro ao reverter."); }
  };

  // ── Reschedule queued draft ──
  const rescheduleDraft = async (id: string, newDate: string) => {
    try {
      await (supabase as any).from("email_queue").update({ scheduled_at: newDate }).eq("newsletter_id", id);
      toast.success("Data reagendada.");
      loadDrafts();
    } catch { toast.error("Erro ao reagendar."); }
  };

  // ── Adjust Limits ──
  const handleAjustarDiario = async () => {
    const val = prompt("Quantos e-mails foram contabilizados HOJE no painel da Resend?", sentToday.toString());
    if (val === null) return;
    const num = parseInt(val, 10);
    if (isNaN(num) || num < 0) return;
    const todayIso = new Date().toISOString().split("T")[0];
    try {
      await (supabase as any).from("resend_usage_logs").upsert({ date: todayIso, sent_count: num });
      toast.success("Limite diário atualizado!");
      loadLimits();
    } catch { toast.error("Erro ao atualizar!"); }
  };

  const handleAjustarMes = async () => {
    const val = prompt("Deseja inserir envios externos manuais neste mês? Informe a quantidade a ser somada (ficará no dia 1):", "0");
    if (val === null) return;
    const num = parseInt(val, 10);
    if (isNaN(num) || num < 0) return;
    const startObj = new Date();
    startObj.setDate(1);
    const firstDayIso = startObj.toISOString().split("T")[0];
    try {
      await (supabase as any).from("resend_usage_logs").upsert({ date: firstDayIso, sent_count: num });
      toast.success("Base mensal do mês atualizada!");
      loadLimits();
    } catch { toast.error("Erro ao atualizar!"); }
  };

  const handleLogoUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!file.type.startsWith("image/")) {
      toast.error("O arquivo precisa ser uma imagem.");
      return;
    }
    setIsUploadingLogo(true);
    try {
      const ext = file.name.split(".").pop() || "png";
      const fileName = `newsletter-logo-${Date.now()}.${ext}`;
      const { error: uploadError } = await supabase.storage
        .from("banners")
        .upload(fileName, file, { contentType: file.type });
      if (uploadError) throw uploadError;
      const { data: urlData } = supabase.storage.from("banners").getPublicUrl(fileName);
      const url = urlData.publicUrl;
      const { error: settingsError } = await (supabase as any).from("admin_settings").upsert(
        { key: "newsletter_logo_url", value: url },
        { onConflict: "key" }
      );
      if (settingsError) throw settingsError;
      setNewsletterLogoUrl(url);
      toast.success("Logo atualizado com sucesso!");
    } catch (err) {
      console.error(err);
      toast.error("Erro ao enviar logo.");
    } finally {
      setIsUploadingLogo(false);
      if (fileInputRef.current) fileInputRef.current.value = "";
    }
  };

  // ── Toggle draft selection for sending ──
  const toggleDraftSelection = (id: string) => {
    setSelectedDrafts(prev =>
      prev.includes(id) ? prev.filter(d => d !== id) : [...prev, id]
    );
  };

  const selectAllDrafts = () => {
    const draftIds = drafts.filter(d => d.status === "draft").map(d => d.id);
    if (selectedDrafts.length === draftIds.length) {
      setSelectedDrafts([]);
    } else {
      setSelectedDrafts(draftIds);
    }
  };

  // ── Send selected drafts to queue ──
  const handleSendSelectedToQueue = async () => {
    if (selectedDrafts.length === 0) {
      toast.error("Selecione ao menos um rascunho.");
      return;
    }

    setSendingQueue(true);
    try {
      // Get subscribers
      const { data: subsProfiles } = await supabase
        .from("profiles")
        .select("user_id, full_name")
        .eq("newsletter_opt_in", true);

      const { data: subsAnon } = await (supabase as any)
        .from("newsletter_subscribers")
        .select("id, email");

      const profilesList = subsProfiles || [];
      const anonList = subsAnon || [];

      if (profilesList.length === 0 && anonList.length === 0) {
        toast.error("Nenhum assinante encontrado.");
        setSendingQueue(false);
        return;
      }

      // Modern Email Template Builder
      const buildModernEmailHTML = (draftContent: string, productsHTML: string, recipientName: string, recipientRef: string) => {
        const publicUrl = window.location.origin;

        const logoHtml = newsletterLogoUrl
          ? `<img src="${newsletterLogoUrl}" alt="OfertaShop" style="display:block; margin: 0 auto; max-width: 100%; max-height: 146px; object-fit: contain;">`
          : `<h2 style="margin: 0; color: #ffffff; font-size: 26px; font-weight: bold; letter-spacing: -0.5px;">OfertaShop</h2>`;

        return `
          <div style="font-family: 'Inter', 'Helvetica Neue', Helvetica, Arial, sans-serif; max-width: 650px; margin: 0 auto; background-color: #ffffff; padding: 0; overflow: hidden; color: #333;">
            
            <!-- Header -->
            <div style="background-color: ${newsletterLogoUrl ? '#ffffff' : '#ea580c'}; padding: 30px; text-align: center; ${newsletterLogoUrl ? 'border-bottom: 3px solid #ea580c;' : ''}">
              ${logoHtml}
            </div>
      
            <!-- Main Content -->
            <div style="padding: 40px 30px;">
              <h3 style="color: #ea580c; margin-top: 0; font-size: 20px;">Olá, ${recipientName}! 👋</h3>
              <div style="color: #475569; line-height: 1.6; font-size: 16px; margin-bottom: 30px;">
                ${draftContent}
              </div>
              
              ${productsHTML ? `
                <div style="margin-top: 30px;">
                  ${productsHTML}
                </div>
              ` : ''}
            </div>
      
            <!-- Footer -->
            <div style="background-color: #fff7ed; padding: 30px; text-align: center; font-size: 13px; color: #ea580c; border-top: 1px solid #fed7aa;">
              <p style="margin: 0 0 10px;">Você está recebendo este e-mail porque assinou a newsletter da OfertaShop.</p>
              <p style="margin: 0;">
                 <a href="${publicUrl}/unsubscribe?id=${encodeURIComponent(recipientRef)}" style="color: #ea580c; text-decoration: underline; font-weight: 600;">Cancelar Inscrição (Unsubscribe)</a>
              </p>
            </div>
          </div>
        `;
      };

      let totalQueued = 0;

      for (const draftId of selectedDrafts) {
        const draft = drafts.find(d => d.id === draftId);
        if (!draft || draft.status !== "draft") continue;

        // Load products for this draft
        const { data: pivotData } = await (supabase as any)
          .from("newsletter_products")
          .select("product_id")
          .eq("newsletter_id", draftId);

        const draftProductIds = (pivotData || []).map((p: any) => p.product_id);
        const draftProducts = products.filter(p => draftProductIds.includes(p.id));

        // Build product HTML
        const productsHTML = draftProducts.length > 0 ? `
          <table width="100%" cellpadding="0" cellspacing="0" style="margin-top: 20px; border-collapse: separate; border-spacing: 0 20px;">
            ${draftProducts.map((p) => {
          const img = p.image_url || 'https://via.placeholder.com/150';
          const price = Number(p.price).toFixed(2).replace('.', ',');
          return `
                <tr>
                  <td style="border: 1px solid #e2e8f0; border-radius: 12px; background-color: #ffffff; padding: 0; box-shadow: 0 2px 8px rgba(0,0,0,0.02);">
                    <table width="100%" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="160" style="background-color: #fff7ed; padding: 20px; text-align: center; vertical-align: middle; border-right: 1px solid #fed7aa; border-radius: 12px 0 0 12px;">
                          <img src="${img}" alt="${p.title}" style="width: 120px; max-height: 120px; object-fit: contain; border-radius: 8px;">
                        </td>
                        <td style="padding: 24px; text-align: left; vertical-align: middle;">
                          <h4 style="margin: 0 0 8px; font-size: 15px; color: #1e293b; line-height: 1.4;">${p.title}</h4>
                          <p style="margin: 0 0 16px; font-size: 20px; font-weight: bold; color: #ea580c;">R$ ${price}</p>
                          <a href="${p.affiliate_url}" style="display: inline-block; padding: 12px 24px; background-color: #ea580c; color: #ffffff; text-decoration: none; border-radius: 8px; font-size: 14px; font-weight: 600; box-shadow: 0 4px 6px -1px rgba(234, 88, 12, 0.2), 0 2px 4px -2px rgba(234, 88, 12, 0.1);">
                            Aproveitar Oferta →
                          </a>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              `;
        }).join('')}
          </table>
        ` : "";

        const fullHtml = (draft.html_content || "") + productsHTML;

        const queueData: any[] = [];

        profilesList.forEach(sub => {
          const finalHtml = buildModernEmailHTML(
            draft.html_content || "",
            productsHTML,
            sub.full_name || "Cliente",
            sub.user_id
          );
          queueData.push({
            user_id: sub.user_id,
            newsletter_id: draftId,
            subject: draft.subject,
            html_content: finalHtml,
            status: "pending",
            scheduled_at: scheduledAt ? new Date(scheduledAt).toISOString() : null
          });
        });

        anonList.forEach((sub: any) => {
          const finalHtml = buildModernEmailHTML(
            draft.html_content || "",
            productsHTML,
            "Cliente",
            sub.id
          );
          queueData.push({
            customer_email: sub.email,
            newsletter_id: draftId,
            subject: draft.subject,
            html_content: finalHtml,
            status: "pending",
            scheduled_at: scheduledAt ? new Date(scheduledAt).toISOString() : null
          });
        });

        const { error: queueError } = await (supabase as any)
          .from("email_queue")
          .insert(queueData);

        if (queueError) throw queueError;

        // Update draft status to queued
        await (supabase as any)
          .from("newsletters")
          .update({ status: "queued" })
          .eq("id", draftId);

        totalQueued += profilesList.length + anonList.length;
      }

      toast.success(
        <div className="flex items-center gap-2">
          <Check className="w-4 h-4 text-success" />
          <span><strong>{totalQueued}</strong> e-mails adicionados à fila de {selectedDrafts.length} newsletter(s)!</span>
        </div>
      );

      setSelectedDrafts([]);
      setScheduledAt("");
      loadDrafts();

      // Automatically trigger the edge function
      handleProcessQueue();

    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : "Erro desconhecido";
      toast.error("Erro ao enviar para fila: " + message);
    } finally {
      setSendingQueue(false);
    }
  };

  const handleProcessQueue = async () => {
    setIsProcessingQueue(true);
    try {
      const { data, error } = await supabase.functions.invoke("send-newsletter");
      if (error) throw error;

      const res = data as { success: boolean, processed: number, sent?: number, failed?: number, message?: string };
      if (res.processed > 0) {
        toast.success(`Fila processada! ${res.sent || 0} enviados, ${res.failed || 0} falhas de ${res.processed} tentados.`);
        loadDrafts(); // Refresh queue stats
      } else {
        toast.info(res.message || "Nenhum e-mail pendente na fila.");
      }
    } catch (err: any) {
      console.error("Erro ao processar fila:", err);
      toast.error("Erro ao invocar o processador de fila.");
    } finally {
      setIsProcessingQueue(false);
    }
  };

  // ── Product preview HTML for current form ──
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

  const statusLabel = (s: string) => {
    switch (s) {
      case "draft": return { text: "Rascunho", cls: "bg-amber-500/10 text-amber-600 border-amber-500/20" };
      case "queued": return { text: "Na Fila", cls: "bg-blue-500/10 text-blue-600 border-blue-500/20" };
      case "sent": return { text: "Enviado", cls: "bg-emerald-500/10 text-emerald-600 border-emerald-500/20" };
      default: return { text: s, cls: "bg-secondary text-muted-foreground" };
    }
  };

  const draftCount = drafts.filter(d => d.status === "draft").length;

  return (
    <div className="space-y-8">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-display font-bold text-foreground">Criador de Newsletters</h2>
          <p className="text-muted-foreground mt-1">Monte e-mails com ofertas, salve rascunhos e envie para a fila.</p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={handleProcessQueue}
            disabled={isProcessingQueue}
            className="flex items-center gap-2 text-sm px-4 py-2 rounded-lg bg-accent/10 border border-accent/20 text-accent hover:bg-accent/20 transition-colors disabled:opacity-50"
            aria-label="Processar Fila"
          >
            <Send className="w-4 h-4" /> {isProcessingQueue ? "Processando..." : "Processar Fila Pendente"}
          </button>
          <button onClick={loadSubscribers} className="flex items-center gap-2 text-sm px-4 py-2 rounded-lg bg-secondary hover:bg-secondary/80 text-foreground transition-colors border border-border" aria-label="Ver assinantes">
            <Users className="w-4 h-4" /> Assinantes
          </button>
        </div>
      </div>

      {showSubscribers && (
        <div className="bg-card border border-border rounded-xl p-5 shadow-sm relative">
          <button onClick={() => setShowSubscribers(false)} className="absolute top-4 right-4 p-1 hover:bg-secondary rounded">
            <X className="w-4 h-4" />
          </button>
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

      {/* ═══ RESEND LIMITS ═══ */}
      <div className="border border-border/50 bg-secondary/20 rounded-xl p-5 pb-6">
        <h3 className="text-sm font-semibold mb-4 flex items-center gap-2">
          Limites de Uso (Resend Plano Gratuito)
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="space-y-2">
            <div className="flex justify-between items-center text-sm">
              <span className="text-muted-foreground flex items-center gap-1">
                Transacional (Diário)
                <button onClick={handleAjustarDiario} className="p-0.5 hover:bg-black/10 rounded cursor-pointer" title="Ajustar Contagem">
                  <Settings2 className="w-3 h-3 text-muted-foreground" />
                </button>
              </span>
              <span className="font-bold">{sentToday} <span className="text-muted-foreground font-normal">/ 100</span></span>
            </div>
            <div className="h-2 w-full bg-secondary rounded-full overflow-hidden">
              <div className={`h-full ${sentToday > 90 ? 'bg-destructive' : 'bg-blue-500'}`} style={{ width: `${Math.min((sentToday / 100) * 100, 100)}%` }} />
            </div>
          </div>

          <div className="space-y-2">
            <div className="flex justify-between items-center text-sm">
              <span className="text-muted-foreground flex items-center gap-1">
                Transacional (Mensal)
                <button onClick={handleAjustarMes} className="p-0.5 hover:bg-black/10 rounded cursor-pointer" title="Adicionar Extras">
                  <Settings2 className="w-3 h-3 text-muted-foreground" />
                </button>
              </span>
              <span className="font-bold">{sentThisMonth} <span className="text-muted-foreground font-normal">/ 3.000</span></span>
            </div>
            <div className="h-2 w-full bg-secondary rounded-full overflow-hidden">
              <div className={`h-full ${sentThisMonth > 2800 ? 'bg-destructive' : 'bg-emerald-500'}`} style={{ width: `${Math.min((sentThisMonth / 3000) * 100, 100)}%` }} />
            </div>
          </div>

          <div className="space-y-2">
            <div className="flex justify-between items-center text-sm">
              <span className="text-muted-foreground">Marketing (Contatos)</span>
              <span className="font-bold">{totalContacts} <span className="text-muted-foreground font-normal">/ 1.000</span></span>
            </div>
            <div className="h-2 w-full bg-secondary rounded-full overflow-hidden">
              <div className={`h-full ${totalContacts > 950 ? 'bg-destructive' : 'bg-indigo-500'}`} style={{ width: `${Math.min((totalContacts / 1000) * 100, 100)}%` }} />
            </div>
          </div>
        </div>
      </div>

      {/* ═══ FORM ═══ */}
      <div className="grid lg:grid-cols-2 gap-8">
        <div className="space-y-6">
          <div className="bg-card border border-border rounded-xl p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="font-semibold flex items-center gap-2">
                <FileText className="w-4 h-4" />
                {editingDraftId ? "Editando Rascunho" : "Nova Newsletter"}
              </h3>
              <div className="flex items-center gap-2">
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  onChange={handleLogoUpload}
                  className="hidden"
                />
                <button
                  type="button"
                  onClick={() => fileInputRef.current?.click()}
                  disabled={isUploadingLogo}
                  className="text-xs flex items-center gap-1.5 px-3 py-1.5 bg-secondary hover:bg-secondary/80 rounded-md border text-muted-foreground transition-colors disabled:opacity-50"
                  title="A imagem será usada no cabeçalho das Newsletters."
                >
                  {isUploadingLogo ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Upload className="w-3.5 h-3.5" />}
                  {newsletterLogoUrl ? "Trocar Logo" : "Upload Logo"}
                </button>
                {editingDraftId && (
                  <button onClick={resetForm} className="text-xs text-muted-foreground hover:text-foreground transition-colors">
                    ← Cancelar edição
                  </button>
                )}
              </div>
            </div>
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
            <div className="pb-10">
              <label className="block text-sm font-medium mb-1">Conteúdo do E-mail</label>
              <div className="text-foreground bg-secondary rounded-lg overflow-hidden border border-transparent focus-within:ring-2 focus-within:ring-accent/30">
                <ReactQuill
                  theme="snow"
                  value={content}
                  onChange={(val: string) => setContent(val)}
                  className="min-h-[200px]"
                />
              </div>
            </div>
          </div>

          <div className="bg-card border border-border rounded-xl p-5 shadow-sm space-y-4 h-[400px] flex flex-col">
            <div className="flex items-center justify-between">
              <h3 className="font-semibold flex items-center gap-2"><PackageSearch className="w-4 h-4" /> Selecionar Produtos ({selectedProducts.length})</h3>
              {selectedProducts.length > 0 && (
                <button onClick={clearSelectedProducts} className="text-xs text-destructive hover:underline flex items-center gap-1">
                  <X className="w-3 h-3" /> Remover Todos
                </button>
              )}
            </div>

            <div className="flex gap-2">
              <div className="relative flex-1">
                <Search className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                <input
                  type="text"
                  value={searchProduct}
                  onChange={e => setSearchProduct(e.target.value)}
                  placeholder="Buscar produto..."
                  className="w-full h-9 pl-9 pr-3 rounded-md border border-input bg-background text-sm"
                />
              </div>
              <select
                value={storeFilter}
                onChange={e => setStoreFilter(e.target.value)}
                className="h-9 px-3 rounded-md border border-input bg-background text-sm"
              >
                <option value="">Todas as Lojas</option>
                {stores.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>

            <div className="flex-1 overflow-y-auto space-y-2 pr-2">
              {isLoading && <p className="text-sm text-muted-foreground">Carregando produtos...</p>}
              {filteredProducts.map(p => {
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
                  <Save className="w-4 h-4" /> {saving ? "Salvando..." : editingDraftId ? "Atualizar Rascunho" : "Salvar Rascunho"}
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

      {/* ═══ DRAFTS LIST ═══ */}
      <div className="bg-card border border-border rounded-xl shadow-sm overflow-hidden">
        <button
          onClick={() => setShowDrafts(!showDrafts)}
          className="w-full flex items-center justify-between p-5 hover:bg-secondary/30 transition-colors"
        >
          <h3 className="font-semibold flex items-center gap-2">
            <InboxIcon className="w-4 h-4" />
            Rascunhos & Newsletters ({drafts.length})
          </h3>
          {showDrafts ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
        </button>

        <AnimatePresence>
          {showDrafts && (
            <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden">
              {/* Bulk actions bar */}
              {draftCount > 0 && (
                <div className="flex items-center gap-3 px-5 py-3 bg-secondary/50 border-t border-border">
                  <button onClick={selectAllDrafts} className="text-xs text-accent hover:underline">
                    {selectedDrafts.length === draftCount ? "Desmarcar todos" : "Selecionar todos os rascunhos"}
                  </button>
                  {selectedDrafts.length > 0 && (
                    <div className="ml-auto flex items-center gap-3">
                      <div className="flex flex-col items-start gap-1">
                        <span className="text-[10px] uppercase font-bold text-muted-foreground mr-1">Agendar:</span>
                        <input
                          type="datetime-local"
                          value={scheduledAt}
                          onChange={(e) => setScheduledAt(e.target.value)}
                          className="h-9 px-2 text-xs border border-border rounded bg-background"
                        />
                      </div>
                      <button
                        onClick={handleSendSelectedToQueue}
                        disabled={sendingQueue}
                        className="flex items-center gap-2 px-4 py-2 mt-4 rounded-lg bg-success text-success-foreground text-sm font-medium disabled:opacity-50 hover:bg-success/90 transition-colors"
                      >
                        <Send className="w-4 h-4" />
                        {sendingQueue ? "Processando..." : (scheduledAt ? `Agendar ${selectedDrafts.length} Newsletter(s)` : `Enviar ${selectedDrafts.length} para Fila`)}
                      </button>
                    </div>
                  )}
                </div>
              )}

              {loadingDrafts ? (
                <div className="p-8 text-center text-muted-foreground">Carregando...</div>
              ) : drafts.length === 0 ? (
                <div className="p-8 text-center text-muted-foreground">Nenhum rascunho salvo ainda.</div>
              ) : (
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-t border-border bg-secondary">
                      <th className="w-10 p-4"></th>
                      <th className="text-left p-4 font-semibold text-foreground">Assunto</th>
                      <th className="text-center p-4 font-semibold text-foreground hidden sm:table-cell">Status</th>
                      <th className="text-left p-4 font-semibold text-foreground hidden md:table-cell">Data</th>
                      <th className="text-right p-4 font-semibold text-foreground">Ações</th>
                    </tr>
                  </thead>
                  <tbody>
                    {drafts.map((d) => {
                      const st = statusLabel(d.status);
                      const isDraft = d.status === "draft";
                      return (
                        <tr key={d.id} className={`border-t border-border hover:bg-secondary/50 transition-colors ${editingDraftId === d.id ? "bg-accent/5" : ""}`}>
                          <td className="p-4 text-center">
                            {isDraft && (
                              <input
                                type="checkbox"
                                checked={selectedDrafts.includes(d.id)}
                                onChange={() => toggleDraftSelection(d.id)}
                                className="w-4 h-4 rounded border-input accent-accent cursor-pointer"
                              />
                            )}
                          </td>
                          <td className="p-4 text-foreground font-medium">
                            <span className={editingDraftId === d.id ? "text-accent" : ""}>{d.subject}</span>
                          </td>
                          <td className="p-4 text-center hidden sm:table-cell">
                            <div className="flex flex-col items-center gap-1.5">
                              <span className={`text-xs px-2 py-1 rounded-full border ${st.cls}`}>{st.text}</span>
                              {queueStats[d.id] && (
                                <>
                                  {queueStats[d.id].scheduledAt && (
                                    <span className="text-[10px] bg-secondary text-secondary-foreground border border-border px-2 py-0.5 rounded flex items-center gap-1 whitespace-nowrap">
                                      <Calendar className="w-3 h-3" />
                                      {new Date(queueStats[d.id].scheduledAt!).toLocaleString("pt-BR", { dateStyle: "short", timeStyle: "short" })}
                                    </span>
                                  )}
                                  <div className="text-[10px] text-muted-foreground flex gap-2 font-medium">
                                    {queueStats[d.id].pending > 0 && <span className="text-amber-500" title="Pendentes">{queueStats[d.id].pending} P</span>}
                                    {queueStats[d.id].sent > 0 && <span className="text-emerald-500" title="Enviados">{queueStats[d.id].sent} S</span>}
                                    {queueStats[d.id].failed > 0 && <span className="text-destructive" title="Falhas">{queueStats[d.id].failed} F</span>}
                                  </div>
                                </>
                              )}
                            </div>
                          </td>
                          <td className="p-4 text-muted-foreground hidden md:table-cell">
                            {new Date(d.created_at).toLocaleDateString("pt-BR", { day: "2-digit", month: "short", year: "numeric" })}
                          </td>
                          <td className="p-4 text-right">
                            <div className="flex items-center justify-end gap-1">
                              {d.status === "queued" && (
                                <div className="flex flex-col gap-1.5 items-end mr-4">
                                  <div className="flex gap-1 items-center">
                                    <input
                                      type="datetime-local"
                                      className="text-[10px] border border-border rounded px-1.5 h-6 bg-background text-foreground"
                                      value={rescheduleData[d.id] || ""}
                                      onChange={e => setRescheduleData({ ...rescheduleData, [d.id]: e.target.value })}
                                      title="Reagendar Data/Hora"
                                    />
                                    <button
                                      onClick={() => rescheduleDraft(d.id, rescheduleData[d.id])}
                                      disabled={!rescheduleData[d.id]}
                                      className="h-6 px-2 bg-primary text-primary-foreground text-[10px] font-medium rounded hover:opacity-90 disabled:opacity-50"
                                    >
                                      OK
                                    </button>
                                  </div>
                                  <button
                                    onClick={() => revertDraft(d.id)}
                                    className="text-[10px] font-medium text-amber-600 hover:text-amber-700 underline underline-offset-2"
                                  >
                                    Voltar p/ Rascunho
                                  </button>
                                </div>
                              )}
                              {isDraft && (
                                <button onClick={() => editDraft(d)} className="p-2 rounded-lg hover:bg-secondary transition-colors" aria-label="Editar rascunho">
                                  <Pencil className="w-4 h-4 text-muted-foreground" />
                                </button>
                              )}
                              <button onClick={() => deleteDraft(d.id)} className="p-2 rounded-lg hover:bg-destructive/10 transition-colors" aria-label="Excluir rascunho">
                                <Trash2 className="w-4 h-4 text-destructive" />
                              </button>
                            </div>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              )}
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
};

export default AdminNewsletters;
