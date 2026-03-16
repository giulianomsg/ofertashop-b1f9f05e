
-- =====================================================================
-- MEGA MIGRATION: All missing tables, columns, triggers, RLS, and RPC
-- =====================================================================

-- 1. Add 'name' column to whatsapp_groups (missing)
ALTER TABLE public.whatsapp_groups ADD COLUMN IF NOT EXISTS name text DEFAULT '';

-- 2. Add price_when_favorited to wishlists
ALTER TABLE public.wishlists ADD COLUMN IF NOT EXISTS price_when_favorited numeric;

-- 3. Create institutional_pages table
CREATE TABLE IF NOT EXISTS public.institutional_pages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  content_html text DEFAULT '',
  section_type varchar DEFAULT 'support',
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.institutional_pages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active institutional pages" ON public.institutional_pages
  FOR SELECT TO public USING (active = true OR has_role(auth.uid(), 'admin'));

CREATE POLICY "Admin can manage institutional pages" ON public.institutional_pages
  FOR ALL TO authenticated USING (has_role(auth.uid(), 'admin'))
  WITH CHECK (has_role(auth.uid(), 'admin'));

-- 4. Create coupons table
CREATE TABLE IF NOT EXISTS public.coupons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  platform_id uuid REFERENCES public.platforms(id) ON DELETE SET NULL,
  title varchar NOT NULL DEFAULT '',
  code varchar NOT NULL DEFAULT '',
  discount_amount varchar,
  discount_value varchar,
  subtitle varchar,
  conditions text,
  is_link_only boolean DEFAULT false,
  reports_inactive integer DEFAULT 0,
  description text,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active coupons" ON public.coupons
  FOR SELECT TO public USING (active = true OR has_role(auth.uid(), 'admin'));

CREATE POLICY "Admin/Editor can manage coupons" ON public.coupons
  FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin') OR has_role(auth.uid(), 'editor'))
  WITH CHECK (has_role(auth.uid(), 'admin') OR has_role(auth.uid(), 'editor'));

-- 5. Create coupon_votes table
CREATE TABLE IF NOT EXISTS public.coupon_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id uuid REFERENCES public.coupons(id) ON DELETE CASCADE NOT NULL,
  session_token text NOT NULL,
  is_working boolean NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(coupon_id, session_token)
);

ALTER TABLE public.coupon_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view coupon votes" ON public.coupon_votes
  FOR SELECT TO public USING (true);

CREATE POLICY "Anyone can insert coupon votes" ON public.coupon_votes
  FOR INSERT TO public WITH CHECK (true);

-- 6. Create product_trust_votes table
CREATE TABLE IF NOT EXISTS public.product_trust_votes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  session_token text,
  is_trusted boolean NOT NULL DEFAULT true,
  created_at timestamptz DEFAULT now(),
  UNIQUE(product_id, user_id)
);

ALTER TABLE public.product_trust_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view trust votes" ON public.product_trust_votes
  FOR SELECT TO public USING (true);

CREATE POLICY "Authenticated can insert trust votes" ON public.product_trust_votes
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Authenticated can update own trust votes" ON public.product_trust_votes
  FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Authenticated can delete own trust votes" ON public.product_trust_votes
  FOR DELETE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Anon can insert trust votes with session" ON public.product_trust_votes
  FOR INSERT TO anon WITH CHECK (user_id IS NULL AND session_token IS NOT NULL);

-- 7. Create product_clicks table
CREATE TABLE IF NOT EXISTS public.product_clicks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  session_token text,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.product_clicks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view clicks" ON public.product_clicks
  FOR SELECT TO public USING (true);

CREATE POLICY "Authenticated can insert clicks" ON public.product_clicks
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Anon can insert clicks" ON public.product_clicks
  FOR INSERT TO anon WITH CHECK (true);

-- 8. Create price_history table
CREATE TABLE IF NOT EXISTS public.price_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
  price numeric NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.price_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view price history" ON public.price_history
  FOR SELECT TO public USING (true);

CREATE POLICY "System can insert price history" ON public.price_history
  FOR INSERT TO public WITH CHECK (true);

