--Link: https://platform.stratascratch.com/coding/10322-finding-user-purchases?code_type=1
-- Rank all purchases for each user id
WITH purchases_ranked AS (
 SELECT
    user_id,
    created_at,
    DENSE_RANK() OVER (PARTITION BY user_id ORDER BY created_at) as ranked
 FROM
    amazon_transactions
 ORDER BY
    user_id
),

-- Take the difference between purchase 1 and 2 for each user_id
purchase_difference_table AS (
    SELECT
        user_id,
        created_at,
        created_at - LAG(created_at) OVER (PARTITION BY user_id ORDER BY user_id) AS purchase_difference_in_days
    FROM
        purchases_ranked
    WHERE ranked IN (1,2)
)

-- Filter for user_ids where the difference is between 1 and 7
SELECT
    user_id
FROM
    purchase_difference_table
WHERE
    purchase_difference_in_days BETWEEN 1 AND 7;
