-- Let's rank our revenue totals in our year and region
-- rollup. To accomplish this, we can use the window function rank().

with revenue_by_year_and_region as (
  select  
    year,
    region,
    sum(price * quantity) revenue_total
  from orders
  inner join products on products.id = orders.product_id
  inner join customers on customers.id = orders.customer_id
  group by rollup (year, region)
)
select
  revenue_by_year_and_region.*,
  case
  when region is not null then
    rank() over (partition by region is not null, year order by revenue_total desc)
  when year is not null then
    rank() over (partition by (region is null and year is not null) order by revenue_total desc)
  end sales_rank
from revenue_by_year_and_region
order by (case region is null when true then 2 else year end), sales_rank;
