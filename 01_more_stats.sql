-- We can do some slightly fancier stats using more
-- aggregate functions, like avg, max, and count.

select
  year,
  sum(price * quantity) revenue_total,
  avg(price * quantity) average_order_amount,
  max(order_date) most_recent_order_date,
  count(orders.id) count
from orders
inner join products on products.id = orders.product_id
group by year;
