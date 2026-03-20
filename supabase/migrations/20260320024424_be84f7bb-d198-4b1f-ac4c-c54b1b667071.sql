-- Shopee product mappings: track which products came from Shopee
CREATE TABLE IF NOT EXISTS public.shopee_product_mappings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  shopee_item_id text NOT NULL,
  shopee_shop_id text,
  shopee_offer_id text,
  shopee_commission_rate numeric,
  shopee_image_url text,
  shopee_product_url text,
  shopee_short_link text,
  last_synced_at timestamptz DEFAULT now(),
  sync_status text DEFAULT 'active',
  created_at timestamptz DEFAULT now(),
  CONSTRAINT shopee_product_mappings_item_unique UNIQUE (shopee_item_id)
);

-- Sync logs for audit trail
CREATE TABLE IF NOT EXISTS public.shopee_sync_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sync_type text NOT NULL,
  status text NOT NULL DEFAULT 'running',
  items_processed integer DEFAULT 0,
  items_updated integer DEFAULT 0,
  items_deactivated integer DEFAULT 0,
  error_message text,
  triggered_by uuid,
  created_at timestamptz DEFAULT now(),
  completed_at timestamptz
);

-- RLS policies
ALTER TABLE public.shopee_product_mappings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shopee_sync_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view shopee mappings" ON public.shopee_product_mappings
  FOR SELECT TO public USING (true);

CREATE POLICY "Admin_Editor can manage shopee mappings" ON public.shopee_product_mappings
  FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin') OR has_role(auth.uid(), 'editor'))
  WITH CHECK (has_role(auth.uid(), 'admin') OR has_role(auth.uid(), 'editor'));

CREATE POLICY "Admin can view sync logs" ON public.shopee_sync_logs
  FOR SELECT TO authenticated USING (has_role(auth.uid(), 'admin'));

CREATE POLICY "Admin can manage sync logs" ON public.shopee_sync_logs
  FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'))
  WITH CHECK (has_role(auth.uid(), 'admin'));

CREATE INDEX IF NOT EXISTS idx_shopee_mappings_item_id ON public.shopee_product_mappings(shopee_item_id);
CREATE INDEX IF NOT EXISTS idx_shopee_mappings_product_id ON public.shopee_product_mappings(product_id);
CREATE INDEX IF NOT EXISTS idx_shopee_sync_logs_created ON public.shopee_sync_logs(created_at DESC);