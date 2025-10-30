select order_id, order_status
from {{ ref('stg_local_bike__orders') }}
where order_status < 0 or order_status > 10
