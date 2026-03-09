-- Adicionar flag de is_active na tabela profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true;

-- Adicionar flag de status na tabela reviews
ALTER TABLE public.reviews ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'approved' CHECK (status IN ('approved', 'hidden', 'rejected'));

-- Atualizar Policies da tabela profiles para permitir que Admins atualizem os perfis
CREATE POLICY "Admins can update profiles" ON public.profiles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'));

-- Criar a visibilidade de perfis para admin
CREATE POLICY "Admins can view all profiles" ON public.profiles FOR SELECT USING (public.has_role(auth.uid(), 'admin'));

-- Atualizar Policies da tabela user_roles
CREATE POLICY "Admins can manage user roles (Insert)" ON public.user_roles FOR INSERT WITH CHECK (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can manage user roles (Update)" ON public.user_roles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'));
CREATE POLICY "Admins can manage user roles (Delete)" ON public.user_roles FOR DELETE USING (public.has_role(auth.uid(), 'admin'));

-- Atualizar Policies da tabela reviews
CREATE POLICY "Admin/Editor can update reviews" ON public.reviews FOR UPDATE USING (
  public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor')
);
CREATE POLICY "Admin/Editor can delete reviews" ON public.reviews FOR DELETE USING (
  public.has_role(auth.uid(), 'admin') OR public.has_role(auth.uid(), 'editor')
);
