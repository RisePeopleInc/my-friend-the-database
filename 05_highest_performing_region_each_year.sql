-- Now we just want to know the top-performing sales region for
-- each year. We can use distinct on to accomplish this.
-- It will eliminate all duplicates based on the columns given
-- to distinct on, preserving only the top row for each group of
-- duplicates.
--
-- In this case, we are preserving only one row for each distinct
-- value for year, using our order by clause to ensure that the
-- highest-performing region is at the top.

select  
  distinct on (year)
  year,
  region,
  sum(price * quantity) revenue_total
from orders
inner join products on products.id = orders.product_id
inner join customers on customers.id = orders.customer_id
group by year, region
order by year, revenue_total desc;
