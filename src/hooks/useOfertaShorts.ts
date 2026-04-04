import { useState, useCallback, useRef } from "react";
import { supabase } from "@/integrations/supabase/client";
import type { Tables } from "@/integrations/supabase/types";

export type ShortProduct = Pick<
  Tables<"products">,
  "id" | "title" | "price" | "original_price" | "video_url" | "affiliate_url" | "image_url" | "discount_percentage" | "gallery_urls"
>;

// Adiciona chave única por ciclo para suportar loop infinito
export type FeedItem = ShortProduct & { _key: string };

const PAGE_SIZE = 6;

export const useOfertaShorts = () => {
  const [items, setItems] = useState<FeedItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [hasMore, setHasMore] = useState(true);
  const [isEmpty, setIsEmpty] = useState(false); // nenhum produto cadastrado
  const offset = useRef(0);
  const cycle = useRef(0);   // quantas vezes já voltou ao início
  const fetching = useRef(false);
  const totalFetched = useRef(0); // total de produtos únicos encontrados
  const loopCooldown = useRef(false); // bloqueia fetches imediatos após reset de ciclo

  const fetchNext = useCallback(async () => {
    // Bloqueia durante fetch ativo, sem mais itens, ou durante cooldown pós-ciclo
    if (fetching.current || !hasMore || loopCooldown.current) return;
    fetching.current = true;
    setLoading(true);

    const { data, error } = await supabase
      .from("products")
      .select("id, title, price, original_price, video_url, affiliate_url, image_url, discount_percentage, gallery_urls")
      .eq("is_active", true)
      .order("created_at", { ascending: true })
      .range(offset.current, offset.current + PAGE_SIZE - 1);

    if (!error && data) {
      if (data.length === 0 && cycle.current === 0) {
        // Nenhum produto no banco
        setIsEmpty(true);
        setHasMore(false);
      } else if (data.length === 0 || data.length < PAGE_SIZE) {
        // Chegou ao fim de um ciclo — reinicia do início
        const c = cycle.current;
        const newItems: FeedItem[] = (data ?? []).map((d) => ({
          ...(d as ShortProduct),
          _key: `${d.id}-${c}`,
        }));
        if (newItems.length > 0) {
          setItems((prev) => [...prev, ...newItems]);
          totalFetched.current += newItems.length;
        }
        // Reinicia offset e incrementa ciclo para o próximo fetch
        offset.current = 0;
        cycle.current += 1;
        // Cooldown: bloqueia novos fetches por 2.5s para deixar o DOM atualizar
        // e o sentinel sair da viewport antes de disparar novamente
        loopCooldown.current = true;
        setTimeout(() => { loopCooldown.current = false; }, 2500);
        // hasMore permanece true (loop contínuo)
        setHasMore(true);
      } else {
        // Página normal
        const c = cycle.current;
        const newItems: FeedItem[] = data.map((d) => ({
          ...(d as ShortProduct),
          _key: `${d.id}-${c}`,
        }));
        setItems((prev) => [...prev, ...newItems]);
        totalFetched.current += newItems.length;
        offset.current += data.length;
      }
    } else if (error) {
      // Erro de rede: não bloqueia o loop
      setHasMore(true);
    }

    setLoading(false);
    fetching.current = false;
  }, [hasMore]);

  return { items, loading, hasMore, isEmpty, fetchNext };
};
