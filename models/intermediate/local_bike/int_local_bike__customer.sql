select
  customer_id,
  first_name,
  last_name,
  email,
  city,
  state,
  zip_code
from {{ ref('stg_local_bike__customers') }}
