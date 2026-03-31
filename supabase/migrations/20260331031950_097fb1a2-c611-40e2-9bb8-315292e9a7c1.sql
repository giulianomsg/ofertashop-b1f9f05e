
-- AI Pro Module: New tables for AI marketing automation

-- Enum for campaign types
CREATE TYPE public.ai_campaign_type AS ENUM (
  'EASTER', 'MOTHERS_DAY', 'FATHERS_DAY', 'VALENTINES_DAY', 
  'BLACK_FRIDAY', 'CYBER_MONDAY', 'CHRISTMAS', 'NEW_YEAR', 
  'CARNIVAL', 'BACK_TO_SCHOOL', 'CUSTOM'
);

-- Enum for campaign status
CREATE TYPE public.ai_campaign_status AS ENUM ('ACTIVE', 'DRAFT', 'EXPIRED');

-- Enum for AB test status
CREATE TYPE public.ai_ab_test_status AS ENUM ('RUNNING', 'COMPLETED', 'CANCELLED');

-- 1. ai_personas
CREATE TABLE public.ai_personas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  tone text NOT NULL DEFAULT 'persuasivo',
  triggers text[] DEFAULT '{}',
  preferences jsonb DEFAULT '{}'::jsonb,
  user_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.ai_personas ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin/Editor can manage ai_personas" ON public.ai_personas FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

-- 2. ai_campaigns
CREATE TABLE public.ai_campaigns (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  type ai_campaign_type NOT NULL DEFAULT 'CUSTOM',
  start_date timestamptz,
  end_date timestamptz,
  description text,
  settings jsonb DEFAULT '{}'::jsonb,
  status ai_campaign_status NOT NULL DEFAULT 'DRAFT',
  user_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.ai_campaigns ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin/Editor can manage ai_campaigns" ON public.ai_campaigns FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

-- 3. ai_ab_tests
CREATE TABLE public.ai_ab_tests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  product_id uuid REFERENCES public.products(id) ON DELETE CASCADE,
  variant_a_id text,
  variant_b_id text,
  winner_id text,
  metrics jsonb DEFAULT '{}'::jsonb,
  status ai_ab_test_status NOT NULL DEFAULT 'RUNNING',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.ai_ab_tests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin/Editor can manage ai_ab_tests" ON public.ai_ab_tests FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

-- 4. ai_competitor_tracking
CREATE TABLE public.ai_competitor_tracking (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source text NOT NULL,
  competitor_name text NOT NULL,
  content_analyzed text,
  detected_trends jsonb DEFAULT '[]'::jsonb,
  logged_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.ai_competitor_tracking ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin can manage ai_competitor_tracking" ON public.ai_competitor_tracking FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role));
CREATE POLICY "Admin/Editor can view ai_competitor_tracking" ON public.ai_competitor_tracking FOR SELECT TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

-- 5. ai_analytics_events
CREATE TABLE public.ai_analytics_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  platform text NOT NULL,
  event_type text NOT NULL,
  metrics jsonb DEFAULT '{}'::jsonb,
  date timestamptz NOT NULL DEFAULT now(),
  product_id uuid REFERENCES public.products(id) ON DELETE SET NULL
);
ALTER TABLE public.ai_analytics_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin/Editor can manage ai_analytics_events" ON public.ai_analytics_events FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

-- 6. ai_gamification_draws
CREATE TABLE public.ai_gamification_draws (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid REFERENCES public.products(id) ON DELETE SET NULL,
  rules text,
  prize text NOT NULL,
  draw_date timestamptz,
  status text NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.ai_gamification_draws ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admin can manage ai_gamification_draws" ON public.ai_gamification_draws FOR ALL TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role));

-- 7. Add ai_content_metadata to products
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS ai_content_metadata jsonb DEFAULT '{}'::jsonb;



-- Triggers for updated_at
CREATE TRIGGER update_ai_personas_updated_at BEFORE UPDATE ON public.ai_personas
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_ai_campaigns_updated_at BEFORE UPDATE ON public.ai_campaigns
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_ai_ab_tests_updated_at BEFORE UPDATE ON public.ai_ab_tests
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_ai_gamification_draws_updated_at BEFORE UPDATE ON public.ai_gamification_draws
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
