import { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { MailX, Loader2, CheckCircle2 } from "lucide-react";
import SiteHeader from "@/components/SiteHeader";
import SiteFooter from "@/components/SiteFooter";

export default function UnsubscribePage() {
  const [searchParams] = useSearchParams();
  const idParam = searchParams.get("id") || searchParams.get("email");
  const [status, setStatus] = useState<"loading" | "success" | "error" | "invalid">("loading");

  useEffect(() => {
    if (!idParam) {
      setStatus("invalid");
      return;
    }

    const processUnsubscribe = async () => {
      try {
        // Call the Security Definer RPC which bypasses RLS and can update both tables
        const { data, error } = await (supabase as any).rpc("unsubscribe_recipient", {
          recipient_ref: idParam
        });

        if (error || data === false) {
          throw new Error("Falha ao remover a inscrição.");
        }

        setStatus("success");
      } catch (err) {
        console.error("Erro no Unsubscribe:", err);
        setStatus("error");
      }
    };

    processUnsubscribe();
  }, [idParam]);

  return (
    <div className="min-h-screen flex flex-col bg-background">
      <SiteHeader />
      <main className="flex-1 flex flex-col items-center justify-center p-6">
        <div className="max-w-md w-full bg-card border border-border p-8 rounded-2xl shadow-sm text-center space-y-4">
          {status === "loading" && (
            <>
              <div className="w-16 h-16 bg-secondary rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
                <Loader2 className="w-8 h-8 text-muted-foreground animate-spin" />
              </div>
              <h2 className="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-primary to-accent">Processando...</h2>
              <p className="text-muted-foreground">Cancelando sua inscrição na newsletter.</p>
            </>
          )}

          {status === "success" && (
            <>
              <div className="w-16 h-16 bg-success/10 rounded-full flex items-center justify-center mx-auto mb-4">
                <CheckCircle2 className="w-8 h-8 text-success" />
              </div>
              <h2 className="text-xl font-bold">Inscrição Cancelada</h2>
              <p className="text-muted-foreground">
                Sua referência <strong>{idParam}</strong> foi removida com sucesso. Você não receberá mais os nossos e-mails de ofertas.
              </p>
            </>
          )}

          {status === "error" && (
            <>
              <div className="w-16 h-16 bg-destructive/10 rounded-full flex items-center justify-center mx-auto mb-4">
                <MailX className="w-8 h-8 text-destructive" />
              </div>
              <h2 className="text-xl font-bold">Erro ao processar</h2>
              <p className="text-muted-foreground">
                Ocorreu um erro ao tentar remover seu e-mail. Por favor, tente novamente mais tarde.
              </p>
            </>
          )}

          {status === "invalid" && (
            <>
              <div className="w-16 h-16 bg-destructive/10 rounded-full flex items-center justify-center mx-auto mb-4">
                <MailX className="w-8 h-8 text-destructive" />
              </div>
              <h2 className="text-xl font-bold">Link Inválido</h2>
              <p className="text-muted-foreground">
                Nenhum e-mail foi fornecido no link. Verifique se copiou o link corretamente do seu programa de e-mail.
              </p>
            </>
          )}

          <div className="pt-4 mt-6 border-t border-border">
             <a href="/" className="text-sm font-medium text-primary hover:underline">Voltar para a página inicial</a>
          </div>
        </div>
      </main>
      <SiteFooter />
    </div>
  );
}
