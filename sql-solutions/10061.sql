--Link: https://platform.stratascratch.com/coding/10061-popularity-of-hack?code_type=1

-- Find the average popularity of hack for each location of facebook employees
SELECT
    fe.location,
    AVG(fhs.popularity) as average_popularity_hack
FROM
    facebook_hack_survey fhs
LEFT JOIN
    facebook_employees fe ON fhs.employee_id=fe.id
GROUP BY
    fe.location