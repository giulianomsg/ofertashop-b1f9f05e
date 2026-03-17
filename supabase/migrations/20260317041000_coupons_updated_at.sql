-- Add updated_at column to coupons table (needed for sync deactivation logic)
ALTER TABLE public.coupons
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT now();
