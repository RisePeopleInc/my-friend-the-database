-- Time to slice-and-dice a bit. Let's do a little roll up!
-- rollup() is a grouping set clause that allows for hierarchical
-- grouping across multiple groups.

select
  year,
  region,
  sum(price * quantity) revenue_total
from orders
inner join products on products.id = orders.product_id
inner join customers on customers.id = orders.customer_id
group by rollup (year, region)
order by year, region;
