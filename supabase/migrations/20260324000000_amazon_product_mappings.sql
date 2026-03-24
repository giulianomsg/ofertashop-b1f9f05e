-- Criação da tabela de mapeamento de produtos da Amazon
CREATE TABLE IF NOT EXISTS public.amazon_product_mappings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
    amazon_item_id VARCHAR(50) NOT NULL UNIQUE,
    amazon_current_price DECIMAL(10, 2),
    amazon_original_price DECIMAL(10, 2),
    amazon_status VARCHAR(50),
    amazon_rating DECIMAL(3, 2),
    amazon_review_count INTEGER,
    last_synced_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices de busca
CREATE INDEX IF NOT EXISTS idx_amazon_product_mappings_item_id ON public.amazon_product_mappings(amazon_item_id);
CREATE INDEX IF NOT EXISTS idx_amazon_product_mappings_product_id ON public.amazon_product_mappings(product_id);

-- Habilitar RLS
ALTER TABLE public.amazon_product_mappings ENABLE ROW LEVEL SECURITY;

-- Políticas de acesso padrão
CREATE POLICY "Enable read access for all users on amazon_product_mappings" 
    ON public.amazon_product_mappings FOR SELECT USING (true);

CREATE POLICY "Enable all for authenticated users only on amazon_product_mappings" 
    ON public.amazon_product_mappings FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
