select 
    date, 
    year, 
    quarter, 
    month, 
    year_month
from {{ ref('int_local_bike__date') }}
