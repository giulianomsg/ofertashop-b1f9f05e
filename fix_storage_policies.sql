-- ==============================================================================
-- FIX STORAGE BUCKETS AND RLS POLICIES FOR SUPABASE
-- Execute este script no SQL Editor do painel do Supabase.
-- ==============================================================================

-- 1. Garantir que as tabelas de storage existam (o Supabase cuida disso, mas não custa ter certeza das permissões)
GRANT ALL PRIVILEGES ON SCHEMA storage TO postgres, anon, authenticated, service_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA storage TO postgres, anon, authenticated, service_role;

-- 2. Criar os Buckets se não existirem
INSERT INTO storage.buckets (id, name, public) 
VALUES ('banners', 'banners', true) 
ON CONFLICT (id) DO UPDATE SET public = true;

INSERT INTO storage.buckets (id, name, public) 
VALUES ('product-images', 'product-images', true) 
ON CONFLICT (id) DO UPDATE SET public = true;

-- 3. Limpar políticas antigas para evitar conflitos
DROP POLICY IF EXISTS "Public Access Banners" ON storage.objects;
DROP POLICY IF EXISTS "Auth Insert Banners" ON storage.objects;
DROP POLICY IF EXISTS "Auth Update Banners" ON storage.objects;
DROP POLICY IF EXISTS "Auth Delete Banners" ON storage.objects;
DROP POLICY IF EXISTS "Public Access" ON storage.objects;
DROP POLICY IF EXISTS "Auth Insert" ON storage.objects;
DROP POLICY IF EXISTS "Auth Update" ON storage.objects;
DROP POLICY IF EXISTS "Auth Delete" ON storage.objects;

DROP POLICY IF EXISTS "Anyone can view product images" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Editor can upload product images" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Editor can update product images" ON storage.objects;
DROP POLICY IF EXISTS "Admin/Editor can delete product images" ON storage.objects;

-- 4. Recriar Políticas para o bucket 'banners' (Utilizando autenticação explícita)
CREATE POLICY "Public Access Banners" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'banners');

CREATE POLICY "Auth Insert Banners" 
ON storage.objects FOR INSERT 
TO authenticated 
WITH CHECK (bucket_id = 'banners');

CREATE POLICY "Auth Update Banners" 
ON storage.objects FOR UPDATE 
TO authenticated 
USING (bucket_id = 'banners');

CREATE POLICY "Auth Delete Banners" 
ON storage.objects FOR DELETE 
TO authenticated 
USING (bucket_id = 'banners');

-- 5. Recriar Políticas para o bucket 'product-images'
CREATE POLICY "Public Access Products" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'product-images');

CREATE POLICY "Auth Insert Products" 
ON storage.objects FOR INSERT 
TO authenticated 
WITH CHECK (bucket_id = 'product-images');

CREATE POLICY "Auth Update Products" 
ON storage.objects FOR UPDATE 
TO authenticated 
USING (bucket_id = 'product-images');

CREATE POLICY "Auth Delete Products" 
ON storage.objects FOR DELETE 
TO authenticated 
USING (bucket_id = 'product-images');

-- Fim do script
