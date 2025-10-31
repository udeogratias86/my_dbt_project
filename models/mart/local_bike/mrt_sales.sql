select
  -- grain & keys
  sl.order_id,
  sl.item_id,
  sl.customer_id,
  sl.store_id,
  sl.staff_id,
  sl.product_id,

  -- dates & statut
  sl.order_date,
  sl.required_date,
  sl.shipped_date,
  cast(sl.order_status as string) as order_status,

  -- attributs PRODUIT (via int)
  ip.product_name,
  cast(ip.model_year as string) as model_year,
  ip.category_name,
  ip.brand_name,

  -- attributs STORE (via int)
  isr.store_name,
  isr.store_city,
  isr.store_state,
  cast(isr.store_zip_code as string) as store_zip_code,

  -- attributs STAFF (via int)
  ist.first_name as staff_first_name,
  ist.last_name  as staff_last_name,
  ist.email      as staff_email,

  -- métriques
  sl.quantity,
  sl.line_list_price,
  sl.line_discount,         -- % (0..1)
  sl.gross_amount,
  sl.net_amount

from {{ ref('int_local_bike__sales_line') }} sl
left join {{ ref('int_local_bike__product') }} ip
  on sl.product_id = ip.product_id
left join {{ ref('int_local_bike__store') }} isr
  on sl.store_id = isr.store_id
left join {{ ref('int_local_bike__staff') }} ist
  on sl.staff_id = ist.staff_id

