-- Fix: Restrict report creation to require a non-empty email
DROP POLICY "Anyone can create reports" ON public.reports;
CREATE POLICY "Anyone can create reports with email" ON public.reports FOR INSERT WITH CHECK (reporter_email IS NOT NULL AND reporter_email != '');