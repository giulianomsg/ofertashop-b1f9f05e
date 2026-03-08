import type { Tables } from "@/integrations/supabase/types";

export type Product = Tables<"products">;

export const categories = [
  "Todos",
  "Eletrônicos",
  "Wearables",
  "Áudio",
  "Periféricos",
  "Acessórios",
  "Casa & Decoração",
  "Esportes",
];
