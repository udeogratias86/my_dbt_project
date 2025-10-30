select
  staff_id,
  first_name,
  last_name,
  email,
  phone,
  store_id,
  active
from {{ ref('stg_local_bike__staffs') }}
