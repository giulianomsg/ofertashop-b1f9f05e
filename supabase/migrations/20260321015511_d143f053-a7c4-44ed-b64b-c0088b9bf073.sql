-- Tabela para armazenar tokens OAuth do Mercado Livre
CREATE TABLE public.ml_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  access_token text NOT NULL,
  refresh_token text NOT NULL,
  expires_at timestamp with time zone NOT NULL,
  ml_user_id text,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

ALTER TABLE public.ml_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage ml_tokens"
  ON public.ml_tokens FOR ALL
  TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role));

-- Tabela de mapeamento ML → produtos locais
CREATE TABLE public.ml_product_mappings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  ml_item_id text NOT NULL UNIQUE,
  ml_permalink text,
  ml_category_id text,
  ml_seller_id text,
  ml_condition text,
  ml_sold_quantity integer DEFAULT 0,
  ml_available_quantity integer,
  ml_rating_average numeric,
  ml_rating_count integer DEFAULT 0,
  ml_status text DEFAULT 'active',
  ml_original_price numeric,
  ml_current_price numeric,
  ml_thumbnail text,
  sync_status text DEFAULT 'active',
  last_synced_at timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE public.ml_product_mappings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin_Editor can manage ml mappings"
  ON public.ml_product_mappings FOR ALL
  TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Anyone can view ml mappings"
  ON public.ml_product_mappings FOR SELECT
  TO public
  USING (true);

-- Tabela de logs de sync do ML
CREATE TABLE public.ml_sync_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sync_type text NOT NULL,
  status text NOT NULL DEFAULT 'running',
  items_processed integer DEFAULT 0,
  items_updated integer DEFAULT 0,
  items_deactivated integer DEFAULT 0,
  error_message text,
  triggered_by uuid,
  completed_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE public.ml_sync_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage ml sync logs"
  ON public.ml_sync_logs FOR ALL
  TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role));