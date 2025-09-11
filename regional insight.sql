SELECT r.name AS region_name, 
	   COUNT(o.id) AS total_orders,
	   MIN(o.occurred_at) AS first_transaction_date,
	   MAX(o.occurred_at) AS last_transaction_date,
	   SUM(o.total_amt_usd) AS total_sales
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id 
GROUP BY r.name
 