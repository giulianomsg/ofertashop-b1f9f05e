-- Adiciona coluna external_id à tabela products
-- Usada para armazenar o ID externo do produto na Shopee (sincronização de preços e stock)

ALTER TABLE public.products
  ADD COLUMN IF NOT EXISTS external_id VARCHAR;

-- Índice para buscas rápidas por external_id
CREATE INDEX IF NOT EXISTS idx_products_external_id
  ON public.products (external_id);

-- Comentário descritivo
COMMENT ON COLUMN public.products.external_id IS 'ID do produto na plataforma externa (ex.: Shopee) para sincronização';
