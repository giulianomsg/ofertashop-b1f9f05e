CREATE TABLE IF NOT EXISTS public.links (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.links ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Public can view active links" 
ON public.links FOR SELECT 
USING (is_active = true);

CREATE POLICY "Admins can manage links" 
ON public.links FOR ALL 
USING (
    EXISTS (
        SELECT 1 FROM public.user_roles 
        WHERE user_id = auth.uid() AND role = 'admin'
    )
);

-- Create a trigger to update 'updated_at'
CREATE OR REPLACE FUNCTION update_links_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_links_modtime
BEFORE UPDATE ON public.links
FOR EACH ROW
EXECUTE FUNCTION update_links_updated_at();

-- Add a key for the site logo in admin_settings if it doesn't exist
INSERT INTO public.admin_settings (key, value)
VALUES ('site_logo', '""'::jsonb)
ON CONFLICT (key) DO NOTHING;
