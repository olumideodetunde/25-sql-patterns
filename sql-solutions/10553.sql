--Link:https://platform.stratascratch.com/coding/10553-finding-purchases?code_type=1

-- Deduplicate the table to create a table of 1 buyer for each day
WITH dedup_table AS (
    SELECT DISTINCT
        user_id,
        created_at,
        item,
        revenue
    FROM
        amazon_transactions
    ),

-- Tag active buyers - find difference between transactions starting from earliest.
-- If difference between any 2 dates is between 1 and 7 days then we have an active customer
activity_tagged_table AS (
    SELECT
        user_id,
        CASE WHEN created_at::date - LAG(created_at::date) OVER (PARTITION BY user_id ORDER BY created_at ASC)
                  BETWEEN 1 AND 7
            THEN 'active'
            ELSE 'inactive'
        END as activity_tag
    FROM
        dedup_table
    )

-- Return active buyers
SELECT DISTINCT
    user_id
FROM
    activity_tagged_table
WHERE
    activity_tag='active';
