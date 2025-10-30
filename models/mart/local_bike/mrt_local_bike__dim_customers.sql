select
  customer_id, 
  first_name, 
  last_name, 
  email, 
  city, 
  state, 
  zip_code
from {{ ref('int_local_bike__customer') }}

