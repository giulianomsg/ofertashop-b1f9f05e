-- Migration: Add name to whatsapp_groups
ALTER TABLE public.whatsapp_groups ADD COLUMN name TEXT DEFAULT 'Geral' NOT NULL;

-- Migration: Update products table to use category_id
ALTER TABLE public.products ADD COLUMN category_id UUID REFERENCES public.categories(id);

-- Migrate data from category string to category_id
UPDATE public.products p
SET category_id = c.id
FROM public.categories c
WHERE p.category = c.name;

-- Drop old category column
ALTER TABLE public.products DROP COLUMN category;
