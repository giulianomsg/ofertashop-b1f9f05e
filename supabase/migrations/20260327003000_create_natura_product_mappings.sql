create table "public"."natura_product_mappings" (
    "id" uuid not null default gen_random_uuid(),
    "product_id" uuid not null references public.products(id) on delete cascade,
    "natura_item_id" text not null,
    "natura_current_price" numeric,
    "natura_original_price" numeric,
    "natura_status" text default 'active'::text,
    "natura_rating" numeric,
    "natura_review_count" integer,
    "last_synced_at" timestamp with time zone default timezone('utc'::text, now()),
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
);

alter table "public"."natura_product_mappings" enable row level security;

CREATE UNIQUE INDEX natura_product_mappings_pkey ON public.natura_product_mappings USING btree (id);
CREATE UNIQUE INDEX natura_product_mappings_natura_item_id_key ON public.natura_product_mappings USING btree (natura_item_id);

alter table "public"."natura_product_mappings" add constraint "natura_product_mappings_pkey" PRIMARY KEY using index "natura_product_mappings_pkey";
alter table "public"."natura_product_mappings" add constraint "natura_product_mappings_natura_item_id_key" UNIQUE using index "natura_product_mappings_natura_item_id_key";

-- RLS
create policy "Enable ALL for authenticated users only"
on "public"."natura_product_mappings"
as permissive
for all
to authenticated
using (true)
with check (true);

create policy "Enable read access for all users"
on "public"."natura_product_mappings"
as permissive
for select
to public
using (true);
