-- Migração: Adiciona coluna expires_at (Timestamp com Timezone)
ALTER TABLE public.coupons 
ADD COLUMN IF NOT EXISTS expires_at TIMESTAMP WITH TIME ZONE NULL;

-- Atualizar metadados para ter um indice caso haja necessidade futura
CREATE INDEX IF NOT EXISTS idx_coupons_expires_at ON public.coupons(expires_at);
