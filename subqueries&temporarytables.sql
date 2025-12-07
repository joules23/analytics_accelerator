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

