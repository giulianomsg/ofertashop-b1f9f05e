import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

// ─── Brands ───
export const useBrands = () =>
  useQuery({
    queryKey: ["brands"],
    queryFn: async () => {
      const { data, error } = await supabase.from("brands").select("*").order("name");
      if (error) throw error;
      return data;
    },
  });

export const useCreateBrand = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (name: string) => {
      const { data, error } = await supabase.from("brands").insert({ name }).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["brands"] }),
  });
};

export const useDeleteBrand = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("brands").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["brands"] }),
  });
};

// ─── Models ───
export const useModels = (brandId?: string) =>
  useQuery({
    queryKey: ["models", brandId],
    queryFn: async () => {
      let q = supabase.from("models").select("*, brands(name)").order("name");
      if (brandId) q = q.eq("brand_id", brandId);
      const { data, error } = await q;
      if (error) throw error;
      return data;
    },
  });

export const useCreateModel = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ brand_id, name }: { brand_id: string; name: string }) => {
      const { data, error } = await supabase.from("models").insert({ brand_id, name }).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["models"] }),
  });
};

export const useDeleteModel = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("models").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["models"] }),
  });
};

// ─── Platforms ───
export const usePlatforms = () =>
  useQuery({
    queryKey: ["platforms"],
    queryFn: async () => {
      const { data, error } = await supabase.from("platforms").select("*").order("name");
      if (error) throw error;
      return data;
    },
  });

export const useCreatePlatform = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ name, logo_url }: { name: string; logo_url?: string }) => {
      const { data, error } = await supabase.from("platforms").insert({ name, logo_url: logo_url || null }).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["platforms"] }),
  });
};

export const useDeletePlatform = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("platforms").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["platforms"] }),
  });
};

// ─── Categories ───
export const useCategories = () =>
  useQuery({
    queryKey: ["categories"],
    queryFn: async () => {
      const { data, error } = await supabase.from("categories").select("*").order("name");
      if (error) throw error;
      return data;
    },
  });

export const useCreateCategory = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ name, slug, icon }: { name: string; slug: string; icon?: string }) => {
      const { data, error } = await supabase.from("categories").insert({ name, slug, icon: icon || null }).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["categories"] }),
  });
};

export const useDeleteCategory = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("categories").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["categories"] }),
  });
};

// ─── Special Pages ───
export const useSpecialPages = () =>
  useQuery({
    queryKey: ["special_pages"],
    queryFn: async () => {
      const { data, error } = await supabase.from("special_pages").select("*").order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

export const useCreateSpecialPage = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (page: { title: string; slug: string; description?: string; active?: boolean }) => {
      const { data, error } = await supabase.from("special_pages").insert(page).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["special_pages"] }),
  });
};

export const useUpdateSpecialPage = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...updates }: { id: string; active?: boolean; title?: string; slug?: string; description?: string }) => {
      const { error } = await supabase.from("special_pages").update(updates).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["special_pages"] }),
  });
};

export const useDeleteSpecialPage = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("special_pages").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["special_pages"] }),
  });
};

// ─── WhatsApp Groups ───
export const useWhatsAppGroups = () =>
  useQuery({
    queryKey: ["whatsapp_groups"],
    queryFn: async () => {
      const { data, error } = await supabase.from("whatsapp_groups").select("*").order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

export const useActiveWhatsAppGroup = () =>
  useQuery({
    queryKey: ["whatsapp_group_active"],
    queryFn: async () => {
      const { data, error } = await supabase.from("whatsapp_groups").select("*").eq("active", true).maybeSingle();
      if (error) throw error;
      return data;
    },
  });

export const useCreateWhatsAppGroup = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ link, active }: { link: string; active?: boolean }) => {
      const { data, error } = await supabase.from("whatsapp_groups").insert({ link, active: active || false }).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["whatsapp_groups"] });
      qc.invalidateQueries({ queryKey: ["whatsapp_group_active"] });
    },
  });
};

export const useUpdateWhatsAppGroup = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...updates }: { id: string; link?: string; active?: boolean }) => {
      const { error } = await supabase.from("whatsapp_groups").update(updates).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["whatsapp_groups"] });
      qc.invalidateQueries({ queryKey: ["whatsapp_group_active"] });
    },
  });
};

export const useDeleteWhatsAppGroup = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from("whatsapp_groups").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["whatsapp_groups"] });
      qc.invalidateQueries({ queryKey: ["whatsapp_group_active"] });
    },
  });
};

// ─── Wishlists & Likes ───
export const useWishlist = (userId?: string) =>
  useQuery({
    queryKey: ["wishlist", userId],
    queryFn: async () => {
      if (!userId) return [];
      const { data, error } = await supabase.from("wishlists").select("product_id").eq("user_id", userId);
      if (error) throw error;
      return data.map((w) => w.product_id);
    },
    enabled: !!userId,
  });

export const useToggleWishlist = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ userId, productId, isWished }: { userId: string; productId: string; isWished: boolean }) => {
      if (isWished) {
        const { error } = await supabase.from("wishlists").delete().eq("user_id", userId).eq("product_id", productId);
        if (error) throw error;
      } else {
        const { error } = await supabase.from("wishlists").insert({ user_id: userId, product_id: productId });
        if (error) throw error;
      }
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ["wishlist"] }),
  });
};

export const useProductLikes = (productId?: string) =>
  useQuery({
    queryKey: ["product_likes", productId],
    queryFn: async () => {
      if (!productId) return { count: 0, userLiked: false };
      const { count, error } = await supabase.from("product_likes").select("*", { count: "exact", head: true }).eq("product_id", productId);
      if (error) throw error;
      return { count: count || 0 };
    },
    enabled: !!productId,
  });

export const useUserLiked = (userId?: string, productId?: string) =>
  useQuery({
    queryKey: ["user_liked", userId, productId],
    queryFn: async () => {
      if (!userId || !productId) return false;
      const { data, error } = await supabase.from("product_likes").select("id").eq("user_id", userId).eq("product_id", productId).maybeSingle();
      if (error) throw error;
      return !!data;
    },
    enabled: !!userId && !!productId,
  });

export const useToggleLike = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ userId, productId, isLiked }: { userId: string; productId: string; isLiked: boolean }) => {
      if (isLiked) {
        const { error } = await supabase.from("product_likes").delete().eq("user_id", userId).eq("product_id", productId);
        if (error) throw error;
      } else {
        const { error } = await supabase.from("product_likes").insert({ user_id: userId, product_id: productId });
        if (error) throw error;
      }
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["product_likes"] });
      qc.invalidateQueries({ queryKey: ["user_liked"] });
    },
  });
};

// ─── Active Special Pages (for footer) ───
export const useActiveSpecialPages = () =>
  useQuery({
    queryKey: ["active_special_pages"],
    queryFn: async () => {
      const { data, error } = await supabase.from("special_pages").select("*").eq("active", true).order("title");
      if (error) throw error;
      return data;
    },
  });
