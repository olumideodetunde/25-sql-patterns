WITH five_star_biz AS (
    SELECT
        *
    FROM
        yelp_business
    WHERE
        stars = 5
    ),

state_table AS (
    SELECT
        state,
        count(stars) as number_of_5_star_businesses
    FROM
        five_star_biz
    GROUP BY
        state
    ),

state_table_ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY number_of_5_star_businesses DESC) as top_state_ranking
    FROM
        state_table
    )


SELECT
    state,
    number_of_5_star_businesses
FROM
    state_table_ranked
WHERE
    top_state_ranking < 6
