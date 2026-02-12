--Link: https://platform.stratascratch.com/coding/10048-top-businesses-with-most-reviews?code_type=1

-- Elegant solution to find the top 5 businesses with the most reviews in the Yelp dataset.
SELECT
    name,
    review_count
FROM
    yelp_business
ORDER BY
    review_count DESC
LIMIT 5