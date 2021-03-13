-- We want the revenue by year, with the top three sales reps
-- for each year. We will represent the top reps as JSON
-- objects that include the rep's name and revenue total. 
--
-- To accomplish this, we use a couple of different techniques:
-- 
-- * A lateral join, which lets us perform a join that references a value
-- from the current row within the join's table expression.
-- * JSON creation and aggregate functions.
-- * A CTE using grouping sets to pre-compute some values.


with order_details as (
  select  
    year,
    sales_reps.id rep_id,
    sales_reps.name rep_name,
    price * quantity order_total
  from orders
  inner join sales_reps on sales_reps.id = orders.sales_rep_id
  inner join products on products.id = orders.product_id
),
order_revenue_aggregations as (
  select  
    year,
    rep_id,
    rep_name,
    sum(order_total) revenue_total
  from order_details
  group by grouping sets (
    (year),
    (year, rep_id, rep_name)
  )
)
select
  year,
  revenue_total,
  jsonb_agg(top_reps.rep_detail) top_reps
from order_revenue_aggregations
inner join lateral (
  select
    jsonb_build_object(
      'rep_name',  rep_name,
      'revenue_total', revenue_total
    ) rep_detail
  from order_revenue_aggregations a2
  where
    a2.year = order_revenue_aggregations.year and a2.rep_id is not null
  order by revenue_total desc
  limit 3
) top_reps on true
where rep_id is null
group by year, revenue_total
