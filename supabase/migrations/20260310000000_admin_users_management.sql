-- View para listar usuários de forma simples combinando profile e role
CREATE OR REPLACE VIEW public.admin_users_view WITH (security_invoker = true) AS
SELECT 
  p.id as profile_id,
  p.user_id,
  p.full_name,
  p.avatar_url,
  p.is_active,
  p.created_at,
  r.role
FROM public.profiles p
LEFT JOIN public.user_roles r ON p.user_id = r.user_id;

-- Função para deletar um usuário (Apenas Admin)
CREATE OR REPLACE FUNCTION public.admin_delete_user(target_user_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
  target_role app_role;
  admin_count INT;
BEGIN
  caller_id := auth.uid();
  
  -- Verificar se quem chama é admin
  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem excluir usuários.';
  END IF;

  -- Impedir auto-exclusão
  IF caller_id = target_user_id THEN
    RAISE EXCEPTION 'Você não pode excluir sua própria conta.';
  END IF;

  -- Verificar se o alvo é admin e se é o último
  SELECT role INTO target_role FROM public.user_roles WHERE user_id = target_user_id;
  IF target_role = 'admin' THEN
    SELECT count(*) INTO admin_count FROM public.user_roles WHERE role = 'admin';
    IF admin_count <= 1 THEN
      RAISE EXCEPTION 'Não é possível excluir o último administrador do sistema.';
    END IF;
  END IF;

  -- Deletar o usuário da tabela auth.users. O cascade cuidará do profile e user_roles.
  DELETE FROM auth.users WHERE id = target_user_id;
END;
$$;

-- Função para atualizar a role de um usuário e impedir rebaixar o ultimo admin
CREATE OR REPLACE FUNCTION public.admin_update_user_role(target_user_id UUID, new_role app_role)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  caller_id UUID;
  caller_role app_role;
  target_role app_role;
  admin_count INT;
BEGIN
  caller_id := auth.uid();
  
  -- Verificar se quem chama é admin
  SELECT role INTO caller_role FROM public.user_roles WHERE user_id = caller_id;
  IF caller_role != 'admin' THEN
    RAISE EXCEPTION 'Apenas administradores podem alterar perfis.';
  END IF;

  -- Se estiver rebaixando um admin
  SELECT role INTO target_role FROM public.user_roles WHERE user_id = target_user_id;
  
  IF target_role = 'admin' AND new_role != 'admin' THEN
    -- Impedir auto-rebaixamento por segurança
    IF target_user_id = caller_id THEN
       RAISE EXCEPTION 'Você não pode remover seu próprio acesso de administrador.';
    END IF;

    -- Verificar se é o último admin
    SELECT count(*) INTO admin_count FROM public.user_roles WHERE role = 'admin';
    IF admin_count <= 1 THEN
      RAISE EXCEPTION 'Não é possível remover o último administrador do sistema.';
    END IF;
  END IF;

  -- Atualizar a role
  UPDATE public.user_roles SET role = new_role WHERE user_id = target_user_id;
END;
$$;

-- Política RLS para permitir Admin atualizar profiles de qualquer um 
-- (antes, apenas users podiam atualizar seu proprio profile)
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;

CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Admins can update any profile" ON public.profiles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'));
