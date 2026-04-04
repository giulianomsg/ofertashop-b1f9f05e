-- Drop and recreate the check constraint manually just to be completely sure 'queued' is allowed!
ALTER TABLE public.newsletters DROP CONSTRAINT IF EXISTS newsletters_status_check;
ALTER TABLE public.newsletters ADD CONSTRAINT newsletters_status_check
  CHECK (status IN ('draft', 'queued', 'sent'));

-- Add newsletter_id to email_queue to track progress
ALTER TABLE public.email_queue 
ADD COLUMN IF NOT EXISTS newsletter_id UUID REFERENCES public.newsletters(id) ON DELETE CASCADE;

NOTIFY pgrst, 'reload schema';
