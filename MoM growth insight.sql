WITH basecte as
(SELECT DATE_TRUNC('month', occurred_at) as monthyr, 
		SUM(total_amt_usd) as total_sales
FROM orders o
GROUP BY DATE_TRUNC('month', occurred_at)
),

lagcte as
(
SELECT *,
		LAG(total_sales) OVER (ORDER BY monthyr) as previous_month_sales
FROM basecte 
)

SELECT *, 
		(total_sales - previous_month_sales)/previous_month_sales as mom_growth
FROM lagcte