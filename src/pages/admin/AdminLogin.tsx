import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { ShoppingBag, Mail, Lock, User as UserIcon, Eye, EyeOff } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { lovable } from "@/integrations/lovable";
import { toast } from "sonner";

const AdminLogin = () => {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [fullName, setFullName] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const { signIn, signUp, signInWithGoogle } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    if (isLogin) {
      const { error } = await signIn(email, password);
      if (error) {
        toast.error(error.message);
      } else {
        toast.success("Login realizado com sucesso!");
        navigate("/admin");
      }
    } else {
      const { error } = await signUp(email, password, fullName);
      if (error) {
        toast.error(error.message);
      } else {
        toast.success("Cadastro realizado! Verifique seu email para confirmar.");
      }
    }
    setLoading(false);
  };

  const handleGoogleLogin = async () => {
    setLoading(true);
    const result = await lovable.auth.signInWithOAuth("google", {
      redirect_uri: window.location.origin,
    });
    if (result?.error) {
      toast.error(result.error.message);
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background flex items-center justify-center px-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-md"
      >
        <div className="text-center mb-8">
          <div className="w-12 h-12 rounded-xl bg-accent flex items-center justify-center mx-auto mb-4">
            <ShoppingBag className="w-6 h-6 text-accent-foreground" />
          </div>
          <h1 className="font-display font-bold text-2xl text-foreground">
            Oferta<span className="gradient-text">Shop</span>
          </h1>
          <p className="text-sm text-muted-foreground mt-1">Central de Administração</p>
        </div>

        <div
          className="bg-card rounded-2xl border border-border p-6 space-y-5"
          style={{ boxShadow: "var(--shadow-elevated)" }}
        >
          <div className="flex gap-1 bg-secondary rounded-lg p-1">
            <button
              onClick={() => setIsLogin(true)}
              className={`flex-1 py-2 rounded-md text-sm font-medium transition-all ${isLogin ? "bg-card text-foreground shadow-sm" : "text-muted-foreground"
                }`}
            >
              Entrar
            </button>
            <button
              onClick={() => setIsLogin(false)}
              className={`flex-1 py-2 rounded-md text-sm font-medium transition-all ${!isLogin ? "bg-card text-foreground shadow-sm" : "text-muted-foreground"
                }`}
            >
              Cadastrar
            </button>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            {!isLogin && (
              <div className="text-xs text-muted-foreground bg-accent/10 p-3 rounded-lg border border-accent/20 mb-4">
                <strong>Atenção:</strong> Novos registros criam perfis com acesso comum. Para privilégios administrativos, contate o administrador.
              </div>
            )}
            {!isLogin && (
              <div>
                <label className="text-xs font-semibold text-foreground mb-1.5 block">Nome Completo</label>
                <div className="relative">
                  <UserIcon className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <input
                    type="text"
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    placeholder="Seu nome"
                    required={!isLogin}
                    className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                  />
                </div>
              </div>
            )}
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Email</label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="seu@email.com"
                  required
                  className="w-full h-10 pl-10 pr-4 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                />
              </div>
            </div>
            <div>
              <label className="text-xs font-semibold text-foreground mb-1.5 block">Senha</label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                <input
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  required
                  minLength={6}
                  className="w-full h-10 pl-10 pr-10 rounded-lg bg-secondary border-none text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-accent/30"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2"
                >
                  {showPassword ? (
                    <EyeOff className="w-4 h-4 text-muted-foreground" />
                  ) : (
                    <Eye className="w-4 h-4 text-muted-foreground" />
                  )}
                </button>
              </div>
            </div>
            <button
              type="submit"
              disabled={loading}
              className="btn-accent w-full disabled:opacity-50"
            >
              {loading ? "Aguarde..." : isLogin ? "Entrar" : "Criar Conta"}
            </button>

            <div className="relative flex items-center py-2">
              <div className="flex-grow border-t border-border"></div>
              <span className="flex-shrink-0 mx-4 text-muted-foreground text-xs">ou</span>
              <div className="flex-grow border-t border-border"></div>
            </div>

            <button
              type="button"
              onClick={handleGoogleLogin}
              disabled={loading}
              className="w-full h-10 flex items-center justify-center gap-2 rounded-lg bg-card border border-border text-sm font-medium text-foreground hover:bg-secondary transition-colors disabled:opacity-50"
            >
              <svg viewBox="0 0 24 24" className="w-4 h-4" aria-hidden="true">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4" />
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
              </svg>
              Entrar com Google
            </button>
          </form>
        </div>
      </motion.div>
    </div>
  );
};

export default AdminLogin;
