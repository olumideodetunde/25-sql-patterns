--Link: https://platform.stratascratch.com/coding/10134-spam-posts?code_type=1

-- Create a base table of posts that were viewed
WITH base_table AS (
    SELECT
        fp.post_date,
        fp.post_id,
        fp.post_keywords,
        fpv.viewer_id
    FROM
        facebook_posts fp
    INNER JOIN
        facebook_post_views fpv ON fp.post_id = fpv.post_id
)

-- Calculate percentage spam post for each day leveraging conditionals
SELECT
    post_date,
    (COUNT
        (CASE WHEN post_keywords like '%spam%' THEN post_id END)::NUMERIC /
    COUNT
        (post_id)) * 100 as percentage
FROM
    base_table
GROUP BY
    post_date