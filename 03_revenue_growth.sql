-- Introducing window functions!
-- Window functions let you make computations based on
-- other rows in the dataset.
--
-- To calculate annual revenue growth for each year, we need
-- to use a formula referencing this year's growth and the
-- previous year's growth.
--
-- lag() is a window function that lets us do that. It lets
-- us reference the row previous to the current row.

with revenue_by_year as (
  -- This is a Common Table Expression (CTE). It lets us define
  -- a named temporary table that exists just for now.
  select  
    year,
    sum(price * quantity) revenue_total
  from orders
  inner join products on products.id = orders.product_id
  group by year
)
select
  revenue_by_year.*,
  ((revenue_total - (lag(revenue_total) over year_ordered))
    / (lag(revenue_total) over year_ordered)) revenue_growth

from revenue_by_year
window year_ordered as (order by year asc);
