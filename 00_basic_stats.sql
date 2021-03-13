-- Let's start by just doing a basic sum on revenue.
-- sum() is an example of an aggregate function.
-- It requires a group by clause to say how we should be
-- grouping the data.

select
  year,
  sum(price * quantity) revenue_total
from orders
inner join products on products.id = orders.product_id
group by year;
