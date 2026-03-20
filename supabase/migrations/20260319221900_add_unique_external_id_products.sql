-- Adiciona constraint único parcial em external_id para suportar UPSERT de ofertas Shopee
-- Apenas rows com external_id NOT NULL são afetados

CREATE UNIQUE INDEX IF NOT EXISTS uq_products_external_id
  ON public.products (external_id)
  WHERE external_id IS NOT NULL;
