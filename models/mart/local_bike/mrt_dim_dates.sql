select 
    date,
    cast(year as string) as year,
    cast(quarter as string) as quarter,
    cast(month as string) as month,
    year_month
from {{ ref('int_local_bike__date') }}