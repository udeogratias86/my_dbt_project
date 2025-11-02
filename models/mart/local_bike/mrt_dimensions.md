{% docs mrt_dim_customers %}

### Dimension: Customers

The **`mrt_dim_customers`** model provides a unified customer reference table for reporting and analysis.

It consolidates basic customer identity and location data from the intermediate layer and standardizes full names.

**Grain:** one row per customer (`customer_id`).

**Business purpose:**
- Used to slice sales and profitability by customer or geography.
- Facilitates reporting by full customer name and location.

**Main fields:**
- `customer_id`: Unique customer identifier.
- `customer_full_name`: Concatenation of first and last name.
- `city`, `state`, `zip_code`: Geographic information for regional analysis.

{% enddocs %}


{% docs mrt_dim_dates %}

### Dimension: Dates

The **`mrt_dim_dates`** model represents a calendar dimension that allows time-based aggregations.

**Grain:** one row per calendar date.

**Business purpose:**
- Enables grouping and trend analysis by day, month, quarter, and year.
- Serves as a time reference for joining facts like `mart_orders_detail` and `mrt_orders_aggregated`.

**Main fields:**
- `date`: The base date key (YYYY-MM-DD).
- `year`, `quarter`, `month`: Derived date parts as strings.
- `year_month`: Period key for monthly aggregations.

{% enddocs %}


{% docs mrt_dim_products %}

### Dimension: Products

The **`mrt_dim_products`** model enriches product information with brand, category, and pricing attributes.

**Grain:** one row per product (`product_id`).

**Business purpose:**
- Core reference for product-related reporting and margin analysis.
- Enables drill-downs by category, brand, or model year.

**Main fields:**
- `product_id`: Unique product identifier.
- `product_name`: Descriptive name of the product.
- `brand_name`: Brand of the product (e.g., Trek, Giant).
- `category_name`: Product family or type.
- `model_year`: Model release year.
- `list_price`: Reference unit retail price.

{% enddocs %}


{% docs mrt_dim_stores %}

### Dimension: Stores

The **`mrt_dim_stores`** model consolidates information about all store locations.

**Grain:** one row per store (`store_id`).

**Business purpose:**
- Serves as a lookup table for store-level performance, sales, and logistics.
- Enables regional segmentation in dashboards.

**Main fields:**
- `store_id`: Unique store identifier.
- `store_name`: Human-readable store name.
- `store_city`, `store_state`, `store_zip_code`: Location attributes for geography-based aggregations.

{% enddocs %}
