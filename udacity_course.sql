--BASIC SQL
--"*" selects all 
select * 
from demo.orders;

--LIMIT to limit the # of rows returned
select occurred_at, account_id, channel
from web_events
limit 15;

--ORDER BY to sort results in any column temporarily until next query
--occurs before limit statement
--default is ascending but can specify DESC for descending order after specified column

--Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
select id, occurred_at, total_amt_usd
from orders
ORDER BY occurred_at
limit 10;

--Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
select id, account_id, total_amt_usd
from orders
order by total_amt_usd DESC
limit 5;

--Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
select id, account_id,total_amt_usd
from orders
order by total_amt_usd
limit 20;

--can use ORDER BY for more than one column at a time by providing list of columns
select id, account_id, total_amt_usd
from orders
order by account_id, total_amt_usd DESC;

select id, account_id, total_amt_usd
from orders
order by total_amt_usd DESC, account_id

--in first query, all the orders for each account ID were grouped together and then within that, the orders are descending
--in the second query, orders appear from greatest to least regardless of account ID only if the orders had equal total dollar amount

--WHERE statement acts as a filter and comes before order by
select *
from orders
where gloss_amt_usd >= 1000
order by gloss_amt_usd
limit 5;

select *
from orders
where total_amt_usd < 500
order by total_amt_usd
limit 10;



