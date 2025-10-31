select
  order_id,
  customer_id,
  order_status,
  cast(order_date as date) as order_date,
  cast(required_date as date) as required_date,
  safe.parse_date('%Y-%m-%d', nullif(shipped_date, 'NULL')) as shipped_date,
  store_id,
  staff_id
 from {{ source('local_bike', 'orders') }}