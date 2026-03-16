-- Fix RLS for product_clicks and product_trust_votes to explicitly allow anon inserts
DROP POLICY IF EXISTS "Anyone can insert product clicks" ON public.product_clicks;
CREATE POLICY "Anyone can insert product clicks" ON public.product_clicks FOR INSERT TO public WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can view product clicks" ON public.product_clicks;
CREATE POLICY "Anyone can view product clicks" ON public.product_clicks FOR SELECT TO public USING (true);

DROP POLICY IF EXISTS "Anyone can insert trust votes" ON public.product_trust_votes;
CREATE POLICY "Anyone can insert trust votes" ON public.product_trust_votes FOR INSERT TO public WITH CHECK (true);

DROP POLICY IF EXISTS "Anyone can view trust votes" ON public.product_trust_votes;
CREATE POLICY "Anyone can view trust votes" ON public.product_trust_votes FOR SELECT TO public USING (true);

-- Add is_trusted to trust votes if not exists
ALTER TABLE public.product_trust_votes ADD COLUMN IF NOT EXISTS is_trusted BOOLEAN DEFAULT true;

-- Create price_history table
CREATE TABLE IF NOT EXISTS public.price_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    price NUMERIC NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.price_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view price history" ON public.price_history FOR SELECT TO public USING (true);
CREATE POLICY "Admins can manage price history" ON public.price_history FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
);

-- Trigger for price history
CREATE OR REPLACE FUNCTION log_price_change()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') OR 
       (TG_OP = 'UPDATE' AND (NEW.price IS DISTINCT FROM OLD.price OR NEW.discount IS DISTINCT FROM OLD.discount)) THEN
        INSERT INTO public.price_history (product_id, price)
        VALUES (NEW.id, NEW.price);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_log_price_change ON public.products;
CREATE TRIGGER trg_log_price_change
AFTER INSERT OR UPDATE ON public.products
FOR EACH ROW
EXECUTE FUNCTION log_price_change();

-- Trigger for product clicks
CREATE OR REPLACE FUNCTION increment_product_clicks()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.products
    SET clicks = clicks + 1
    WHERE id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_increment_product_clicks ON public.product_clicks;
CREATE TRIGGER trg_increment_product_clicks
AFTER INSERT ON public.product_clicks
FOR EACH ROW
EXECUTE FUNCTION increment_product_clicks();

-- Create institutional_pages table
CREATE TABLE IF NOT EXISTS public.institutional_pages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    content_html TEXT,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.institutional_pages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view active institutional pages" ON public.institutional_pages FOR SELECT TO public USING (active = true);
CREATE POLICY "Admins can view all institutional pages" ON public.institutional_pages FOR SELECT TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
);
CREATE POLICY "Admins can manage institutional pages" ON public.institutional_pages FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
);

-- Create coupons table
CREATE TABLE IF NOT EXISTS public.coupons (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    platform_id UUID NOT NULL REFERENCES public.platforms(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    description TEXT,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view active coupons" ON public.coupons FOR SELECT TO public USING (active = true);
CREATE POLICY "Admins can manage coupons" ON public.coupons FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
);

-- Create coupon_votes table
CREATE TABLE IF NOT EXISTS public.coupon_votes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    coupon_id UUID NOT NULL REFERENCES public.coupons(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    session_token UUID,
    is_working BOOLEAN NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT coupon_votes_user_unique UNIQUE (coupon_id, user_id),
    CONSTRAINT coupon_votes_session_unique UNIQUE (coupon_id, session_token)
);

ALTER TABLE public.coupon_votes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can insert coupon votes" ON public.coupon_votes FOR INSERT TO public WITH CHECK (true);
CREATE POLICY "Anyone can view coupon votes" ON public.coupon_votes FOR SELECT TO public USING (true);
