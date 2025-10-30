select
  -- grain = ligne de commande
  oi.order_id,
  oi.item_id,

  -- dates & statut (depuis orders)
  o.order_date,
  o.required_date,
  o.shipped_date,
  o.order_status,

  -- clés
  o.customer_id,
  o.store_id,
  o.staff_id,
  oi.product_id,

  -- chiffres (depuis order_items)
  oi.quantity,
  oi.list_price as line_list_price,
  oi.discount   as line_discount,              -- % (0..1)

  -- montants
  (oi.quantity * oi.list_price)                                  as gross_amount,
  (oi.quantity * oi.list_price) * (1 - coalesce(oi.discount, 0)) as net_amount

from {{ ref('stg_local_bike__order_items') }} oi
join {{ ref('stg_local_bike__orders') }}     o
  on oi.order_id = o.order_id
