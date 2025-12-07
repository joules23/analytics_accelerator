--Finding Null Data example
select * 
from demo.accounts
WHERE primary_poc = NULL --or can write IS NULL or IS NOT NULL for inverse 


--COUNT 
select COUNT(*) AS order_count
from demo.orders

--SUM can only be used on numeric columns (specify the column); however Sum will ignore null values
select SUM (poster_qty) as total_poster_sales
from orders; 

select SUM (standard_qty) as total_standard_sales
from orders;

select sum (total_amt_usd) as total_dollar_sales
from orders;

select standard_amt_usd + gloss_amt_usd AS total_standard_gloss
from orders;

select SUM (standard_amt_usd)/ SUM(standard_qty) AS standard_price_per_paper 
from orders;

--Min,Max, Average
select min(occurred_at)
from orders;

select occurred_at
from orders
ORDER BY occurred_at
limit 1;

select max(occurred_at)
from web_events;

select occurred_at
from web_events
ORDER BY occurred_at DESC
limit 1;

select AVG(standard_amt_usd) mean_standard_usd, AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd, AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, AVG(poster_qty) mean_poster
from orders;

--How to Find MEDIAN
SELECT *
FROM (SELECT total_amt_usd
         FROM orders
         ORDER BY total_amt_usd
         LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;


select accounts.name, orders.occurred_at
from accounts
join orders
on accounts.id = orders.account_id
order by occurred_at 
limit 1;

select accounts.name, SUM (total_amt_usd) AS total_sales
from orders
join accounts
ON accounts.id = orders.account_id
GROUP BY accounts.name;

select web_events.occurred_at, web_events.channel, accounts.name
from web_events
join accounts
ON web_events.account_id = accounts.id
ORDER BY web_events.occurred_at DESC
limit 1;

select web_events.channel, COUNT (*)
from web_events
GROUP BY web_events.channel;

select web_events.occurred_at, accounts.primary_poc
from web_events
join accounts
ON web_events.account_id = accounts.id
ORDER BY web_events.occurred_at
limit 1;

select accounts.name, min(total_amt_usd) AS smallest_order
from accounts
join orders
ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY smallest_order;

select region.name, count(sales_reps.id) as number_of_reps
from region
join sales_reps
on region.id = sales_reps.region_id
GROUP BY region.name
ORDER BY number_of_reps;


account name, avg quantity purchased for each of the paper types for each account

select accounts.name, avg(orders.standard_qty) AS avg_Standard_qty, avg(orders.poster_qty) AS avg_poster_qty, avg(orders.gloss_qty) as avg_gloss_qty
from accounts
join orders
ON accounts.id = orders.account_id
GROUP BY accounts.name;

select accounts.name, avg(orders.standard_amt_usd) AS Standard_amt, avg(orders.poster_amt_usd) AS poster_amt, avg(orders.gloss_amt_usd) as gloss_amt
from accounts
join orders
ON accounts.id = orders.account_id
GROUP BY accounts.name;

select sales_reps.name, web_events.channel, count(*) AS channel_used_frequency
from web_events
join accounts
ON web_events.account_id = accounts.id
join sales_reps
ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps.name, web_events.channel
ORDER BY channel_used_frequency DESC;

select region.name, web_events.channel, count(*) as channel_used_events
from web_events
join accounts
ON web_events.account_id = accounts.id
join sales_reps
ON accounts.sales_rep_id = sales_reps.id
join region
ON sales_reps.region_id = region.id
GROUP BY region.name, web_events.channel
ORDER BY channel_used_events DESc; 

select accounts.id as account_id , region.id as region_id, accounts.name as accounts_name, region.name as region_name
from accounts
join sales_reps
ON accounts.sales_rep_id = sales_reps.id
join region
ON sales_reps.region_id = region.id;

--351 results

Select DISTINCT id,name
FROM accounts;

--351 results as output of both queries meaning that every account is associated with only one region

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

--HAVING (where but for aggregations) 
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

--Date Functions: DATE_PART for pulling a specific portion of a date (no longer putting the year in order if you are pulling month)
--DATE_TRUNC truncates date to a particular part of your date-time column (keeps the whole date)
select DATE_PART('year', occurred_at) AS order_year, SUM(total_amt_usd) AS total_spent
from orders
GROUP BY occurred_at --or can write GROUP BY 1
ORDER BY total_spent DESC; --or can write GROUP BY 2

--month with greatest sales in usd; are all months evenly represented?
select DATE_PART ('month', occurred_at) as ord_month, COUNT(*) AS totalsales
from orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

--which month of which year did walmart spend on gloss paper in terms of dollars
select DATE_TRUNC ('year', occurred_at) as ord_month, SUM(gloss_amt_usd) as gloss_total, accounts.name
from orders
join accounts
ON accounts.id = orders.account_id
WHERE accounts.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
limit 1; 

--CASE 

