-- Add enrichment columns to products table
ALTER TABLE public.products
ADD COLUMN IF NOT EXISTS commission_rate numeric,
ADD COLUMN IF NOT EXISTS sales_count integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS features jsonb DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS available_quantity integer;
