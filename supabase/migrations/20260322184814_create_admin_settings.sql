-- Migration: Create Admin Settings table (Key/Value store)
CREATE TABLE IF NOT EXISTS public.admin_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.admin_settings ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to manage and read settings
CREATE POLICY "Enable all access for authenticated users" ON public.admin_settings
AS PERMISSIVE FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);
