select
  oi.order_id,
  oi.item_id,
  o.order_date,
  o.required_date,
  o.shipped_date,
  o.order_status,
  o.customer_id,
  o.store_id,
  o.staff_id,
  oi.product_id,
  p.product_name,
  p.model_year,
  c.category_name,
  b.brand_name,
  s.store_name,
  s.city  as store_city,
  s.state as store_state,
  s.zip_code as store_zip_code,
  st.first_name as staff_first_name,
  st.last_name  as staff_last_name,
  st.email      as staff_email,
  oi.quantity,
  oi.list_price as line_list_price,
  oi.discount   as line_discount,
  (oi.quantity * oi.list_price)                                 as gross_amount,
  (oi.quantity * oi.list_price) - coalesce(oi.discount, 0)      as net_amount
from {{ ref('stg_local_bike__order_items') }} oi
join {{ ref('stg_local_bike__orders') }}        o  on oi.order_id  = o.order_id
left join {{ ref('stg_local_bike__products') }} p  on oi.product_id = p.product_id
left join {{ ref('stg_local_bike__categories') }} c on p.category_id = c.category_id
left join {{ ref('stg_local_bike__brands') }}     b on p.brand_id    = b.brand_id
left join {{ ref('stg_local_bike__stores') }}     s on o.store_id    = s.store_id
left join {{ ref('stg_local_bike__staffs') }}     st on o.staff_id    = st.staff_id

