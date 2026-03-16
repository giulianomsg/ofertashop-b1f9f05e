-- =====================================================================
-- FIX 1: Allow multiple clicks per user/session on the same product
-- Drop UNIQUE constraints so each click creates a new row,
-- which fires the trigger to increment products.clicks
-- =====================================================================
ALTER TABLE public.product_clicks DROP CONSTRAINT IF EXISTS product_clicks_user_unique;
ALTER TABLE public.product_clicks DROP CONSTRAINT IF EXISTS product_clicks_session_unique;

-- =====================================================================
-- FIX 2: Clean up product_trust_votes
-- Remove the session_token UNIQUE constraint (votes are user-only now)
-- Keep the user_id UNIQUE so each user has exactly one vote per product
-- =====================================================================
ALTER TABLE public.product_trust_votes DROP CONSTRAINT IF EXISTS product_trust_votes_session_unique;

-- Ensure UPDATE and DELETE policies exist for trust votes
DROP POLICY IF EXISTS "Users can update own trust votes" ON public.product_trust_votes;
CREATE POLICY "Users can update own trust votes" ON public.product_trust_votes
FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own trust votes" ON public.product_trust_votes;
CREATE POLICY "Users can delete own trust votes" ON public.product_trust_votes
FOR DELETE USING (auth.uid() = user_id);
