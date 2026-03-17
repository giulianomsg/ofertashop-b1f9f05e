-- Migration: Allow 'queued' status on newsletters, add 'sent_at' to email_queue

-- Expand the newsletters status check constraint to include 'queued'
ALTER TABLE public.newsletters DROP CONSTRAINT IF EXISTS newsletters_status_check;
ALTER TABLE public.newsletters ADD CONSTRAINT newsletters_status_check
  CHECK (status IN ('draft', 'queued', 'sent'));

-- Add sent_at timestamp to email_queue for tracking
ALTER TABLE public.email_queue
  ADD COLUMN IF NOT EXISTS sent_at TIMESTAMP WITH TIME ZONE;
