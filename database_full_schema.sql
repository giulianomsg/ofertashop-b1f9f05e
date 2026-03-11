-- ============================================================
-- OfertaShop - Schema Completo para Migração Supabase
-- Gerado em: 2026-03-11
-- ============================================================

-- ===================== ENUMS =====================
CREATE TYPE public.app_role AS ENUM ('admin', 'editor', 'viewer');

-- ===================== TABELAS =====================

-- Profiles
CREATE TABLE public.profiles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL UNIQUE,
    full_name text,
    avatar_url text,
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- User Roles
CREATE TABLE public.user_roles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role app_role NOT NULL DEFAULT 'viewer'::app_role,
    UNIQUE (user_id, role)
);

-- Products
CREATE TABLE public.products (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    description text,
    price numeric NOT NULL,
    original_price numeric,
    discount integer,
    image_url text,
    gallery_urls text[] DEFAULT '{}'::text[],
    badge text,
    category text NOT NULL,
    store text NOT NULL,
    affiliate_url text NOT NULL,
    rating numeric NOT NULL DEFAULT 0,
    review_count integer NOT NULL DEFAULT 0,
    clicks integer NOT NULL DEFAULT 0,
    is_active boolean NOT NULL DEFAULT true,
    created_by uuid,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Banners
CREATE TABLE public.banners (
    id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
    title text,
    subtitle text,
    image_url text NOT NULL,
    link_url text,
    cta_text text,
    is_active boolean NOT NULL DEFAULT true,
    sort_order integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Reviews
CREATE TABLE public.reviews (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL REFERENCES public.products(id),
    user_id uuid,
    user_name text NOT NULL,
    rating integer NOT NULL,
    comment text,
    status text NOT NULL DEFAULT 'approved'::text,
    helpful_count integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- Reports
CREATE TABLE public.reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL REFERENCES public.products(id),
    reporter_email text NOT NULL,
    report_type text NOT NULL,
    status text NOT NULL DEFAULT 'pending'::text,
    resolved_by uuid,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- ===================== VIEW =====================

CREATE OR REPLACE VIEW public.admin_users_view AS
SELECT
    p.id AS profile_id,
    p.avatar_url,
    p.full_name,
    p.is_active,
    p.created_at,
    ur.role,
    p.user_id,
    u.email
FROM public.profiles p
LEFT JOIN public.user_roles ur ON ur.user_id = p.user_id
LEFT JOIN auth.users u ON u.id = p.user_id;

-- ===================== FUNCTIONS =====================

-- Trigger: updated_at automático
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- Trigger: criação automática de profile e role ao registrar usuário
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
  INSERT INTO public.profiles (user_id, full_name)
  VALUES (NEW.id, NEW.raw_user_meta_data ->> 'full_name');

  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'viewer')
  ON CONFLICT (user_id, role) DO NOTHING;

  RETURN NEW;
END;
$$;

-- Função de verificação de role (SECURITY DEFINER para evitar recursão em RLS)
CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO 'public'
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles
    WHERE user_id = _user_id
      AND role = _role
  )
$$;

-- Admin: deletar usuário
CREATE OR REPLACE FUNCTION public.admin_delete_user(target_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'auth'
AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
  target_role app_role;
  admin_count INT;
BEGIN
  caller_id := auth.uid();

  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem excluir usuários.';
  END IF;

  IF caller_id = target_user_id THEN
    RAISE EXCEPTION 'Você não pode excluir sua própria conta.';
  END IF;

  SELECT role INTO target_role FROM public.user_roles WHERE user_id = target_user_id;
  IF target_role = 'admin' THEN
    SELECT count(*) INTO admin_count FROM public.user_roles WHERE role = 'admin';
    IF admin_count <= 1 THEN
      RAISE EXCEPTION 'Não é possível excluir o último administrador do sistema.';
    END IF;
  END IF;

  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;

-- Admin: atualizar role de usuário
CREATE OR REPLACE FUNCTION public.admin_update_user_role(target_user_id uuid, new_role app_role)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
  target_role app_role;
  admin_count INT;
BEGIN
  caller_id := auth.uid();

  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem alterar perfis.';
  END IF;

  SELECT role INTO target_role FROM public.user_roles WHERE user_id = target_user_id;

  IF target_role = 'admin' AND new_role != 'admin' THEN
    IF target_user_id = caller_id THEN
       RAISE EXCEPTION 'Você não pode remover seu próprio acesso de administrador.';
    END IF;

    SELECT count(*) INTO admin_count FROM public.user_roles WHERE role = 'admin';
    IF admin_count <= 1 THEN
      RAISE EXCEPTION 'Não é possível remover o último administrador do sistema.';
    END IF;
  END IF;

  UPDATE public.user_roles SET role = new_role WHERE user_id = target_user_id;
END;
$$;

-- Admin: atualizar email de usuário
CREATE OR REPLACE FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public', 'auth'
AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
BEGIN
  caller_id := auth.uid();

  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem alterar emails.';
  END IF;

  UPDATE auth.users
  SET email = new_email, email_confirmed_at = now()
  WHERE id = target_user_id;
END;
$$;

-- ===================== TRIGGERS =====================

-- updated_at automático para products, banners, profiles
CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_banners_updated_at
  BEFORE UPDATE ON public.banners
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger para novo usuário (auth.users)
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ===================== RLS =====================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.banners ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

-- ---------- PROFILES ----------
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all profiles" ON public.profiles
  FOR SELECT USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Users can insert own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Admins can update profiles" ON public.profiles
  FOR UPDATE USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admins can update any profile" ON public.profiles
  FOR UPDATE USING (has_role(auth.uid(), 'admin'::app_role));

-- ---------- USER_ROLES ----------
CREATE POLICY "Users can view own role" ON public.user_roles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage roles" ON public.user_roles
  FOR ALL USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admins can manage user roles (Insert)" ON public.user_roles
  FOR INSERT WITH CHECK (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admins can manage user roles (Update)" ON public.user_roles
  FOR UPDATE USING (has_role(auth.uid(), 'admin'::app_role));

CREATE POLICY "Admins can manage user roles (Delete)" ON public.user_roles
  FOR DELETE USING (has_role(auth.uid(), 'admin'::app_role));

-- ---------- PRODUCTS ----------
CREATE POLICY "Anyone can view active products" ON public.products
  FOR SELECT USING (
    (is_active = true) OR has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role)
  );

CREATE POLICY "Admin/Editor can insert products" ON public.products
  FOR INSERT TO authenticated
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Admin/Editor can update products" ON public.products
  FOR UPDATE TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Admin can delete products" ON public.products
  FOR DELETE TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role));