-- Price history trigger function
CREATE OR REPLACE FUNCTION public.track_price_history()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = 'public'
AS $$
BEGIN
  IF TG_OP = 'INSERT' OR (OLD.price IS DISTINCT FROM NEW.price) OR (OLD.original_price IS DISTINCT FROM NEW.original_price) THEN
    INSERT INTO public.price_history (product_id, price)
    VALUES (NEW.id, COALESCE(LEAST(NEW.price, COALESCE(NEW.original_price, NEW.price)), NEW.price));
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_track_price_history ON public.products;
CREATE TRIGGER trg_track_price_history
  AFTER INSERT OR UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.track_price_history();

-- Re-create the discount trigger (was missing from DB triggers list)
DROP TRIGGER IF EXISTS trg_calc_discount ON public.products;
CREATE TRIGGER trg_calc_discount
  BEFORE INSERT OR UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.calc_discount_percentage();

-- Re-create enforce single whatsapp trigger
DROP TRIGGER IF EXISTS trg_enforce_single_active_whatsapp ON public.whatsapp_groups;
CREATE TRIGGER trg_enforce_single_active_whatsapp
  BEFORE INSERT OR UPDATE ON public.whatsapp_groups
  FOR EACH ROW EXECUTE FUNCTION public.enforce_single_active_whatsapp();

-- Re-create handle_new_user trigger
DROP TRIGGER IF EXISTS trg_handle_new_user ON auth.users;
CREATE TRIGGER trg_handle_new_user
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Re-create updated_at trigger on products
DROP TRIGGER IF EXISTS trg_update_updated_at ON public.products;
CREATE TRIGGER trg_update_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 9. Create newsletters table
CREATE TABLE IF NOT EXISTS public.newsletters (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subject varchar NOT NULL,
  html_content text,
  status varchar DEFAULT 'draft',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.newsletters ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage newsletters" ON public.newsletters
  FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'))
  WITH CHECK (has_role(auth.uid(), 'admin'));

-- 10. Create newsletter_products pivot table
CREATE TABLE IF NOT EXISTS public.newsletter_products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  newsletter_id uuid REFERENCES public.newsletters(id) ON DELETE CASCADE NOT NULL,
  product_id uuid REFERENCES public.products(id) ON DELETE CASCADE NOT NULL
);

ALTER TABLE public.newsletter_products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage newsletter products" ON public.newsletter_products
  FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'))
  WITH CHECK (has_role(auth.uid(), 'admin'));

-- 11. Create email_queue table
CREATE TABLE IF NOT EXISTS public.email_queue (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  subject varchar NOT NULL,
  html_content text,
  status varchar DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.email_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admin can manage email queue" ON public.email_queue
  FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'))
  WITH CHECK (has_role(auth.uid(), 'admin'));

-- 12. Generate price alerts RPC function
CREATE OR REPLACE FUNCTION public.generate_price_alerts()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = 'public'
AS $$
DECLARE
  rec RECORD;
  alert_count integer := 0;
  current_price numeric;
  product_title text;
BEGIN
  FOR rec IN
    SELECT w.user_id, w.product_id, w.price_when_favorited
    FROM public.wishlists w
    WHERE w.price_when_favorited IS NOT NULL
  LOOP
    SELECT 
      COALESCE(LEAST(p.price, COALESCE(p.original_price, p.price)), p.price),
      p.title
    INTO current_price, product_title
    FROM public.products p
    WHERE p.id = rec.product_id AND p.is_active = true;

    IF current_price IS NOT NULL AND current_price < rec.price_when_favorited THEN
      -- Check if alert already sent recently (last 24h)
      IF NOT EXISTS (
        SELECT 1 FROM public.email_queue eq
        WHERE eq.user_id = rec.user_id
          AND eq.subject LIKE '%' || product_title || '%'
          AND eq.created_at > now() - interval '24 hours'
      ) THEN
        INSERT INTO public.email_queue (user_id, subject, html_content)
        VALUES (
          rec.user_id,
          'Alerta de Preço: ' || product_title || ' está mais barato!',
          '<h2>O produto que você favoritou baixou de preço!</h2>' ||
          '<p><strong>' || product_title || '</strong></p>' ||
          '<p>Preço quando você favoritou: R$ ' || rec.price_when_favorited::text || '</p>' ||
          '<p>Preço atual: R$ ' || current_price::text || '</p>' ||
          '<p>Você economiza: R$ ' || (rec.price_when_favorited - current_price)::text || '</p>'
        );
        alert_count := alert_count + 1;
      END IF;
    END IF;
  END LOOP;

  RETURN alert_count;
END;
$$;
