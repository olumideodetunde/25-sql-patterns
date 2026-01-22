-- Link: https://platform.stratascratch.com/coding/10141-apple-product-counts?code_type=1

--Get apple users alongside language
WITH apple_users AS (
    SELECT
        e.user_id,
        u.language,
        e.device
    FROM
        playbook_events e
    INNER JOIN
        playbook_users u ON e.user_id=u.user_id
    WHERE
        device IN ('macbook pro', 'iphone 5s','ipad air')
    ),

-- Get the total users alongside language
all_users AS (
    SELECT
        e.user_id,
        u.language,
        e.device
    FROM
        playbook_events e
    INNER JOIN
        playbook_users u ON e.user_id=u.user_id
    ),

-- GROUP apple users by language
apple_user_grouped AS (
    SELECT
        language,
        COUNT(DISTINCT user_id) as n_apple_users
    FROM
        apple_users
    GROUP BY language
    ),

-- GROUP total users
total_user_grouped AS (
    SELECT
        language,
        COUNT(DISTINCT user_id) as n_total_users
    FROM
        all_users
    GROUP BY language
    )

-- Join both tables together
SELECT
    COALESCE(a.language, t.language) AS language,
    COALESCE(a.n_apple_users, 0) AS n_apple_users,
    t.n_total_users
FROM
    total_user_grouped t
LEFT JOIN
    apple_user_grouped a ON t.language = a.language
ORDER BY n_total_users DESC