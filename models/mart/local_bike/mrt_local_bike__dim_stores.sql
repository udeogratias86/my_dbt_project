select
  store_id,
  store_name,
  city,
  state,
  zip_code
from {{ ref('stg_local_bike__stores') }}
