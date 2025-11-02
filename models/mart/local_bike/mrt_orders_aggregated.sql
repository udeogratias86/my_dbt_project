
with order_metrics as (
  select
    order_id,
    order_date,
    required_date,
    shipped_date,
    order_status,
    customer_id,
    store_id,
    store_name,
    staff_first_name,
    staff_last_name,
    
    -- Indicateurs de finance 
    count(distinct order_item_id) as total_items,
    count(distinct product_id) as unique_products,
    sum(quantity) as total_quantity,
    round(sum(gross_amount), 2) as total_gross_amount,
    round(sum(net_amount), 2) as total_net_amount,
    round(avg(line_discount), 4) as avg_discount_rate,
    sum(case when line_discount > 0 then 1 else 0 end) as discounted_items_count,
    
    -- Indicateurs de stock 
    sum(case when stock_status = 'out_of_stock' then 1 else 0 end) as out_of_stock_items,
    sum(case when stock_status = 'low_stock' then 1 else 0 end) as low_stock_items,
    round(avg(stock_to_sales_ratio), 2) as avg_stock_to_sales_ratio,
    min(stock_quantity) as min_stock_quantity,
    max(stock_quantity) as max_stock_quantity,
    
    -- Indicateurs de logistique
    delivery_status as overall_delivery_status,
    delivery_performance_indicator as overall_performance,
    
    -- Métriques de délai 
    round(avg(processing_time_days), 2) as avg_processing_time_days,
    round(min(processing_time_days), 2) as min_processing_time_days,
    round(max(processing_time_days), 2) as max_processing_time_days,
    round(avg(delivery_margin_days), 2) as avg_delivery_margin_days

  from {{ ref('int_local_bike__sales_line') }}
  group by 
    order_id, order_date, required_date, shipped_date, order_status, 
    customer_id, store_id, store_name, staff_first_name, staff_last_name,
    delivery_status, delivery_performance_indicator
)

select 
  *,
  case 
    when total_items > 0 then 
      round((out_of_stock_items * 100.0 / total_items), 2)
    else 0
  end as out_of_stock_percentage,
  
  case 
    when total_items > 0 then 
      round((discounted_items_count * 100.0 / total_items), 2)
    else 0
  end as discount_percentage,
  
  case 
    when total_net_amount > 1000 then 'high_value'
    when total_net_amount > 500 then 'medium_value' 
    else 'low_value'
  end as order_value_category,
  
  case 
    when shipped_date is not null then 
      date_diff(shipped_date, order_date, day)
    else null
  end as actual_processing_days,
  
  -- Analyse de performance logistique
  case 
    when overall_delivery_status = 'immediate_pickup' then 'excellent'
    when overall_delivery_status = 'shipped_on_time' then 'good'
    when overall_delivery_status = 'shipped_late' then 'poor'
    else 'pending'
  end as delivery_performance,

  case 
    when out_of_stock_items > 0 then 'stock_risk'
    when overall_delivery_status = 'shipped_late' then 'delivery_risk'
    when shipped_date is null and current_date() > required_date then 'urgent_risk'
    else 'no_risk'
  end as risk_indicator,
  
  -- Score de performance (0-100)
  round(
    case 
      when overall_delivery_status = 'immediate_pickup' then 100
      when overall_delivery_status = 'shipped_on_time' then 90
      when overall_delivery_status = 'shipped_late' then 
        greatest(50, 90 - (abs(avg_delivery_margin_days) * 5))
      when shipped_date is null and current_date() <= required_date then 70
      when shipped_date is null and current_date() > required_date then 30
      else 60
    end, 2
  ) as performance_score,
  
  -- Rentabilité 
  round((total_gross_amount - total_net_amount), 2) as total_discount_amount,
  
  case 
    when total_gross_amount > 0 then 
      round(((total_gross_amount - total_net_amount) / total_gross_amount * 100), 2)
    else 0
  end as total_discount_rate,

  -- Autres
  case 
    when total_quantity > 0 then 
      round(total_net_amount / total_quantity, 2)
    else 0
  end as avg_price_per_unit,
  
  case 
    when total_items > 0 then 
      round(total_net_amount / total_items, 2)
    else 0
  end as avg_amount_per_item,

  case 
    when total_items >= 5 then 'bulk_purchase'
    when total_items >= 3 then 'medium_purchase'
    else 'single_purchase'
  end as purchase_size_category

from order_metrics