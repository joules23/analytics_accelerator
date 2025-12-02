--Inner Join
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


select region.name, sales_reps.name, accounts.name
from region
join sales_reps
ON sales_Reps.region_id = region.id
ORDER BY accounts name








