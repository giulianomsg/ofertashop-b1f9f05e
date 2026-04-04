-- Adicionar coluna para agendamento de envios
ALTER TABLE public.email_queue
ADD COLUMN IF NOT EXISTS scheduled_at timestamptz DEFAULT NULL;

NOTIFY pgrst, 'reload schema';
