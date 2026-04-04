CREATE TABLE IF NOT EXISTS public.resend_usage_logs (
    date DATE PRIMARY KEY DEFAULT CURRENT_DATE,
    sent_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.resend_usage_logs ENABLE ROW LEVEL SECURITY;

-- Only admins can read/update
CREATE POLICY "Admins can view resend usage" ON public.resend_usage_logs
    FOR SELECT TO authenticated USING (
        EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can insert resend usage" ON public.resend_usage_logs
    FOR INSERT TO authenticated WITH CHECK (
        EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
    );

CREATE POLICY "Admins can update resend usage" ON public.resend_usage_logs
    FOR UPDATE TO authenticated USING (
        EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
    );

-- RPC for the Edge Function to securely increment the usage (bypassing RLS since Edge Functions usually use anon/service key, but just in case)
CREATE OR REPLACE FUNCTION increment_resend_usage(increment_by integer)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO public.resend_usage_logs (date, sent_count)
  VALUES (CURRENT_DATE, increment_by)
  ON CONFLICT (date)
  DO UPDATE SET 
    sent_count = public.resend_usage_logs.sent_count + EXCLUDED.sent_count,
    updated_at = NOW();
END;
$$;
