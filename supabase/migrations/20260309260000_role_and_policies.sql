-- Atualiza a trigger para inserir automaticamente na tabela user_roles
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Cria o profile
  INSERT INTO public.profiles (user_id, full_name)
  VALUES (NEW.id, NEW.raw_user_meta_data ->> 'full_name');

  -- Adiciona role inicial como viewer, se já não existir
  INSERT INTO public.user_roles (user_id, role)
  VALUES (NEW.id, 'viewer')
  ON CONFLICT (user_id, role) DO NOTHING;

  RETURN NEW;
END;
$$;

-- Remove a política antiga mais permissiva
DROP POLICY IF EXISTS "Authenticated can insert reviews" ON public.reviews;

-- Cria a nova política garantindo que o usuário só crie reviews para ele mesmo
CREATE POLICY "Authenticated can insert reviews" 
ON public.reviews 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);
