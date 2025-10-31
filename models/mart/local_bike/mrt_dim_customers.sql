select
  customer_id, 
  first_name as customer_first_name, 
  last_name as customer_last_name, 
  trim(concat(coalesce(first_name, ''), ' ', coalesce(last_name, ''))) as customer_full_name,
  city, 
  state, 
  zip_code
from {{ ref('int_local_bike__customer') }}
