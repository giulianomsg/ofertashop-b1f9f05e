-- ============================================================
-- Migration: Create API Clients & Webhook Logs tables
-- Purpose: Support external integrations (Gerashop) via REST API
-- ============================================================

-- -------------------------
-- Table: api_clients
-- -------------------------
CREATE TABLE IF NOT EXISTS public.api_clients (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  client_name text NOT NULL,
  api_key text NOT NULL UNIQUE,
  webhook_url text,
  webhook_events text[] NOT NULL DEFAULT '{"offer.updated"}',
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT api_clients_pkey PRIMARY KEY (id)
);

-- Enable RLS
ALTER TABLE public.api_clients ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated admin users can SELECT
CREATE POLICY "admin_select_api_clients"
  ON public.api_clients
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE user_roles.user_id = auth.uid()
        AND user_roles.role = 'admin'
    )
  );

-- Policy: Authenticated admin users can INSERT
CREATE POLICY "admin_insert_api_clients"
  ON public.api_clients
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE user_roles.user_id = auth.uid()
        AND user_roles.role = 'admin'
    )
  );

-- Policy: Authenticated admin users can UPDATE
CREATE POLICY "admin_update_api_clients"
  ON public.api_clients
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE user_roles.user_id = auth.uid()
        AND user_roles.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE user_roles.user_id = auth.uid()
        AND user_roles.role = 'admin'
    )
  );

-- Policy: Authenticated admin users can DELETE
CREATE POLICY "admin_delete_api_clients"
  ON public.api_clients
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE user_roles.user_id = auth.uid()
        AND user_roles.role = 'admin'
    )
  );

-- -------------------------
-- Table: webhook_logs
-- -------------------------
CREATE TABLE IF NOT EXISTS public.webhook_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  api_client_id uuid NOT NULL,
  endpoint_url text NOT NULL,
  payload jsonb NOT NULL DEFAULT '{}'::jsonb,
  status_code integer,
  response_body text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT webhook_logs_pkey PRIMARY KEY (id),
  CONSTRAINT webhook_logs_api_client_id_fkey FOREIGN KEY (api_client_id) REFERENCES public.api_clients(id) ON DELETE CASCADE
);

-- Enable RLS
ALTER TABLE public.webhook_logs ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated admin users can SELECT
CREATE POLICY "admin_select_webhook_logs"
  ON public.webhook_logs
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.user_roles
      WHERE user_roles.user_id = auth.uid()
        AND user_roles.role = 'admin'
    )
  );

-- Policy: Service role can INSERT (Edge Functions use service_role key which bypasses RLS,
-- but this explicit policy serves as documentation and safety net)
CREATE POLICY "service_insert_webhook_logs"
  ON public.webhook_logs
  FOR INSERT
  TO service_role
  WITH CHECK (true);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_api_clients_api_key ON public.api_clients (api_key);
CREATE INDEX IF NOT EXISTS idx_api_clients_is_active ON public.api_clients (is_active);
CREATE INDEX IF NOT EXISTS idx_webhook_logs_api_client_id ON public.webhook_logs (api_client_id);
CREATE INDEX IF NOT EXISTS idx_webhook_logs_created_at ON public.webhook_logs (created_at DESC);
