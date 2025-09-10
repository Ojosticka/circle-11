/* Sales Trends Over Time
This query shows total sales revenue per month with High/Low Sales  and  
Sales Trends Over Time by Region */

SELECT
    DATE_TRUNC('month', o.occurred_at) AS month,   -- Round the date to the first day of the month
    COUNT(o.id) AS total_orders,    -- Count how many orders happened in that month
	MAX(o.total_amt_usd) AS highest_order_value,
	MIN(o.total_amt_usd) AS lowest_order_value, 
    SUM(o.total_amt_usd) AS total_sales_revenue    
FROM orders o
GROUP BY DATE_TRUNC('month', o.occurred_at)        
ORDER BY month; 


-- Monthly Sales Trends by Region
SELECT
    DATE_TRUNC('month', o.occurred_at) AS month,  
    r.name AS region_name,                              
    COUNT(o.id) AS total_orders,                  
    SUM(o.total_amt_usd) AS total_sales_revenue,   
    ROUND(AVG(o.total_amt_usd), 2) AS avg_order_value
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps s ON a.sales_rep_id = s.id
JOIN region r ON s.region_id = r.id
GROUP BY DATE_TRUNC('month', o.occurred_at), r.name
ORDER BY month, region_name;
