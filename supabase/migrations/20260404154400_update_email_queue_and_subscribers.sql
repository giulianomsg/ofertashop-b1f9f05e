-- Create email_queue table if it doesn't exist (fixing schema cache and missing table issues)
CREATE TABLE IF NOT EXISTS public.email_queue (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  subject text NOT NULL,
  html_content text,
  status text DEFAULT 'pending',
  sent_at timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Ensure RLS is enabled and admins can manage it
ALTER TABLE public.email_queue ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies WHERE tablename = 'email_queue' AND policyname = 'Admin can manage email queue'
    ) THEN
        CREATE POLICY "Admin can manage email queue" ON public.email_queue
        FOR ALL TO authenticated
        USING (
            EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
        )
        WITH CHECK (
            EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
        );
    END IF;
END
$$;

-- Add customer_email to support anonymous newsletter subscribers
ALTER TABLE public.email_queue
ADD COLUMN IF NOT EXISTS customer_email TEXT;

NOTIFY pgrst, 'reload schema';
