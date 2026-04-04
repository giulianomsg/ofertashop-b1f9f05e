-- Permitir leitura pública para chaves de configurações específicas (ex: logo da página de links)
CREATE POLICY "Enable public read access for specific settings" ON public.admin_settings
AS PERMISSIVE FOR SELECT
TO public
USING (key IN ('site_logo', 'links_page_campaign_name', 'links_page_products'));

-- Create table for public newsletter subscribers
CREATE TABLE IF NOT EXISTS public.newsletter_subscribers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS for newsletter_subscribers
ALTER TABLE public.newsletter_subscribers ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert into newsletter_subscribers
CREATE POLICY "Anyone can insert newsletter subscribers" ON public.newsletter_subscribers 
FOR INSERT TO public WITH CHECK (true);

-- Only admins can read newsletter_subscribers
CREATE POLICY "Admins can view newsletter subscribers" ON public.newsletter_subscribers 
FOR SELECT TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
);
