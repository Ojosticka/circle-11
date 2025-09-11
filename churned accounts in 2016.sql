-- Churned customers (50%+ drop in half year avg orders in 2016)

WITH base AS (
    SELECT 
        account_id, 
        DATE_TRUNC('month', occurred_at) AS month_yr, 
        SUM(total) AS all_orders
    FROM orders  
    GROUP BY account_id, DATE_TRUNC('month', occurred_at)
),
breakcte AS (
    SELECT 
        account_id, 
        AVG(CASE 
                WHEN month_yr BETWEEN '2016-01-01' AND '2016-06-01' 
                THEN all_orders ELSE 0 END) AS first6months,
        AVG(CASE 
                WHEN month_yr BETWEEN '2016-07-01' AND '2016-12-01' 
                THEN all_orders ELSE 0 END) AS last6months
    FROM base 
    GROUP BY account_id
)
SELECT 
    sub.account_id, 
    a.name AS account_name, 
    s.name AS sales_person, 
    sub.first6months, 
    sub.last6months, 
    sub.percentdiff
FROM (
    SELECT 
        *, 
        CASE 
            WHEN first6months = 0 THEN NULL 
            ELSE CAST((last6months - first6months) AS FLOAT) / first6months 
        END AS percentdiff
    FROM breakcte 
) sub
JOIN accounts a 
    ON sub.account_id = a.id 
LEFT JOIN sales_reps s 
    ON a.sales_rep_id = s.id
WHERE percentdiff <= -0.5;  -- drop greater than 50%



