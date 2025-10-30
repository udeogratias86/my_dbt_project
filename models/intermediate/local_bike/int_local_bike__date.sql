select
  d as date,
  extract(year    from d) as year,
  extract(quarter from d) as quarter,
  extract(month   from d) as month,
  format_date('%Y-%m', d) as year_month
from (
  select min(order_date) as min_d, max(order_date) as max_d
  from {{ ref('stg_local_bike__orders') }}
), unnest(generate_date_array(min_d, max_d)) as d