-- Link: https://platform.stratascratch.com/coding/9622-number-of-bathrooms-and-bedrooms?code_type=1

--Pull the avergage number of bedrooms and bathrooms for each property type in each city
SELECT
    city,
    property_type,
    AVG(bathrooms) as bathroom_avg,
    AVG(bedrooms) as bedroom_avg
FROM
    airbnb_search_details
GROUP BY
    city, property_type