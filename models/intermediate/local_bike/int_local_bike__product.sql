select
  p.product_id,
  regexp_replace(p.product_name, r'\s*-\s*\d{4}.*$', '') as product_name,
  p.model_year,
  p.list_price,
  p.brand_id,
  b.brand_name,
  p.category_id,
  c.category_name
from {{ ref('stg_local_bike__products') }}   p
left join {{ ref('stg_local_bike__brands') }}     b on p.brand_id    = b.brand_id
left join {{ ref('stg_local_bike__categories') }} c on p.category_id = c.category_id
