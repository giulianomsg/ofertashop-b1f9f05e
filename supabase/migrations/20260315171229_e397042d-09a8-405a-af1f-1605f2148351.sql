
-- 1. New tables: brands, models, platforms, categories, special_pages, special_page_products, whatsapp_groups, wishlists, product_likes

-- BRANDS
CREATE TABLE public.brands (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view brands" ON public.brands FOR SELECT TO public USING (true);
CREATE POLICY "Admin/Editor can manage brands" ON public.brands FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor'));

-- MODELS
CREATE TABLE public.models (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id uuid NOT NULL REFERENCES public.brands(id) ON DELETE CASCADE,
  name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(brand_id, name)
);
ALTER TABLE public.models ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view models" ON public.models FOR SELECT TO public USING (true);
CREATE POLICY "Admin/Editor can manage models" ON public.models FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor'));

-- PLATFORMS
CREATE TABLE public.platforms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  logo_url text,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.platforms ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view platforms" ON public.platforms FOR SELECT TO public USING (true);
CREATE POLICY "Admin/Editor can manage platforms" ON public.platforms FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor'));

-- CATEGORIES (dynamic table replacing static enum)
CREATE TABLE public.categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  slug text NOT NULL UNIQUE,
  icon text,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view categories" ON public.categories FOR SELECT TO public USING (true);
CREATE POLICY "Admin/Editor can manage categories" ON public.categories FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor')) WITH CHECK (public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor'));

-- Seed default categories
INSERT INTO public.categories (name, slug) VALUES
  ('Eletrônicos', 'eletronicos'),
  ('Wearables', 'wearables'),
  ('Áudio', 'audio'),
  ('Periféricos', 'perifericos'),
  ('Acessórios', 'acessorios'),
  ('Casa & Decoração', 'casa-decoracao'),
  ('Esportes', 'esportes');

-- SPECIAL PAGES
CREATE TABLE public.special_pages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.special_pages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view active special pages" ON public.special_pages FOR SELECT TO public USING (active = true OR public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admin can manage special pages" ON public.special_pages FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- SPECIAL PAGE PRODUCTS (junction)
CREATE TABLE public.special_page_products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  special_page_id uuid NOT NULL REFERENCES public.special_pages(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  UNIQUE(special_page_id, product_id)
);
ALTER TABLE public.special_page_products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view special page products" ON public.special_page_products FOR SELECT TO public USING (true);
CREATE POLICY "Admin can manage special page products" ON public.special_page_products FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- WHATSAPP GROUPS
CREATE TABLE public.whatsapp_groups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  link text NOT NULL,
  active boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.whatsapp_groups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view active whatsapp groups" ON public.whatsapp_groups FOR SELECT TO public USING (active = true OR public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admin can manage whatsapp groups" ON public.whatsapp_groups FOR ALL TO authenticated USING (public.has_role(auth.uid(), 'admin')) WITH CHECK (public.has_role(auth.uid(), 'admin'));

-- WISHLISTS
CREATE TABLE public.wishlists (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, product_id)
);
ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own wishlist" ON public.wishlists FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- PRODUCT LIKES
CREATE TABLE public.product_likes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id uuid NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, product_id)
);
ALTER TABLE public.product_likes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own likes" ON public.product_likes FOR ALL TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Anyone can count likes" ON public.product_likes FOR SELECT TO public USING (true);

-- 2. ALTER profiles: add opt-in fields
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS price_alert_opt_in boolean NOT NULL DEFAULT false;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS newsletter_opt_in boolean NOT NULL DEFAULT false;

-- 3. ALTER products: add new FK columns, video_url, discount_percentage, registered_by
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS brand_id uuid REFERENCES public.brands(id) ON DELETE SET NULL;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS model_id uuid REFERENCES public.models(id) ON DELETE SET NULL;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS platform_id uuid REFERENCES public.platforms(id) ON DELETE SET NULL;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS video_url text;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS discount_percentage numeric;
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS registered_by uuid REFERENCES auth.users(id) ON DELETE SET NULL;

-- Trigger to auto-calculate discount_percentage
CREATE OR REPLACE FUNCTION public.calc_discount_percentage()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $$
BEGIN
  IF NEW.original_price IS NOT NULL AND NEW.original_price > 0 AND NEW.price IS NOT NULL THEN
    NEW.discount_percentage := ROUND(((NEW.original_price - NEW.price) / NEW.original_price) * 100, 1);
  ELSE
    NEW.discount_percentage := NULL;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_calc_discount
  BEFORE INSERT OR UPDATE ON public.products
  FOR EACH ROW
  EXECUTE FUNCTION public.calc_discount_percentage();

-- Trigger to enforce only one active whatsapp group
CREATE OR REPLACE FUNCTION public.enforce_single_active_whatsapp()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $$
BEGIN
  IF NEW.active = true THEN
    UPDATE public.whatsapp_groups SET active = false WHERE id != NEW.id AND active = true;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_single_active_whatsapp
  BEFORE INSERT OR UPDATE ON public.whatsapp_groups
  FOR EACH ROW
  EXECUTE FUNCTION public.enforce_single_active_whatsapp();
