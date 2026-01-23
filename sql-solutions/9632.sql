--Link: https://platform.stratascratch.com/coding/9632-host-popularity-rental-prices?code_type=1

-- Create a flag for each popularity rating
WITH pop_table AS (
    SELECT
        id,
        price,
        CASE
            WHEN number_of_reviews=0 THEN 'New'
            WHEN number_of_reviews>0 AND number_of_reviews<6 THEN 'Rising'
            WHEN number_of_reviews>5 AND number_of_reviews<16 THEN 'Trending up'
            WHEN number_of_reviews>15 AND number_of_reviews<41 THEN 'Popular'
            ELSE 'Hot'
        END as popularity_flag
    FROM
        airbnb_host_searches
    )

-- Aggregate the min, avg and max rental price for each popularity rating
SELECT
    popularity_flag,
    MIN(price) as minimum_price,
    AVG(price) as average_price,
    MAX(price) as maximum_price
FROM
    pop_table
GROUP BY
    popularity_flag