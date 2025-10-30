select
  store_id, 
  store_name, 
  store_city, 
  store_state, 
  store_zip_code
from {{ ref('int_local_bike__store') }}
