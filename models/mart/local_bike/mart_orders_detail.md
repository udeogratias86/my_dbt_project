{% docs mart_orders_detail %}

The **`mart_orders_detail`** model represents the *detailed fact table for sales orders* in the mart layer.

It consolidates all relevant information from the `int_local_bike__sales_line` model and adds business-ready attributes for analytics and reporting.

### Business Purpose
This table provides **line-level detail** for all customer orders, integrating pricing, discount, stock, and logistics performance indicators.  
It is the primary source for dashboards analyzing:
- Sales performance by product, store, or staff member.
- Fulfillment and delivery timeliness.
- Discount and margin analysis at a granular level.

### Grain
**One row per order line item.**

### Main transformations
- Inherits computed financial metrics from the intermediate layer (`gross_amount`, `net_amount`).
- Adds calculated business indicators such as:
  - `discount_amount` = `line_discount × line_list_price`
  - Stock and delivery KPIs for operational performance tracking.

### Example use cases
- Daily and monthly sales reporting.
- Store and staff performance evaluation.
- Monitoring of low-stock or delayed shipments.

{% enddocs %}