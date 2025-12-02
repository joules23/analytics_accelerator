--Inner Join only returns rows that appear in both tables (center of a venn diagram) 
select orders.*
from orders
join accounts
ON orders.account_id = accounts.id;

--from is first table; join indicates second table
--on specifies column to merge the two tables together

select accounts.name, orders.occurred_at
from orders 
join accounts
ON orders.account_id = accounts.id;

SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

select accounts.*, orders.*
from orders
join accounts
ON orders.account_id = accounts.id;

select orders.standard_qty, orders.gloss_qty, orders.poster_qty,
  accounts.website, accounts.primary_poc
from orders
join accounts
ON orders.account_id = accounts.id;


select accounts.primary_poc, accounts.name,
  web_events.occurred_at, web_events.channel
from web_events
join accounts
ON web_events.account_id = accounts.id
where name = 'Walmart';

--can use ALIAS by using the abbreviation first in the SELECT statement followed by the abbreviation next to the full name in the from statement
select a.primary_poc, a.name,
  w.occurred_at, w.channel
  from web_events w
  join accounts a
  ON w.account_id = a.id
  where a.name = 'Walmart';



select region.name, sales_reps.name, accounts.name
from region
join sales_reps
ON sales_Reps.region_id = region.id
join accounts
ON accounts.sales_rep_id = sales_reps.id
ORDER BY accounts.name;

select r.name region, s.name rep, a.name account
from region r
join sales_reps s
ON r.id = s.region_id
join accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

select r.name, s.name, a.name
from region r
join sales_reps s
ON r.id = s.region_id
join accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;
--check why these outputs are different? because the same column is present in all three tables "name from acounts" gets duplicated so must specify the alias afer each selected column


SELECT r.name region, a.name account, 
           o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;


--Left Join, Right Join, or Full Outer Join (think of venn diagram); left join includes whatever values are unique to the left + all shared values










