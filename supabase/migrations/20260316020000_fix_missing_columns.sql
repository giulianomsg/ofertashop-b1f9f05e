-- =====================================================================
-- FIX: Add missing columns to coupons and institutional_pages
-- These columns were in the mega migration's CREATE TABLE but if the
-- tables already existed from an earlier migration, IF NOT EXISTS
-- would skip them and the columns were never added.
-- =====================================================================

-- Coupons: add missing columns
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS title VARCHAR NOT NULL DEFAULT '';
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS discount_amount VARCHAR;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS discount_value VARCHAR;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS subtitle VARCHAR;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS conditions TEXT;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS is_link_only BOOLEAN DEFAULT false;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS reports_inactive INTEGER DEFAULT 0;
ALTER TABLE public.coupons ADD COLUMN IF NOT EXISTS link_url TEXT;

-- Institutional pages: add missing column
ALTER TABLE public.institutional_pages ADD COLUMN IF NOT EXISTS section_type VARCHAR DEFAULT 'support';

-- Ensure the single-active WhatsApp trigger is dropped (mega migration re-created it)
DROP TRIGGER IF EXISTS trg_enforce_single_active_whatsapp ON public.whatsapp_groups;
DROP TRIGGER IF EXISTS trg_single_active_whatsapp ON public.whatsapp_groups;

-- Ensure admin can view ALL coupons (not just active ones)
DROP POLICY IF EXISTS "Admins can view all coupons" ON public.coupons;
CREATE POLICY "Admins can view all coupons" ON public.coupons
  FOR SELECT TO authenticated USING (
    EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin')
  );

-- Ensure admin can update coupons (reports_inactive field etc)
DROP POLICY IF EXISTS "Anyone can update coupon reports" ON public.coupons;
CREATE POLICY "Anyone can update coupon reports" ON public.coupons
  FOR UPDATE TO public USING (true) WITH CHECK (true);
