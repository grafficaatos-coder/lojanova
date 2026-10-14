-- Execute somente no projeto exclusivo LojaNova
create extension if not exists pgcrypto;
create table if not exists public.stores (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 name text not null check (char_length(name) between 2 and 120),
 slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
 created_at timestamptz not null default now()
);
create index if not exists stores_owner_idx on public.stores(owner_id);
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 store_id uuid not null references public.stores(id) on delete cascade,
 name text not null check (char_length(name) between 1 and 200),
 price_cents bigint not null check(price_cents>=0),
 stock integer not null default 0 check(stock>=0),
 published boolean not null default false,
 created_at timestamptz not null default now()
);
create index if not exists products_store_idx on public.products(store_id);
create table if not exists public.customers (
 id uuid primary key default gen_random_uuid(),
 store_id uuid not null references public.stores(id) on delete cascade,
 name text not null,
 email text,
 created_at timestamptz not null default now()
);
create index if not exists customers_store_idx on public.customers(store_id);
create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(),
 store_id uuid not null references public.stores(id),
 customer_id uuid references public.customers(id),
 status text not null default 'pending' check(status in ('pending','paid','cancelled','refunded','fulfilled')),
 total_cents bigint not null check(total_cents>=0),
 created_at timestamptz not null default now()
);
create index if not exists orders_store_idx on public.orders(store_id);
create table if not exists public.order_items (
 id uuid primary key default gen_random_uuid(),
 order_id uuid not null references public.orders(id) on delete cascade,
 product_id uuid references public.products(id),
 quantity integer not null check(quantity>0),
 unit_price_cents bigint not null check(unit_price_cents>=0)
);
alter table public.stores enable row level security;
alter table public.products enable row level security;
alter table public.customers enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
create policy "public store reading" on public.stores for select to anon, authenticated using (true);
create policy "owner creates stores" on public.stores for insert to authenticated with check (owner_id=(select auth.uid()));
create policy "owner updates stores" on public.stores for update to authenticated using (owner_id=(select auth.uid())) with check (owner_id=(select auth.uid()));
create policy "owner deletes stores" on public.stores for delete to authenticated using (owner_id=(select auth.uid()));
create policy "published or owner products" on public.products for select to anon, authenticated using (published=true or exists(select 1 from public.stores s where s.id=store_id and s.owner_id=(select auth.uid())));
create policy "owner inserts products" on public.products for insert to authenticated with check(exists(select 1 from public.stores s where s.id=store_id and s.owner_id=(select auth.uid())));
create policy "owner updates products" on public.products for update to authenticated using(exists(select 1 from public.stores s where s.id=store_id and s.owner_id=(select auth.uid()))) with check(exists(select 1 from public.stores s where s.id=store_id and s.owner_id=(select auth.uid())));
create policy "owner deletes products" on public.products for delete to authenticated using(exists(select 1 from public.stores s where s.id=store_id and s.owner_id=(select auth.uid())));
create policy "owner reads customers" on public.customers for select to authenticated using(exists(select 1 from public.stores s where s.id=store_id and s.owner_id=(select auth.uid())));
create policy "owner reads orders" on public.orders for select to authenticated using(exists(select 1 from public.stores s where s.id=store_id and s.owner_id=(select auth.uid())));
create policy "owner reads order items" on public.order_items for select to authenticated using(exists(select 1 from public.orders o join public.stores s on s.id=o.store_id where o.id=order_id and s.owner_id=(select auth.uid())));
-- Orders and customers are intentionally read-only to browser users until server-side secure checkout is implemented.
