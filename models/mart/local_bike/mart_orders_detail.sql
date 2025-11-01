
select
  order_item_id,
  order_id,
  item_id,
  order_date,
  required_date,
  shipped_date,
  order_status,
  customer_id,
  store_id,
  staff_id,
  product_id,
  quantity,
  line_list_price,
  line_discount,
  gross_amount,
  net_amount,
  
  -- Indicateurs de stock
  stock_quantity,
  remaining_stock,
  stock_status,
  stock_to_sales_ratio,
  
  -- Indicateurs de performance logistique
  processing_time_days,
  delivery_margin_days,
  delivery_status,
  delivery_performance_indicator,
  
  -- Informations supplémentaires
  product_name,
  store_name,
  staff_first_name,
  staff_last_name,
  round((line_discount * line_list_price), 2) as discount_amount
  
from {{ ref('int_local_bike__sales_line') }}