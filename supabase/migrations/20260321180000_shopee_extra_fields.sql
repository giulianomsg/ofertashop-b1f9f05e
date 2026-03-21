-- Add explicit columns for validity and JSONB for flexible extra shopee metadata
ALTER TABLE public.shopee_product_mappings
ADD COLUMN IF NOT EXISTS offer_valid_from timestamptz,
ADD COLUMN IF NOT EXISTS offer_valid_to timestamptz,
ADD COLUMN IF NOT EXISTS shopee_extra_data jsonb DEFAULT '{}'::jsonb;
