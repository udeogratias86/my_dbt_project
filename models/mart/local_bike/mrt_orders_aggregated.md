{% docs mrt_orders_aggregated %}

The **`mrt_orders_aggregated`** model provides an **order-level aggregation** built from `int_local_bike__sales_line`.

### Business Purpose
Offer a single record **per order** with consolidated financials, stock signals, and logistics performance to support:
- Sales & margin tracking at order level
- Delivery timeliness monitoring
- Discount policies & stock risk oversight

### Grain
**One row per `order_id`.**

### Main Transformations
- Financial rollups (items, quantity, gross/net amounts, average discount)
- Stock rollups (low/out-of-stock counts, stock-to-sales ratio, min/max stock)
- Logistics rollups (processing times, delivery status/performance)
- Derived business KPIs:
  - `order_value_category`, `delivery_performance`, `risk_indicator`
  - `performance_score`, `total_discount_amount`, `total_discount_rate`
  - Unit economics (`avg_price_per_unit`, `avg_amount_per_item`)

### Example Use Cases
- Daily sales overview by store/AM
- SLA & delivery performance dashboards
- Discount & stock risk monitoring

{% enddocs %}
