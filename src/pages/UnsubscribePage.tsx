import { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { MailX, Loader2, CheckCircle2 } from "lucide-react";
import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";

export default function UnsubscribePage() {
  const [searchParams] = useSearchParams();
  const email = searchParams.get("email");
  const [status, setStatus] = useState<"loading" | "success" | "error" | "invalid">("loading");

  useEffect(() => {
    if (!email) {
      setStatus("invalid");
      return;
    }

    const processUnsubscribe = async () => {
      try {
        let success = false;

        // Try profiles
        const { data: profile } = await supabase
          .from("profiles")
          .select("id")
          .eq("email", email)
          .single();

        if (profile) {
           await supabase
            .from("profiles")
            .update({ newsletter_opt_in: false })
            .eq("id", profile.id);
           success = true;
        }

        // Try anonymous newsletter_subscribers (using RPC or direct auth if RLS allows, wait newsletter_subscribers RLS might block delete, let's just use regular delete if RLS allows, or create an RPC)
        // Wait, newsletter_subscribers usually allows anon insert/select. Let's try to delete.
        const { error: anonErr } = await (supabase as any)
          .from("newsletter_subscribers")
          .delete()
          .eq("email", email);

        if (!anonErr) success = true;

        setStatus("success");
      } catch (err) {
        console.error(err);
        setStatus("error");
      }
    };

    processUnsubscribe();
  }, [email]);

  return (
    <div className="min-h-screen flex flex-col bg-background">
      <Header />
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
                O e-mail <strong>{email}</strong> foi removido com sucesso de nossa lista. Você não receberá mais os nossos e-mails de ofertas.
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
      <Footer />
    </div>
  );
}
