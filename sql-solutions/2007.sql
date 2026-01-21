--Link - https://platform.stratascratch.com/coding/2007-rank-variance-per-country?code_type=1

-- For each month, get total comment for each country and rank it
WITH country_comments_dec AS (
    SELECT
        a.country,
        SUM(c.number_of_comments) as total_comments_dec,
        DENSE_RANK() OVER (ORDER BY SUM(c.number_of_comments) DESC) as dec_rank
    FROM
        fb_comments_count c
    LEFT JOIN fb_active_users a ON c.user_id = a.user_id
    WHERE c.created_at BETWEEN '2019-12-01' AND '2019-12-31'
    GROUP BY a.country
    ),

country_comments_jan AS (
    SELECT
        a.country,
        SUM(c.number_of_comments) as total_comments_jan,
        DENSE_RANK() OVER (ORDER BY SUM(c.number_of_comments) DESC) as jan_rank
    FROM
        fb_comments_count c
    LEFT JOIN fb_active_users a ON c.user_id = a.user_id
    WHERE c.created_at BETWEEN '2020-01-01' AND '2020-01-31'
    GROUP BY a.country
    )

-- Join both tables to compare the rank
SELECT
    j.country,
    d.dec_rank,
    j.jan_rank
FROM
    country_comments_dec d
INNER JOIN
    country_comments_jan j ON d.country = j.country
WHERE
    j.jan_rank < d.dec_rank
