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

export const useUpdateBrand = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name }: { id: string; name: string }) => {
      const { error } = await supabase.from("brands").update({ name }).eq("id", id);
      if (error) throw error;
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

export const useUpdateModel = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name, brand_id }: { id: string; name?: string; brand_id?: string }) => {
      const updates: Record<string, any> = {};
      if (name !== undefined) updates.name = name;
      if (brand_id !== undefined) updates.brand_id = brand_id;
      const { error } = await supabase.from("models").update(updates).eq("id", id);
      if (error) throw error;
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

export const useUpdatePlatform = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name, logo_url }: { id: string; name?: string; logo_url?: string | null }) => {
      const updates: Record<string, any> = {};
      if (name !== undefined) updates.name = name;
      if (logo_url !== undefined) updates.logo_url = logo_url;
      const { error } = await supabase.from("platforms").update(updates).eq("id", id);
      if (error) throw error;
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

export const useUpdateCategory = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, name, slug, icon }: { id: string; name?: string; slug?: string; icon?: string | null }) => {
      const updates: Record<string, any> = {};
      if (name !== undefined) updates.name = name;
      if (slug !== undefined) updates.slug = slug;
      if (icon !== undefined) updates.icon = icon;
      const { error } = await supabase.from("categories").update(updates).eq("id", id);
      if (error) throw error;
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

// ─── Institutional Pages ───
export const useInstitutionalPages = () =>
  useQuery({
    queryKey: ["institutional_pages"],
    queryFn: async () => {
      const { data, error } = await (supabase as any).from("institutional_pages").select("*").order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

export const useActiveInstitutionalPages = () =>
  useQuery({
    queryKey: ["active_institutional_pages"],
    queryFn: async () => {
      const { data, error } = await (supabase as any).from("institutional_pages").select("*").eq("active", true).order("title");
      if (error) throw error;
      return data;
    },
  });

export const useCreateInstitutionalPage = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (page: { title: string; slug: string; content_html?: string; active?: boolean; section_type?: string }) => {
      const { data, error } = await (supabase as any).from("institutional_pages").insert(page).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["institutional_pages"] });
      qc.invalidateQueries({ queryKey: ["active_institutional_pages"] });
    },
  });
};

export const useUpdateInstitutionalPage = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...updates }: { id: string; active?: boolean; title?: string; slug?: string; content_html?: string; section_type?: string }) => {
      const { error } = await (supabase as any).from("institutional_pages").update(updates).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["institutional_pages"] });
      qc.invalidateQueries({ queryKey: ["active_institutional_pages"] });
    },
  });
};

export const useDeleteInstitutionalPage = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await (supabase as any).from("institutional_pages").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["institutional_pages"] });
      qc.invalidateQueries({ queryKey: ["active_institutional_pages"] });
    },
  });
};

// ─── Coupons ───
export const useCoupons = () =>
  useQuery({
    queryKey: ["coupons"],
    queryFn: async () => {
      const { data, error } = await (supabase as any).from("coupons").select("*, platforms(name)").order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

export const useActiveCoupons = (platformId?: string | null) =>
  useQuery({
    queryKey: ["active_coupons", platformId],
    queryFn: async () => {
      if (!platformId) return [];
      const { data, error } = await (supabase as any)
        .from("coupons")
        .select("*")
        .eq("active", true)
        .eq("platform_id", platformId)
        .order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
    enabled: !!platformId,
  });

export const useCreateCoupon = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (coupon: any) => {
      const { data, error } = await (supabase as any).from("coupons").insert(coupon).select().single();
      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["coupons"] });
      qc.invalidateQueries({ queryKey: ["active_coupons"] });
    },
  });
};

export const useUpdateCoupon = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ id, ...updates }: any) => {
      const { error } = await (supabase as any).from("coupons").update(updates).eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["coupons"] });
      qc.invalidateQueries({ queryKey: ["active_coupons"] });
    },
  });
};

export const useDeleteCoupon = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await (supabase as any).from("coupons").delete().eq("id", id);
      if (error) throw error;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ["coupons"] });
      qc.invalidateQueries({ queryKey: ["active_coupons"] });
    },
  });
};

export const useCouponStats = (couponId: string) =>
  useQuery({
    queryKey: ["coupon_stats", couponId],
    queryFn: async () => {
      const { data, error } = await (supabase as any).from("coupon_votes").select("is_working").eq("coupon_id", couponId);
      if (error) throw error;
      const total = data.length;
      const working = data.filter((v: any) => v.is_working).length;
      return { total, working, percentage: total > 0 ? Math.round((working / total) * 100) : 0 };
    },
    enabled: !!couponId,
  });

export const useVoteCoupon = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ couponId, isWorking, sessionToken }: { couponId: string; isWorking: boolean; sessionToken: string | null }) => {
      const { error } = await (supabase as any).from("coupon_votes").upsert({
        coupon_id: couponId,
        is_working: isWorking,
        session_token: sessionToken || crypto.randomUUID()
      }, { onConflict: "coupon_id,session_token" });
      if (error) throw error;
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ["coupon_stats", variables.couponId] });
    },
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

export const useActiveWhatsAppGroups = () =>
  useQuery({
    queryKey: ["whatsapp_group_active"],
    queryFn: async () => {
      const { data, error } = await supabase.from("whatsapp_groups").select("*").eq("active", true).order("created_at", { ascending: false });
      if (error) throw error;
      return data;
    },
  });

export const useCreateWhatsAppGroup = () => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async ({ name, link, active }: { name: string; link: string; active?: boolean }) => {
      const { data, error } = await (supabase as any).from("whatsapp_groups").insert({ name, link, active: active || false }).select().single();
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
    mutationFn: async ({ id, ...updates }: { id: string; name?: string; link?: string; active?: boolean }) => {
      const { error } = await (supabase as any).from("whatsapp_groups").update(updates).eq("id", id);
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
    mutationFn: async ({ userId, productId, isWished, currentPrice }: { userId: string; productId: string; isWished: boolean; currentPrice?: number }) => {
      if (isWished) {
        const { error } = await supabase.from("wishlists").delete().eq("user_id", userId).eq("product_id", productId);
        if (error) throw error;
      } else {
        const insertData: any = { user_id: userId, product_id: productId };
        if (currentPrice !== undefined) insertData.price_when_favorited = currentPrice;
        const { error } = await (supabase as any).from("wishlists").insert(insertData);
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

// ─── Trust Votes by Platform (for admin stats) ───
export const useTrustVotesByPlatform = () =>
  useQuery({
    queryKey: ["trust_votes_by_platform"],
    queryFn: async () => {
      // Get all trust votes with their product's platform_id
      const { data: votes, error } = await (supabase as any)
        .from("product_trust_votes")
        .select("is_trusted, products!inner(platform_id)");
      if (error) throw error;

      // Get clicks per product
      const { data: clicks, error: clicksErr } = await (supabase as any)
        .from("product_clicks")
        .select("product_id, products!inner(platform_id)");
      if (clicksErr) throw clicksErr;

      return { votes: votes || [], clicks: clicks || [] };
    },
  });
