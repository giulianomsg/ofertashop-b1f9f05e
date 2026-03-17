-- Migration: Add updated_at column and unique constraint to coupons table
-- Required by the sync-shopee-coupons Edge Function

-- Add updated_at column (used by sync logic to detect stale coupons)
ALTER TABLE public.coupons
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL;

-- Deduplicate existing rows with same (platform_id, code) before adding constraint.
-- Keeps the most recently created row and deletes older duplicates.
DELETE FROM public.coupons
WHERE id NOT IN (
  SELECT DISTINCT ON (platform_id, code) id
  FROM public.coupons
  ORDER BY platform_id, code, created_at DESC
);

-- Unique constraint on (platform_id, code) for UPSERT conflict target
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'uq_coupons_platform_code'
  ) THEN
    ALTER TABLE public.coupons
      ADD CONSTRAINT uq_coupons_platform_code UNIQUE (platform_id, code);
  END IF;
END $$;

-- Auto-update updated_at on row modification
CREATE OR REPLACE FUNCTION update_coupons_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_coupons_updated_at ON public.coupons;
CREATE TRIGGER trg_coupons_updated_at
BEFORE UPDATE ON public.coupons
FOR EACH ROW
EXECUTE FUNCTION update_coupons_updated_at();
