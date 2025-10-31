with
-- 1) Base : on sélectionne uniquement les colonnes utiles
base as (
  select
    order_id,
    customer_id,
    store_id,
    staff_id,
    order_status,
    order_date,
    required_date,
    shipped_date,
    product_id,
    quantity,
    gross_amount,
    net_amount
  from {{ ref('int_local_bike__sales_line') }}
),

-- 2) Agrégats au niveau commande (valeurs “any_value” stables + métriques)
order_agg as (
  select
    order_id,

    any_value(customer_id)   as customer_id,
    any_value(store_id)      as store_id,
    any_value(staff_id)      as staff_id,
    any_value(order_status)  as order_status,
    any_value(order_date)    as order_date,
    any_value(required_date) as required_date,
    any_value(shipped_date)  as shipped_date,  -- si toutes les lignes partagent la même date, sinon voir ship_agg

    date_trunc(any_value(order_date), month) as order_month,

    -- agrégats lignes → commande
    sum(quantity)                  as items_qty,
    count(*)                       as lines_count,
    count(distinct product_id)     as products_distinct_count,

    sum(gross_amount)              as order_gross_amount,
    sum(net_amount)                as order_net_amount,

    -- remise % pondérée au niveau commande
    case
      when sum(gross_amount) = 0 then null
      else 1 - (sum(net_amount) / sum(gross_amount))
    end                           as order_discount_pct
  from base
  group by order_id
),

-- 3) Agrégats logistiques (multi-expéditions)
ship_agg as (
  select
    order_id,
    min(shipped_date) as first_shipped_date,
    max(shipped_date) as last_shipped_date,
    -- flags
    countif(shipped_date is not null) > 0 as is_any_shipped,
    countif(shipped_date is null)  = 0    as is_fully_shipped
  from base
  group by order_id
),

-- 4) Lead times (calculés à partir des dates agrégées)
lead_times as (
  select
    oa.order_id,
    case
      when sa.first_shipped_date is null then null
      else date_diff(sa.first_shipped_date, oa.order_date, day)
    end as first_ship_lead_days,
    case
      when sa.last_shipped_date is null then null
      else date_diff(sa.last_shipped_date, oa.order_date, day)
    end as last_ship_lead_days
  from order_agg oa
  join ship_agg sa on sa.order_id = oa.order_id
)

-- 5) Résultat final
select
  oa.order_id,

  -- clés / dates
  oa.customer_id,
  oa.store_id,
  oa.staff_id,
  oa.order_status,
  oa.order_date,
  oa.required_date,
  -- shipped_date “header” (si identique sur toutes les lignes) + détails ship_agg
  oa.shipped_date,
  sa.first_shipped_date,
  sa.last_shipped_date,

  -- helpers
  oa.order_month,

  -- métriques commande
  oa.items_qty,
  oa.lines_count,
  oa.products_distinct_count,
  oa.order_gross_amount,
  oa.order_net_amount,
  oa.order_discount_pct,

  -- indicateurs logistiques
  sa.is_any_shipped,
  sa.is_fully_shipped,
  lt.first_ship_lead_days,
  lt.last_ship_lead_days

from order_agg oa
join ship_agg sa on sa.order_id = oa.order_id
join lead_times lt on lt.order_id = oa.order_id

