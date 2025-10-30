select *
from {{ ref('stg_local_bike__order_items') }}
where discount < 0
