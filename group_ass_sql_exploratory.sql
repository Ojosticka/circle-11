-- No of orders facilitated by each sales rep

with account_salesrep as (
	SELECT a.id as account_id, s.name as salesrep
	FROM accounts a
	INNER JOIN sales_reps s ON a.sales_rep_id = s.id
)
SELECT sr.salesrep, count(o.id) as number_orders
FROM orders o
INNER JOIN account_salesrep sr ON o.account_id = sr.account_id
GROUP BY 1
ORDER BY number_orders DESC
LIMIT 10;

-- Insights
-- It was discovered that Earlie Schleusner facilitated the highest number of orders 335, while
-- Nakesha Renn is the salesrep with the least number of orders facilitated


-- Count the number of orders placed by each account every year

SELECT account_id, extract(year from occurred_at) as year, count(id) as no_orders
FROM orders
GROUP BY account_id, extract(year from occurred_at)
ORDER BY year;

-- Get the monthly running total of our best account

SELECT account_id, 
		DATE_TRUNC('month', occurred_at) as month, 
		sum(total_amt_usd) as total_revenue,
		sum(sum(total_amt_usd)) over(order by DATE_TRUNC('month', occurred_at) Rows Between unbounded preceding and current row) as running_total
FROM orders
GROUP BY account_id, DATE_TRUNC('month', occurred_at)
HAVING account_id = (
	with account as (
		SELECT account_id, sum(total_amt_usd) as total_revenue
		FROM orders
		GROUP BY 1
		ORDER BY total_revenue DESC
		LIMIT 1
	)
	SELECT account_id
	FROM account
	)
ORDER BY month;

-- Insights
-- 4211 is our best account and the table below shows its monthly running total
-- from dec 2013 to sep 2016

-- Top 10 performing accounts based on revenue

SELECT a.name as account_name, sum(o.total_amt_usd) as total_revenue
FROM orders o
INNER JOIN accounts a ON o.account_id = a.id
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;

-- Insights
-- EOG resources, Mosaic and IBM are the top three accounts




















