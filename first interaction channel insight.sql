-- First interaction channel of clients

WITH base AS (
    SELECT 
        w.*, 
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY occurred_at) AS index_check
    FROM web_events w
)
SELECT 
    channel, 
    COUNT(*) AS gotten_clients
FROM base
WHERE index_check = 1   -- only first interaction
GROUP BY channel;