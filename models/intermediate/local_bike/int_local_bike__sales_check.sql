select
  oi.order_item_id,
  oi.order_id,
  oi.item_id,
  o.order_date,
  o.required_date,
  o.shipped_date,
  o.order_status,
  o.customer_id,
  o.store_id,
  o.staff_id,
  oi.product_id,
  oi.quantity,
  oi.list_price as line_list_price,
  oi.discount   as line_discount,              
  (oi.quantity * oi.list_price)                                  as gross_amount,
  round((oi.quantity * oi.list_price) * (1 - coalesce(oi.discount, 0)),2) as net_amount,
  
  -- Indicateurs de stock
  s.quantity as stock_quantity,
  (s.quantity - oi.quantity) as remaining_stock,
  case 
    when (s.quantity - oi.quantity) <= 0 then 'out_of_stock'
    when (s.quantity - oi.quantity) < 10 then 'low_stock'
    else 'sufficient_stock'
  end as stock_status,
  case 
    when oi.quantity > 0 then round(s.quantity/ oi.quantity, 2)
    else null
  end as stock_to_sales_ratio,
  
  -- Indicateurs de performance logistique
  case 
    when o.shipped_date is not null then date_diff(o.shipped_date, o.order_date, day)
    when o.shipped_date is null and o.order_date = o.required_date then 0
    else null
  end as processing_time_days,
  
  case 
    when o.shipped_date is null and o.order_date = o.required_date then 0
    else date_diff(o.required_date, o.shipped_date, day)
  end as delivery_margin_days,
  
  case 
    when o.shipped_date is null and o.order_date = o.required_date then 'immediate_pickup'
    when o.shipped_date <= o.required_date then 'shipped_on_time'
    else 'shipped_late'
  end as delivery_status,
  
  case 
    when o.shipped_date is null and o.order_date = o.required_date then 'immediate'
    when o.shipped_date > o.required_date then 'warning'
    else 'good'
  end as delivery_performance_indicator,
  
  -- Informations supplémentaires pour l'analyse
  p.product_name,
  st.store_name,
  sta.first_name as staff_first_name,
  sta.last_name as staff_last_name

from {{ ref('stg_local_bike__order_items') }} oi
join {{ ref('stg_local_bike__orders') }}     o on oi.order_id = o.order_id
left join {{ ref('stg_local_bike__stocks') }} s on o.store_id = s.store_id and oi.product_id = s.product_id
left join {{ ref('stg_local_bike__products') }} p on oi.product_id = p.product_id
left join {{ ref('stg_local_bike__stores') }} st on o.store_id = st.store_id
left join {{ ref('stg_local_bike__staffs') }} sta on o.staff_id = sta.staff_id