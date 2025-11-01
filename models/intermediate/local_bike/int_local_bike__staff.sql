select
  staff_id,
  first_name,
  last_name,
  trim(concat(coalesce(first_name, ''), ' ', coalesce(last_name, ''))) as staff_full_name,
  email,
  phone,
  store_id,
  active
from {{ ref('stg_local_bike__staffs') }}
