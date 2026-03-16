-- =====================================================================
-- FIX: product_trust_votes.user_id and product_clicks.user_id
-- currently reference public.profiles(id), but auth.uid() comes from
-- auth.users. If the user has no profile row, inserts fail with 23503.
-- Change FK to reference auth.users(id) instead.
-- =====================================================================

-- Fix product_trust_votes
ALTER TABLE public.product_trust_votes DROP CONSTRAINT IF EXISTS product_trust_votes_user_id_fkey;
ALTER TABLE public.product_trust_votes
  ADD CONSTRAINT product_trust_votes_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;

-- Fix product_clicks
ALTER TABLE public.product_clicks DROP CONSTRAINT IF EXISTS product_clicks_user_id_fkey;
ALTER TABLE public.product_clicks
  ADD CONSTRAINT product_clicks_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;
