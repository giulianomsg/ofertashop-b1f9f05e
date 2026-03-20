-- Add sales_count to products table to track items sold from API
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS sales_count integer DEFAULT 0;
