-- Adiciona uma coluna JSON flexível para acomodar metadados das integrações (Meli+, Reputação, Variações)
ALTER TABLE public.products
ADD COLUMN IF NOT EXISTS extra_metadata jsonb DEFAULT '{}'::jsonb;
