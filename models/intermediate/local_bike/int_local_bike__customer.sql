select
  customer_id,
  first_name,
  last_name,
  trim(concat(coalesce(first_name, ''), ' ', coalesce(last_name, ''))) as customer_full_name,
  email,
  city,
  state,
  zip_code
from {{ ref('stg_local_bike__customers') }}
