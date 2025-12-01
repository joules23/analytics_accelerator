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


