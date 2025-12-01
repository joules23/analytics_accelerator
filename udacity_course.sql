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

select name, website, primary_poc
from accounts
where name = 'Exxon Mobil';
--**SQL requires single quotes not double quotes around text values ** 


--derived columns are calculated or computed column that is a combination of existing column and name it using AS
--include it in select statement; combines across columns for the same row
select standard_amt_usd/standard_qty AS unit_price,
  id, account_id
from orders
limit 10;

select poster_amt_usd/ (standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS revenue_percentage
from orders
limit 10;

--Using LIKE is also a filter that has a part within the text 
--All companies whose names start with 'C'
select name 
from accounts
where name like 'C%';

--All companies whose names contain string 'one' in the name
select name
from accounts
where name like '%one%';

--All companies whose names end with 's'
select name
from accounts
where name like '%s';


--Using IN as a filter of exact values numeric or text
--Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
select name, primary_poc, sales_rep_id
from accounts
where name IN ('Walmart', 'Target', 'Nordstrom');


select *
from web_events
where channel IN ('organic', 'adwords'); 

--Using NOT operator
select name, primary_poc, sales_rep_id
from accounts
where name NOT IN ('Walmart', 'Target', 'Nordstrom');

select *
from web_events 
where channel NOT IN ('organic', 'adwords');

select name
from accounts
where name NOT LIKE 'C%';

select name
from accounts
where name NOT LIKE '&one&';

select name
from accounts
where name NOT LIKE '%s';


--Using AND and BETWEEN
select *
from orders
where standard_qty >1000 AND poster_qty = 0 AND gloss_qty = 0;

select name
from accounts
where name NOT LIKE 'C%' AND name LIKE '%s';

select occurred_at, gloss_qty
from orders
where gloss_qty BETWEEN 24 AND 29;
--yes, the Between operator is inclusive; range endpoint data points are included in the output when using BETWEEN

select *
from web_events
where channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
order by occurred_at DESC;

--Using OR
select id
from orders
where gloss_qty >4000 OR poster_qty >4000;

select *
from orders
where standard_qty = 0 AND (gloss_qty >1000 OR poster_qty>1000);


select *
from accounts
where (name LIKE 'C%' OR name LIKE 'W%') 
  AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
  AND primary_poc NOT LIKE '%eana%');
















