import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Database } from "@/integrations/supabase/types";

type Banner = Database["public"]["Tables"]["banners"]["Row"];
type BannerInsert = Database["public"]["Tables"]["banners"]["Insert"];
type BannerUpdate = Database["public"]["Tables"]["banners"]["Update"];

export const useBanners = (activeOnly = true) => {
    return useQuery({
        queryKey: ["banners", activeOnly],
        queryFn: async () => {
            let query = supabase.from("banners").select("*").order("sort_order", { ascending: true });
            if (activeOnly) {
                query = query.eq("is_active", true);
            }
            const { data, error } = await query;
            if (error) throw error;
            return data as Banner[];
        },
    });
};

export const useCreateBanner = () => {
    const queryClient = useQueryClient();
    return useMutation({
        mutationFn: async (banner: BannerInsert) => {
            const { data, error } = await supabase.from("banners").insert(banner).select().single();
            if (error) throw error;
            return data;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["banners"] });
        },
    });
};

export const useUpdateBanner = () => {
    const queryClient = useQueryClient();
    return useMutation({
        mutationFn: async (banner: BannerUpdate & { id: string }) => {
            const { id, ...updateData } = banner;
            const { data, error } = await supabase.from("banners").update(updateData).eq("id", id).select().single();
            if (error) throw error;
            return data;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["banners"] });
        },
    });
};

export const useDeleteBanner = () => {
    const queryClient = useQueryClient();
    return useMutation({
        mutationFn: async (id: string) => {
            const { error } = await supabase.from("banners").delete().eq("id", id);
            if (error) throw error;
            return true;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["banners"] });
        },
    });
};
