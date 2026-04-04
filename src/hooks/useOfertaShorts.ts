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

  const productIds = useRef<string[]>([]);
  const isInitialized = useRef(false);

  const fetchNext = useCallback(async () => {
    // Bloqueia durante fetch ativo, sem mais itens, ou durante cooldown pós-ciclo
    if (fetching.current || !hasMore || loopCooldown.current) return;
    fetching.current = true;
    setLoading(true);

    try {
      // 1. Busca inicial de IDs de TODOS os produtos ativos + Embaralhamento Global
      if (!isInitialized.current) {
        const { data: allIdsRes, error: errIds } = await supabase
          .from("products")
          .select("id")
          .eq("is_active", true);
        
        if (errIds) throw errIds;
        
        if (!allIdsRes || allIdsRes.length === 0) {
          setIsEmpty(true);
          setHasMore(false);
          setLoading(false);
          fetching.current = false;
          return;
        }

        // Algoritmo Fisher-Yates (Embaralhamento)
        const ids = allIdsRes.map(p => p.id);
        for (let i = ids.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [ids[i], ids[j]] = [ids[j], ids[i]];
        }
        productIds.current = ids;
        isInitialized.current = true;
      }

      const totalActive = productIds.current.length;

      if (totalActive > 0) {
        // 2. Se atingimos o final do array embaralhado, reseta pro próximo ciclo com novo shuffle
        if (offset.current >= totalActive && cycle.current > 0) {
          // Reembaralhamos os ids pro próximo ciclo não ser idêntico
          const ids = [...productIds.current];
          for (let i = ids.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [ids[i], ids[j]] = [ids[j], ids[i]];
          }
          productIds.current = ids;
          offset.current = 0;
          cycle.current += 1;
          
          loopCooldown.current = true;
          setTimeout(() => { loopCooldown.current = false; }, 500);
          setHasMore(true); // confirma continuidade do loop
        }

        // Garante a subida do ciclo na primeira travessia terminante sem itens restantes pra processar
        if (offset.current >= totalActive && cycle.current === 0) {
           cycle.current = 1;
           offset.current = 0;
        }

        // 3. Pegamos a "página" (fatia) de IDs baseada no offset
        const chunk = productIds.current.slice(offset.current, offset.current + PAGE_SIZE);
        
        if (chunk.length > 0) {
          const { data, error } = await supabase
            .from("products")
            .select("id, title, price, original_price, video_url, affiliate_url, image_url, discount_percentage, gallery_urls")
            .in("id", chunk);

          if (!error && data) {
            const c = cycle.current;
            
            // O '.in("id", ...)' do Supabase não retorna a lista ordenada do jeito que passamos.
            // Precisamos reconectar no JavaScript a ordem dos IDs "embaralhados" (na variável chunk).
            const orderedData = chunk.map(id => data.find(d => d.id === id)).filter(Boolean) as ShortProduct[];

            const newItems: FeedItem[] = orderedData.map((d, index) => ({
              ...d,
              _key: `${d.id}-c${c}-off${offset.current + index}`, // Key ultra-blindada contra overlaps React
            }));
            
            setItems((prev) => [...prev, ...newItems]);
            totalFetched.current += newItems.length;
            offset.current += chunk.length;
          }
        }
      }
    } catch (error) {
      console.error("Erro na paginação do Shorts:", error);
      // Mantém hasMore pois foi só falha de network
    }

    setLoading(false);
    fetching.current = false;
  }, [hasMore]);

  return { items, loading, hasMore, isEmpty, fetchNext };
};
