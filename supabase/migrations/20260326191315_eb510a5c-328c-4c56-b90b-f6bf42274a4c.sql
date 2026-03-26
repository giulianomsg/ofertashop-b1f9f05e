
-- 1. New table: admin_settings
CREATE TABLE IF NOT EXISTS public.admin_settings (
  key text NOT NULL,
  value jsonb NOT NULL,
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT admin_settings_pkey PRIMARY KEY (key)
);
ALTER TABLE public.admin_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin can manage admin_settings" ON public.admin_settings FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));

-- 2. New table: amazon_product_mappings
CREATE TABLE IF NOT EXISTS public.amazon_product_mappings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid REFERENCES public.products(id),
  amazon_item_id character varying NOT NULL UNIQUE,
  amazon_current_price numeric,
  amazon_original_price numeric,
  amazon_status character varying,
  amazon_rating numeric,
  amazon_review_count integer,
  last_synced_at timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT amazon_product_mappings_pkey PRIMARY KEY (id)
);
ALTER TABLE public.amazon_product_mappings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin_Editor can manage amazon mappings" ON public.amazon_product_mappings FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));
CREATE POLICY "Anyone can view amazon mappings" ON public.amazon_product_mappings FOR SELECT TO public USING (true);

-- 3. New table: search_cache
CREATE TABLE IF NOT EXISTS public.search_cache (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  keyword text NOT NULL,
  offset_val integer NOT NULL,
  data jsonb NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  expires_at timestamp with time zone DEFAULT (now() + '24:00:00'::interval),
  CONSTRAINT search_cache_pkey PRIMARY KEY (id)
);
ALTER TABLE public.search_cache ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin can manage search_cache" ON public.search_cache FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'::app_role)) WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Anyone can view search_cache" ON public.search_cache FOR SELECT TO public USING (true);
CREATE POLICY "Anyone can insert search_cache" ON public.search_cache FOR INSERT TO public WITH CHECK (true);

-- 4. Add new columns to products
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS category_id uuid REFERENCES public.categories(id);
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS external_id character varying;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS commission_rate numeric;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS sales_count integer DEFAULT 0;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS features jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS available_quantity integer;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS extra_metadata jsonb DEFAULT '{}'::jsonb;

-- 5. Add new columns to coupons
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS link_url text;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS updated_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now());

-- 6. Add new columns to shopee_product_mappings
ALTER TABLE public.shopee_product_mappings ADD COLUMN IF NOT EXISTS offer_valid_from timestamp with time zone;
ALTER TABLE public.shopee_product_mappings ADD COLUMN IF NOT EXISTS offer_valid_to timestamp with time zone;
ALTER TABLE public.shopee_product_mappings ADD COLUMN IF NOT EXISTS shopee_extra_data jsonb DEFAULT '{}'::jsonb;
