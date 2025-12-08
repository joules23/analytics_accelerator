--Subqueries; run subquery first followed by the outer query (require an alias that comes after the parantheses)
--provide number of events for each day and channel, then average these values together using a second outer query
select DATE_TRUNC ('day', occurred_at) as day, count(*) as num_events, channel
from web_events
GROUP BY 1,3
ORDER BY 2 DESC;

--Now build subquery to find average
--remove order by in subquery, name subquery table
select channel, AVG(num_events) as avg_num_events
from
(select DATE_TRUNC ('day', occurred_at) as day, count(*) as num_events, channel
from web_events
GROUP BY 1,3) sub
GROUP BY 1
ORDER BY 2 DESC;

--first find the earliest order / month 
select DATE_TRUNC('month', min(occurred_at)) as earliest_month
from orders;

--then find only orders that took place in the same month and year as first order, then pull avg for each type of paper qty in this month
select avg(standard_qty) as avg_standard, avg(poster_qty) as avg_poster, avg(gloss_qty) as avg_gloss, sum(total_amt_usd) as total_amt
from orders
WHERE DATE_TRUNC ('month', occurred_at) =
(select DATE_TRUNC('month', min(occurred_at)) as earliest_month
from orders) ;

--name of sales_rep in each region with largest amount of total_amt_usd sales


SELECT t3.rep_name, t2.region_name, t2.max_total
FROM 
(select region_name, max(total_sales) as max_total
from (
  select s.name as rep_name, r.name as region_name, sum(o.total_amt_usd) as total_sales
  from sales_reps s
  join region r
  ON s.region_id = r.id
  join accounts a
  ON s.id = a.sales_rep_id
  join orders o
  ON a.id = o.account_id
  GROUP BY 1,2
  ORDER BY 3 DESC) AS T1
GROUP BY 1) t2

JOIN (select s.name as rep_name, r.name as region_name, sum(o.total_amt_usd) as total_sales
  from sales_reps s
  join region r
  ON s.region_id = r.id
  join accounts a
  ON s.id = a.sales_rep_id
  join orders o
  ON a.id = o.account_id
  GROUP BY 1,2
  ORDER BY 3 DESC) AS T3 

ON t2.region_name = t3.region_name AND t2.max_total = t3.total_sales; 






