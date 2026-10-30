-- Cladder & Co: complete fresh-project schema. No production data is included.
begin;
create table public.production_tracker_state (
 id text primary key check (id = 'main'), data jsonb not null default '{}'::jsonb,
 updated_at timestamptz not null default now()
);
create table public.fabrics (
 code text primary key, fabric_name text not null, print_type text not null default '',
 colour text not null default '', total_length numeric not null check(total_length >= 0),
 consumed numeric not null default 0 check(consumed >= 0)
);
create table public.cuttings (
 id uuid primary key, batch_code text not null, root_code text,
 cut_group_id uuid, parent_cutting_id uuid references public.cuttings(id),
 sku text not null, common_name text not null, garment_type text not null default 'custom',
 garment_label text, gender text, entry_date date not null,
 current_stage text not null, finished_goods_date date, created_at timestamptz not null default now()
);
create table public.cutting_fabric_components (
 id uuid primary key default gen_random_uuid(), cutting_id uuid not null references public.cuttings(id) on delete cascade,
 fabric_code text not null references public.fabrics(code), avg_fabric_used numeric not null check(avg_fabric_used > 0),
 qty_used numeric not null check(qty_used >= 0), correction numeric not null default 0
);
create table public.cutting_stage_movements (
 id uuid primary key default gen_random_uuid(), cutting_id uuid not null references public.cuttings(id) on delete cascade,
 size_code text not null, stage text not null, direction text not null check(direction in ('in','out')),
 qty numeric not null check(qty > 0), movement_type text not null, moved_at timestamptz not null
);
create table public.outsourcing (
 id uuid primary key, cutting_id uuid references public.cuttings(id) on delete set null,
 work_type text not null, vendor_name text not null, sku text not null, common_name text not null,
 delivery_date date not null, pending_delivery_date date, created_at timestamptz not null default now()
);
create table public.outsourcing_sizes (
 outsourcing_id uuid not null references public.outsourcing(id) on delete cascade,
 size_code text not null, qty numeric not null check(qty > 0), primary key(outsourcing_id,size_code)
);
create table public.outsourcing_accessories (
 outsourcing_id uuid primary key references public.outsourcing(id) on delete cascade,
 elastic numeric not null default 0, button numeric not null default 0, tag numeric not null default 0, other_accessory text
);
create table public.outsourcing_receipts (
 id uuid primary key, outsourcing_id uuid not null references public.outsourcing(id) on delete cascade,
 qty numeric not null check(qty > 0), received_date date not null
);
create table public.accessory_stock (
 id uuid primary key, accessory_type text not null, label text, sku text, common_name text,
 qty numeric not null check(qty > 0), entry_date date not null
);
create index on public.cuttings(parent_cutting_id);
create index on public.cutting_fabric_components(cutting_id);
create index on public.cutting_fabric_components(fabric_code);
create index on public.cutting_stage_movements(cutting_id);
create index on public.outsourcing(cutting_id);
create index on public.outsourcing_receipts(outsourcing_id);
alter table public.production_tracker_state enable row level security;
revoke all on public.production_tracker_state from anon;
grant select, insert, update, delete on public.production_tracker_state to authenticated;
create policy "Cladder owner access" on public.production_tracker_state for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.fabrics enable row level security;
revoke all on public.fabrics from anon;
grant select, insert, update, delete on public.fabrics to authenticated;
create policy "Cladder owner access" on public.fabrics for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.cuttings enable row level security;
revoke all on public.cuttings from anon;
grant select, insert, update, delete on public.cuttings to authenticated;
create policy "Cladder owner access" on public.cuttings for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.cutting_fabric_components enable row level security;
revoke all on public.cutting_fabric_components from anon;
grant select, insert, update, delete on public.cutting_fabric_components to authenticated;
create policy "Cladder owner access" on public.cutting_fabric_components for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.cutting_stage_movements enable row level security;
revoke all on public.cutting_stage_movements from anon;
grant select, insert, update, delete on public.cutting_stage_movements to authenticated;
create policy "Cladder owner access" on public.cutting_stage_movements for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.outsourcing enable row level security;
revoke all on public.outsourcing from anon;
grant select, insert, update, delete on public.outsourcing to authenticated;
create policy "Cladder owner access" on public.outsourcing for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.outsourcing_sizes enable row level security;
revoke all on public.outsourcing_sizes from anon;
grant select, insert, update, delete on public.outsourcing_sizes to authenticated;
create policy "Cladder owner access" on public.outsourcing_sizes for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.outsourcing_accessories enable row level security;
revoke all on public.outsourcing_accessories from anon;
grant select, insert, update, delete on public.outsourcing_accessories to authenticated;
create policy "Cladder owner access" on public.outsourcing_accessories for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.outsourcing_receipts enable row level security;
revoke all on public.outsourcing_receipts from anon;
grant select, insert, update, delete on public.outsourcing_receipts to authenticated;
create policy "Cladder owner access" on public.outsourcing_receipts for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
alter table public.accessory_stock enable row level security;
revoke all on public.accessory_stock from anon;
grant select, insert, update, delete on public.accessory_stock to authenticated;
create policy "Cladder owner access" on public.accessory_stock for all to authenticated
using (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com')
with check (lower((select auth.jwt() ->> 'email')) = '20saumay04@gmail.com');
grant usage on schema public to authenticated;
create function public.replace_relational_data(payload jsonb) returns void
language plpgsql security invoker set search_path = '' as $$
begin
 if coalesce(lower(auth.jwt() ->> 'email'), '') <> '20saumay04@gmail.com' then
  raise exception 'Not authorized' using errcode = '42501';
 end if;
 if jsonb_typeof(payload -> 'cuttings') is distinct from 'array' then raise exception 'Missing or invalid cuttings array'; end if;
 if jsonb_typeof(payload -> 'cutting_fabric_components') is distinct from 'array' then raise exception 'Missing or invalid cutting_fabric_components array'; end if;
 if jsonb_typeof(payload -> 'cutting_stage_movements') is distinct from 'array' then raise exception 'Missing or invalid cutting_stage_movements array'; end if;
 if jsonb_typeof(payload -> 'outsourcing') is distinct from 'array' then raise exception 'Missing or invalid outsourcing array'; end if;
 if jsonb_typeof(payload -> 'outsourcing_sizes') is distinct from 'array' then raise exception 'Missing or invalid outsourcing_sizes array'; end if;
 if jsonb_typeof(payload -> 'outsourcing_accessories') is distinct from 'array' then raise exception 'Missing or invalid outsourcing_accessories array'; end if;
 if jsonb_typeof(payload -> 'outsourcing_receipts') is distinct from 'array' then raise exception 'Missing or invalid outsourcing_receipts array'; end if;
 if jsonb_typeof(payload -> 'accessory_stock') is distinct from 'array' then raise exception 'Missing or invalid accessory_stock array'; end if;
 perform pg_advisory_xact_lock(67012345);
 delete from public.accessory_stock;
 delete from public.outsourcing_receipts;
 delete from public.outsourcing_accessories;
 delete from public.outsourcing_sizes;
 delete from public.outsourcing;
 delete from public.cutting_stage_movements;
 delete from public.cutting_fabric_components;
 delete from public.cuttings;
 insert into public.cuttings (id,batch_code,root_code,cut_group_id,parent_cutting_id,sku,common_name,garment_type,garment_label,gender,entry_date,current_stage,finished_goods_date,created_at) select id,batch_code,root_code,cut_group_id,parent_cutting_id,sku,common_name,garment_type,garment_label,gender,entry_date,current_stage,finished_goods_date,created_at from jsonb_populate_recordset(null::public.cuttings, payload -> 'cuttings');
 insert into public.cutting_fabric_components (cutting_id,fabric_code,avg_fabric_used,qty_used,correction) select cutting_id,fabric_code,avg_fabric_used,qty_used,correction from jsonb_populate_recordset(null::public.cutting_fabric_components, payload -> 'cutting_fabric_components');
 insert into public.cutting_stage_movements (cutting_id,size_code,stage,direction,qty,movement_type,moved_at) select cutting_id,size_code,stage,direction,qty,movement_type,moved_at from jsonb_populate_recordset(null::public.cutting_stage_movements, payload -> 'cutting_stage_movements');
 insert into public.outsourcing (id,cutting_id,work_type,vendor_name,sku,common_name,delivery_date,pending_delivery_date,created_at) select id,cutting_id,work_type,vendor_name,sku,common_name,delivery_date,pending_delivery_date,created_at from jsonb_populate_recordset(null::public.outsourcing, payload -> 'outsourcing');
 insert into public.outsourcing_sizes (outsourcing_id,size_code,qty) select outsourcing_id,size_code,qty from jsonb_populate_recordset(null::public.outsourcing_sizes, payload -> 'outsourcing_sizes');
 insert into public.outsourcing_accessories (outsourcing_id,elastic,button,tag,other_accessory) select outsourcing_id,elastic,button,tag,other_accessory from jsonb_populate_recordset(null::public.outsourcing_accessories, payload -> 'outsourcing_accessories');
 insert into public.outsourcing_receipts (id,outsourcing_id,qty,received_date) select id,outsourcing_id,qty,received_date from jsonb_populate_recordset(null::public.outsourcing_receipts, payload -> 'outsourcing_receipts');
 insert into public.accessory_stock (id,accessory_type,label,sku,common_name,qty,entry_date) select id,accessory_type,label,sku,common_name,qty,entry_date from jsonb_populate_recordset(null::public.accessory_stock, payload -> 'accessory_stock');
end;
$$;
revoke all on function public.replace_relational_data(jsonb) from public, anon;
grant execute on function public.replace_relational_data(jsonb) to authenticated;
insert into public.production_tracker_state(id,data) values ('main', '{"fabrics":[],"cuttings":[],"outsourcing":[],"accessoryStock":[],"trims":[]}');
commit;
