import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import type { Tables, TablesInsert, TablesUpdate } from "@/integrations/supabase/types";
import { createClient } from "@supabase/supabase-js";

export type Product = Tables<"products">;

export const useProducts = (activeOnly = true) => {
  return useQuery({
    queryKey: ["products", activeOnly],
    queryFn: async () => {
      let query = supabase.from("products").select("*").order("created_at", { ascending: false });
      if (activeOnly) {
        query = query.eq("is_active", true);
      }
      const { data, error } = await query;
      if (error) throw error;
      return data as Product[];
    },
  });
};

export const useProduct = (id: string | undefined) => {
  return useQuery({
    queryKey: ["product", id],
    queryFn: async () => {
      if (!id) return null;
      const { data, error } = await supabase.from("products").select("*").eq("id", id).maybeSingle();
      if (error) throw error;
      return data as Product | null;
    },
    enabled: !!id,
  });
};

export const useCreateProduct = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (product: TablesInsert<"products">) => {
      const { data, error } = await supabase.from("products").insert(product).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["products"] }),
  });
};

export const useUpdateProduct = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...updates }: TablesUpdate<"products"> & { id: string }) => {
      const { data, error } = await supabase.from("products").update(updates).eq("id", id).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["products"] }),
  });
};

export const useDeleteProduct = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("products").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["products"] }),
  });
};

export const useReviews = (productId: string | undefined) => {
  return useQuery({
    queryKey: ["reviews", productId],
    queryFn: async () => {
      if (!productId) return [];
      const { data, error } = await supabase
        .from("reviews")
        .select("*")
        .eq("product_id", productId)
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
    enabled: !!productId,
  });
};

export const useReports = () => {
  return useQuery({
    queryKey: ["reports"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("reports")
        .select("*, products(title)")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });
};

export const useCollaborators = () => {
  return useQuery({
    queryKey: ["collaborators"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("user_roles")
        .select("*, profiles(full_name, avatar_url, user_id, is_active)");
      if (error) throw error;
      return data;
    },
  });
};

export const useUpdateCollaboratorRole = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ userId, role }: { userId: string, role: "admin" | "editor" | "viewer" }) => {
      const { error } = await supabase.from("user_roles").update({ role }).eq("user_id", userId);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["collaborators"] }),
  });
};

export const useRemoveCollaborator = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (userId: string) => {
      // Remove da tabela user_roles e insere back como 'viewer'
      const { error } = await supabase.from("user_roles").update({ role: "viewer" }).eq("user_id", userId);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["collaborators"] }),
  });
};

export const useUsers = () => {
  return useQuery({
    queryKey: ["users"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("admin_users_view" as any)
        .select("*")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });
};

export const useUpdateUserStatus = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ userId, isActive }: { userId: string, isActive: boolean }) => {
      const { error } = await supabase.from("profiles").update({ is_active: isActive }).eq("user_id", userId);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["users"] }),
  });
};

export const useUpdateUserProfile = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ userId, fullName, email, role }: { userId: string, fullName: string, email?: string, role: string }) => {
      const { error: profileError } = await supabase
        .from("profiles")
        .update({ full_name: fullName })
        .eq("user_id", userId);
      if (profileError) throw profileError;

      const { error: roleError } = await supabase.rpc("admin_update_user_role" as any, {
        target_user_id: userId,
        new_role: role as any
      });
      if (roleError) throw roleError;

      if (email) {
        const { error: emailError } = await supabase.rpc("admin_update_user_email" as any, {
          target_user_id: userId,
          new_email: email
        });
        if (emailError) throw emailError;
      }
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["users"] }),
  });
};

export const useDeleteUser = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (userId: string) => {
      const { error } = await supabase.rpc("admin_delete_user" as any, {
        target_user_id: userId
      });
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["users"] }),
  });
};

const secondarySupabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY,
  { auth: { persistSession: false, autoRefreshToken: false } }
);

export const useCreateUser = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ email, password, fullName, role }: any) => {
      const { data, error } = await secondarySupabase.auth.signUp({
        email,
        password,
        options: {
          data: { full_name: fullName }
        }
      });
      if (error) throw error;

      const newUserId = data.user?.id;
      if (!newUserId) throw new Error("Falha ao criar usuário (sem ID retornado).");

      // wait a tiny bit for the triggers to insert the profile and default role
      await new Promise(resolve => setTimeout(resolve, 1000));

      const { error: roleError } = await supabase.rpc("admin_update_user_role" as any, {
        target_user_id: newUserId,
        new_role: role as any
      });
      if (roleError) throw roleError;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["users"] }),
  });
};

export const useAllReviews = () => {
  return useQuery({
    queryKey: ["all_reviews"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("reviews")
        .select("*, products(title)")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });
};

export const useUpdateReviewStatus = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, status }: { id: string, status: string }) => {
      const { error } = await supabase.from("reviews").update({ status }).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["all_reviews"] });
      qc.invalidateQueries({ queryKey: ["reviews"] });
    },
  });
};

export const useDeleteReview = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("reviews").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["all_reviews"] });
      qc.invalidateQueries({ queryKey: ["reviews"] });
    },
  });
};

export const usePriceHistory = (brandId?: string | null, modelId?: string | null) => {
  return useQuery({
    queryKey: ["price_history", brandId, modelId],
    queryFn: async () => {
      if (!brandId || !modelId) return [];
      const { data, error } = await supabase
        .from("price_history" as any)
        .select(`
          id, price, created_at,
          products!inner(brand_id, model_id, store, platform_id, title)
        `)
        .eq("products.brand_id", brandId)
        .eq("products.model_id", modelId)
        .order("created_at", { ascending: true });
        
      if (error) throw error;
      return data;
    },
    enabled: !!brandId && !!modelId,
  });
};

export const useAllTrustVotes = () =>
  useQuery({
    queryKey: ["all_trust_votes"],
    queryFn: async () => {
      const { data, error } = await supabase.from("product_trust_votes" as any).select("*").order("created_at", { ascending: true });
      if (error) throw error;
      return data;
    },
  });
