select
  product_id,
  regexp_replace(product_name, r'\s*-\s*\d{4}.*$', '') as product_name,  
  brand_id,
  category_id,
  model_year,
  list_price
from {{ source('local_bike', 'products') }}