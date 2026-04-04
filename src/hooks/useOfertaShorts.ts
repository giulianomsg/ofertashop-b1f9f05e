import { useState, useCallback, useRef } from "react";
import { supabase } from "@/integrations/supabase/client";
import type { Tables } from "@/integrations/supabase/types";

export type ShortProduct = Pick<
  Tables<"products">,
  "id" | "title" | "price" | "original_price" | "video_url" | "affiliate_url" | "image_url" | "discount_percentage"
>;

const PAGE_SIZE = 6;

export const useOfertaShorts = () => {
  const [items, setItems] = useState<ShortProduct[]>([]);
  const [loading, setLoading] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const offset = useRef(0);
  const fetching = useRef(false);

  const fetchNext = useCallback(async () => {
    if (fetching.current || !hasMore) return;
    fetching.current = true;
    setLoading(true);

    const { data, error } = await supabase
      .from("products")
      .select("id, title, price, original_price, video_url, affiliate_url, image_url, discount_percentage")
      .eq("is_active", true)
      .not("video_url", "is", null)
      .neq("video_url", "") // Filtro rigoroso para bloquear strings vazias
      .order("created_at", { ascending: true }) // Inverte a ordenação para mostrar o primeiro item indexado no topo
      .range(offset.current, offset.current + PAGE_SIZE - 1);

    if (!error && data) {
      setItems((prev) => {
        const ids = new Set(prev.map((p) => p.id));
        const unique = data.filter((d) => !ids.has(d.id));
        return [...prev, ...unique] as ShortProduct[];
      });
      if (data.length < PAGE_SIZE) setHasMore(false);
      offset.current += data.length;
    } else {
      setHasMore(false);
    }

    setLoading(false);
    fetching.current = false;
  }, [hasMore]);

  return { items, loading, hasMore, fetchNext };
};