-- ---------- BANNERS ----------
CREATE POLICY "Anyone can view active banners" ON public.banners
  FOR SELECT USING (
    (is_active = true) OR has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role)
  );

CREATE POLICY "Admin/Editor can insert banners" ON public.banners
  FOR INSERT TO authenticated
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Admin/Editor can update banners" ON public.banners
  FOR UPDATE TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role))
  WITH CHECK (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Admin can delete banners" ON public.banners
  FOR DELETE TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role));

-- ---------- REVIEWS ----------
CREATE POLICY "Anyone can view reviews" ON public.reviews
  FOR SELECT USING (true);

CREATE POLICY "Authenticated can insert reviews" ON public.reviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admin/Editor can update reviews" ON public.reviews
  FOR UPDATE USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Admin/Editor can delete reviews" ON public.reviews
  FOR DELETE USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

-- ---------- REPORTS ----------
CREATE POLICY "Admin/Editor can view reports" ON public.reports
  FOR SELECT USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Admin can update reports" ON public.reports
  FOR UPDATE USING (has_role(auth.uid(), 'admin'::app_role) OR has_role(auth.uid(), 'editor'::app_role));

CREATE POLICY "Anyone can create reports with email" ON public.reports
  FOR INSERT WITH CHECK ((reporter_email IS NOT NULL) AND (reporter_email <> ''::text));

-- ===================== STORAGE BUCKETS =====================
-- Criar buckets públicos (executar via Dashboard ou API)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('product-images', 'product-images', true);
-- INSERT INTO storage.buckets (id, name, public) VALUES ('banners', 'banners', true);

-- ===================== REALTIME (se necessário) =====================
-- ALTER PUBLICATION supabase_realtime ADD TABLE public.products;
-- ALTER PUBLICATION supabase_realtime ADD TABLE public.reviews;

-- ===================== EDGE FUNCTIONS =====================
-- As Edge Functions ficam em arquivos separados:
--
-- 1. supabase/functions/image-proxy/index.ts
--    - Recebe URL de imagem ou página web
--    - Extrai imagem OG se não for URL direta
--    - Faz upload para o bucket "product-images"
--    - Retorna a URL pública do storage
--
-- 2. supabase/functions/og-proxy/index.ts
--    - Recebe productId via query param
--    - Busca dados do produto no banco
--    - Injeta meta tags OG/Twitter no HTML para SEO/compartilhamento
--
-- Configuração em supabase/config.toml:
-- [functions.image-proxy]
-- verify_jwt = false
-- [functions.og-proxy]
-- verify_jwt = false
