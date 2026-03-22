import { createContext, useContext, useEffect, useState, ReactNode, useRef } from "react";
import { supabase } from "@/integrations/supabase/client";
import type { User, Session } from "@supabase/supabase-js";

interface AuthContextType {
  user: User | null;
  session: Session | null;
  loading: boolean;
  userRole: string | null;
  signIn: (email: string, password: string) => Promise<{ error: Error | null }>;
  signUp: (email: string, password: string, fullName: string) => Promise<{ error: Error | null }>;
  signInWithGoogle: () => Promise<{ error: Error | null }>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);
  const [userRole, setUserRole] = useState<string | null>(null);

  const [roleLoading, setRoleLoading] = useState(true);

  // Cache para evitar buscas repetidas do mesmo usuário
  const roleCache = useRef<Map<string, string | null>>(new Map());
  const isFetchingRole = useRef<Set<string>>(new Set());

  const fetchRole = async (userId: string) => {
    // Verificar cache primeiro
    if (roleCache.current.has(userId)) {
      setUserRole(roleCache.current.get(userId) ?? null);
      setRoleLoading(false);
      return;
    }

    // Evitar chamadas duplicadas para o mesmo usuário
    if (isFetchingRole.current.has(userId)) {
      return;
    }

    isFetchingRole.current.add(userId);
    setRoleLoading(true);

    try {
      const { data: roleData } = await supabase
        .from("user_roles")
        .select("role")
        .eq("user_id", userId)
        .maybeSingle();

      const { data: profileData } = await supabase
        .from("profiles")
        .select("is_active")
        .eq("user_id", userId)
        .maybeSingle();

      if (profileData && profileData.is_active === false) {
        await supabase.auth.signOut();
        setUser(null);
        setSession(null);
        setUserRole(null);
        roleCache.current.delete(userId);
        return;
      }

      const role = roleData?.role ?? null;
      setUserRole(role);
      roleCache.current.set(userId, role);
    } catch (error) {
      console.error("Error fetching role:", error);
      // Em caso de erro, mantemos o role como null para não travar a UI
      setUserRole(null);
      roleCache.current.set(userId, null);
    } finally {
      isFetchingRole.current.delete(userId);
      setRoleLoading(false);
    }
  };

  useEffect(() => {
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
      setUser(session?.user ?? null);
      if (session?.user) {
        // Usar setTimeout com delay 0 para não bloquear a thread principal
        // mas adicionamos um pequeno delay para evitar chamadas em sequência rápida
        setTimeout(() => fetchRole(session.user.id), 50);
      } else {
        setUserRole(null);
        setRoleLoading(false);
      }
      setLoading(false);
    });

    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      if (session?.user) {
        // Mesmo tratamento para a sessão inicial
        setTimeout(() => fetchRole(session.user.id), 50);
      } else {
        setRoleLoading(false);
      }
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    return { error: error as Error | null };
  };

  const signUp = async (email: string, password: string, fullName: string) => {
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: { full_name: fullName },
        emailRedirectTo: window.location.origin,
      },
    });
    return { error: error as Error | null };
  };

  const signInWithGoogle = async () => {
    const { error } = await supabase.auth.signInWithOAuth({ provider: 'google' });
    return { error: error as Error | null };
  };

  const signOut = async () => {
    await supabase.auth.signOut();
    // Limpar cache ao fazer logout
    roleCache.current.clear();
    isFetchingRole.current.clear();
  };

  return (
    <AuthContext.Provider value={{ user, session, loading: loading || roleLoading, userRole, signIn, signUp, signInWithGoogle, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
};
