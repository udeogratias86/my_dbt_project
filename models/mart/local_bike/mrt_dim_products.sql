select
  product_id, 
  product_name, 
  brand_name, 
  category_name,
  model_year, 
  list_price,
from {{ ref('int_local_bike__product') }}
