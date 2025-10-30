select
  store_id,
  store_name,
  city as store_city,
  state as store_state,
  zip_code as store_zip_code
from {{ ref('stg_local_bike__stores') }}
