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

--for region with largest total_amt_usd, how many total orders were placed
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
         SELECT MAX(total_amt)
         FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                 FROM sales_reps s
                 JOIN accounts a
                 ON a.sales_rep_id = s.id
                 JOIN orders o
                 ON o.account_id = a.id
                 JOIN region r
                 ON r.id = s.region_id
                 GROUP BY r.name) sub);

--with statement or CTEs (common table expressions) can help break down query into separate components so query logic is easier to follow 
--each CTE gets an alias and ust be referred to in the beginning to use in the final query

--find average number of events for each channel per day

select channel, avg(total_events) AS average_events
  from
(select date_trunc('day', w.occurred_at) AS day, w.channel, count(*) as total_events
from web_events w
GROUP BY 1,2) as t1
GROUP BY 1
ORDER BY 2 DESC;

--now using WITH statement
--first pull inner query, then use WITh statement labelled with an alias: events in this case

WITH events AS 
(select date_trunc('day', w.occurred_at) AS day, w.channel, count(*) as total_events
from web_events w
GROUP BY 1,2)

--final query pulls from the events table 

WITH events AS 
(select date_trunc('day', w.occurred_at) as day, w.channel, count(*) as total_events
from web_events w
GROUP BY 1,2) 

select channel, avg(events) AS average_events
from events 
group by 1
order by 2 desc;

--provide name of sales_rep in each region with the largest amount of total_amt_usd 
WITH sales AS 
(select s.name as sales_rep, r.name as region_name, sum(o.total_amt_usd) as total_amt
  from sales_reps s
  join accounts a
  ON s.id = a.sales_rep_id
  join orders o
  ON a.id = o.account_id
  join region r
  ON r.id = s.region_id
  GROUP BY 1,2
  ORDER BY 3 DESC),

t2 AS 
(select region_name, MAX(total_amt) as total_amt
  from sales
  GROUP BY 1)

select sales.sales_rep, sales.region_name, sales.total_amt
from sales
join t2
ON sales.region_name = t2.region_name AND sales.total_amt = t2.total_amt;
  
--calculate largest order, list sales rep name, region name, join all four tables ; group by total orders as one table
--second table calculates the max 
--final query joins the two tables to show region name, sales rep name, and total amt ; use same name for total and max for easier join.. 


--region with the largest sales total_amt_usd, how many total orders were placed (review this....)

WITH t1 AS (
      SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY r.name), 
t2 AS (
      SELECT MAX(total_amt)
      FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);


--for account that purchased the most standard_qty paper, how many accounts still had more in total purchases?
With t1 as (
  select a.name account_name, SUM(o.standard_qty) as total_std, SUM(o.total) as total
  from accounts a
  join orders o
  ON a.id = o.account_id
  GROUP BY 1
  ORDER BY 2 DESC
  limit 1),

t2 as 
(select a.name 
  from accounts a
  join orders o
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total from t1))

select count (*)
from t2 ; 


--customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?  
WITH t1 as (
  select a.id as id, a.name as customer, sum(o.total_amt_usd) as total_spent
  from accounts a 
  join orders o
  ON a.id = o.account_id 
  GROUP BY 1,2
  ORDER BY 3 DESC
  limit 1)

select a.name, w.channel, count (*)
from accounts a
join web_events w
ON a.id = w.account_id and a.id =(select id from t1) 
GROUP BY 1, 2
ORDER BY 3 DESC; 

--lifetime avg amt spent in terms of total_amt_usd for top 10 total spending accounts

WITH t1 as (
  select a.id, a.name, sum(o.total_amt_usd) as total_amt
  from accounts a
  join orders o
  ON a.id = o.account_id
  GROUP BY 1,2
  ORDER BY 3 DESC
  LIMIT 10)

select avg(total_amt) 
from t1;

--lifetime avg amt spent in terms of total_amt_usd including only companies that spent more per order on average than average of all orders

WITH t1 as (
  select avg(o.total_amt_usd) as avg_all
  from orders o
  join accounts a
  ON a.id = account_id), 

t2 as (
  select o.account_id, AVG(o.total_amt_usd) as avg_amt
  FROM orders o
  GROUP BY 1
  HAVING AVG(o.total_amt_usd) > (select * from t1))

select AVG (avg_amt)
from t2;




















