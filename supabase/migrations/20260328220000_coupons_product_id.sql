-- Migração: Adiciona coluna product_id opcional (pode ser NULL para cupons globais)
ALTER TABLE public.coupons 
ADD COLUMN IF NOT EXISTS product_id uuid REFERENCES public.products(id) ON DELETE CASCADE;

-- Criar índice para melhorar a performance de consultas por produto específico
CREATE INDEX IF NOT EXISTS idx_coupons_product_id ON public.coupons(product_id);
