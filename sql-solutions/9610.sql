-- Use an inner subquery to identify the median score for sat_writing using percentile_cont function

-- Then identify ids of students that got just the median sat writing score

SELECT
    id
FROM
    sat_scores
WHERE
    sat_writing =  (
                    SELECT
                        PERCENTILE_CONT(0.5) WITHIN GROUP (
                        order by sat_writing
                        ) as median_sat_writing_score
                    FROM
                        sat_scores
                    )