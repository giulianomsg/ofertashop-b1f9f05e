-- Fix RLS policies: change from RESTRICTIVE to PERMISSIVE
DROP POLICY IF EXISTS "Admin can delete products" ON public.products;
DROP POLICY IF EXISTS "Admin/Editor can insert products" ON public.products;
DROP POLICY IF EXISTS "Admin/Editor can update products" ON public.products;
DROP POLICY IF EXISTS "Anyone can view active products" ON public.products;

CREATE POLICY "Admin can delete products" ON public.products
  FOR DELETE TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admin/Editor can insert products" ON public.products
  FOR INSERT TO authenticated
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Admin/Editor can update products" ON public.products
  FOR UPDATE TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Anyone can view active products" ON public.products
  FOR SELECT
  USING ((is_active = true) OR has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));