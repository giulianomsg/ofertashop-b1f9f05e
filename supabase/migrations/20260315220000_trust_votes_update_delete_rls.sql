-- Add UPDATE and DELETE RLS policies for product_trust_votes
DROP POLICY IF EXISTS "Users can update own trust votes" ON public.product_trust_votes;
CREATE POLICY "Users can update own trust votes" ON public.product_trust_votes 
FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own trust votes" ON public.product_trust_votes;
CREATE POLICY "Users can delete own trust votes" ON public.product_trust_votes 
FOR DELETE USING (auth.uid() = user_id);
