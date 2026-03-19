-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.banners (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  title text,
  subtitle text,
  image_url text NOT NULL,
  link_url text,
  cta_text text,
  is_active boolean NOT NULL DEFAULT true,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT banners_pkey PRIMARY KEY (id)
);
CREATE TABLE public.brands (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT brands_pkey PRIMARY KEY (id)
);
CREATE TABLE public.categories (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  slug text NOT NULL UNIQUE,
  icon text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT categories_pkey PRIMARY KEY (id)
);
CREATE TABLE public.coupon_votes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  coupon_id uuid NOT NULL,
  user_id uuid,
  session_token uuid,
  is_working boolean NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT coupon_votes_pkey PRIMARY KEY (id),
  CONSTRAINT coupon_votes_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id),
  CONSTRAINT coupon_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.coupons (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  platform_id uuid NOT NULL,
  code text NOT NULL,
  description text,
  active boolean DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  title character varying NOT NULL DEFAULT ''::character varying,
  discount_amount character varying,
  discount_value character varying,
  subtitle character varying,
  conditions text,
  is_link_only boolean DEFAULT false,
  reports_inactive integer DEFAULT 0,
  link_url text,
  updated_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT coupons_pkey PRIMARY KEY (id),
  CONSTRAINT coupons_platform_id_fkey FOREIGN KEY (platform_id) REFERENCES public.platforms(id)
);
CREATE TABLE public.institutional_pages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  content_html text,
  active boolean DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  section_type character varying DEFAULT 'support'::character varying,
  CONSTRAINT institutional_pages_pkey PRIMARY KEY (id)
);
CREATE TABLE public.models (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  brand_id uuid NOT NULL,
  name text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT models_pkey PRIMARY KEY (id),
  CONSTRAINT models_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id)
);
CREATE TABLE public.newsletter_products (
  newsletter_id uuid NOT NULL,
  product_id uuid NOT NULL,
  CONSTRAINT newsletter_products_pkey PRIMARY KEY (newsletter_id, product_id),
  CONSTRAINT newsletter_products_newsletter_id_fkey FOREIGN KEY (newsletter_id) REFERENCES public.newsletters(id),
  CONSTRAINT newsletter_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.newsletters (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  subject text NOT NULL,
  html_content text,
  status text DEFAULT 'draft'::text CHECK (status = ANY (ARRAY['draft'::text, 'sent'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT newsletters_pkey PRIMARY KEY (id)
);
CREATE TABLE public.platforms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  logo_url text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT platforms_pkey PRIMARY KEY (id)
);
CREATE TABLE public.price_history (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL,
  price numeric NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT price_history_pkey PRIMARY KEY (id),
  CONSTRAINT price_history_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.product_clicks (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL,
  user_id uuid,
  session_token uuid,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT product_clicks_pkey PRIMARY KEY (id),
  CONSTRAINT product_clicks_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_clicks_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.product_likes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  product_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT product_likes_pkey PRIMARY KEY (id),
  CONSTRAINT product_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT product_likes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.product_trust_votes (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL,
  user_id uuid,
  session_token uuid,
  created_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  is_trusted boolean DEFAULT true,
  CONSTRAINT product_trust_votes_pkey PRIMARY KEY (id),
  CONSTRAINT product_trust_votes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_trust_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.products (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  price numeric NOT NULL,
  original_price numeric,
  discount integer,
  image_url text,
  gallery_urls ARRAY DEFAULT '{}'::text[],
  badge text,
  store text NOT NULL,
  affiliate_url text NOT NULL,
  rating numeric NOT NULL DEFAULT 0,
  review_count integer NOT NULL DEFAULT 0,
  clicks integer NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  created_by uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  brand_id uuid,
  model_id uuid,
  platform_id uuid,
  video_url text,
  discount_percentage numeric,
  registered_by uuid,
  category_id uuid,
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id),
  CONSTRAINT products_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.models(id),
  CONSTRAINT products_platform_id_fkey FOREIGN KEY (platform_id) REFERENCES public.platforms(id),
  CONSTRAINT products_registered_by_fkey FOREIGN KEY (registered_by) REFERENCES auth.users(id),
  CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE,
  full_name text,
  avatar_url text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  price_alert_opt_in boolean NOT NULL DEFAULT false,
  newsletter_opt_in boolean NOT NULL DEFAULT false,
  CONSTRAINT profiles_pkey PRIMARY KEY (id)
);
CREATE TABLE public.reports (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL,
  reporter_email text NOT NULL,
  report_type text NOT NULL,
  status text NOT NULL DEFAULT 'pending'::text,
  resolved_by uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT reports_pkey PRIMARY KEY (id),
  CONSTRAINT reports_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.reviews (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL,
  user_id uuid,
  user_name text NOT NULL,
  rating integer NOT NULL,
  comment text,
  status text NOT NULL DEFAULT 'approved'::text,
  helpful_count integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT reviews_pkey PRIMARY KEY (id),
  CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.special_page_products (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  special_page_id uuid NOT NULL,
  product_id uuid NOT NULL,
  CONSTRAINT special_page_products_pkey PRIMARY KEY (id),
  CONSTRAINT special_page_products_special_page_id_fkey FOREIGN KEY (special_page_id) REFERENCES public.special_pages(id),
  CONSTRAINT special_page_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.special_pages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  active boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT special_pages_pkey PRIMARY KEY (id)
);
CREATE TABLE public.user_roles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  role USER-DEFINED NOT NULL DEFAULT 'viewer'::app_role,
  CONSTRAINT user_roles_pkey PRIMARY KEY (id),
  CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.whatsapp_groups (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  link text NOT NULL,
  active boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  name text NOT NULL DEFAULT 'Geral'::text,
  CONSTRAINT whatsapp_groups_pkey PRIMARY KEY (id)
);
CREATE TABLE public.wishlists (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  product_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT wishlists_pkey PRIMARY KEY (id),
  CONSTRAINT wishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT wishlists_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);