select
  p.product_id,
  p.product_name,
  p.model_year,
  p.list_price,
  c.category_id,
  c.category_name,
  b.brand_id,
  b.brand_name
from {{ ref('stg_local_bike__products') }}   p
left join {{ ref('stg_local_bike__categories') }} c on p.category_id = c.category_id
left join {{ ref('stg_local_bike__brands') }}     b on p.brand_id    = b.brand_id