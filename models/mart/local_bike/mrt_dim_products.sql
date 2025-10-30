select
  product_id, 
  product_name, 
  model_year, 
  list_price,
  brand_id, 
  brand_name, 
  category_id, 
  category_name
from {{ ref('int_local_bike__product') }}
