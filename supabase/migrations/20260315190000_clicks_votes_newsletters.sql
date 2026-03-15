-- Create product_clicks table
CREATE TABLE IF NOT EXISTS public.product_clicks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    session_token UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT product_clicks_user_unique UNIQUE (product_id, user_id),
    CONSTRAINT product_clicks_session_unique UNIQUE (product_id, session_token)
);

-- Create product_trust_votes table
CREATE TABLE IF NOT EXISTS public.product_trust_votes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    session_token UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT product_trust_votes_user_unique UNIQUE (product_id, user_id),
    CONSTRAINT product_trust_votes_session_unique UNIQUE (product_id, session_token)
);

-- Create newsletters table
CREATE TABLE IF NOT EXISTS public.newsletters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    subject TEXT NOT NULL,
    html_content TEXT,
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'sent')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create newsletter_products table
CREATE TABLE IF NOT EXISTS public.newsletter_products (
    newsletter_id UUID NOT NULL REFERENCES public.newsletters(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    PRIMARY KEY (newsletter_id, product_id)
);

-- RLS for product_clicks
ALTER TABLE public.product_clicks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can insert product clicks" ON public.product_clicks FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can view product clicks" ON public.product_clicks FOR SELECT USING (true);

-- RLS for product_trust_votes
ALTER TABLE public.product_trust_votes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can insert trust votes" ON public.product_trust_votes FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can view trust votes" ON public.product_trust_votes FOR SELECT USING (true);

-- RLS for newsletters
ALTER TABLE public.newsletters ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admins can manage newsletters" ON public.newsletters FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
);

-- RLS for newsletter_products
ALTER TABLE public.newsletter_products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admins can manage newsletter products" ON public.newsletter_products FOR ALL TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
);
