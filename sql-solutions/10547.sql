--Link: https://platform.stratascratch.com/coding/10547-actor-rating-difference-analysis?code_type=1

-- Identify actors with more than 1 film and return 0 as difference and only film rating as both average and latest rating
WITH one_film_actors AS (
    SELECT
        actor_name,
        ROUND(SUM(film_rating)::NUMERIC, 2) as average_lifetime_rating,
        ROUND(SUM(film_rating)::NUMERIC, 2) as latest_rating,
        0 AS difference
    FROM actor_rating_shift
    GROUP BY actor_name
    HAVING COUNT(*) = 1
    ),

-- Calculate average life time rating, latest rating and difference for the other actors by excluding their names in this table

    -- Rank the ratings
other_actors_ranked_base AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY actor_name ORDER BY release_date DESC) as rating_ranked
    FROM
        actor_rating_shift
    WHERE actor_name NOT IN (SELECT actor_name FROM one_film_actors)
    ),

    -- Calculate the reacent ratings and average life time ratings as 2 tables
latest_rating_other_actor AS (
    SELECT
        actor_name,
        film_rating as latest_rating
    FROM
        other_actors_ranked_base
    WHERE
        rating_ranked=1
    GROUP BY
        actor_name, film_rating
    ),

average_lifetime_other_actor AS (
    SELECT
        actor_name,
        AVG(film_rating) as average_lifetime_rating
    FROM
        other_actors_ranked_base
    WHERE
        rating_ranked>1
    GROUP BY
        actor_name
    ),

-- Join both tables and get the difference
other_actors AS (
    SELECT
        a.actor_name,
        a.average_lifetime_rating,
        l.latest_rating,
        ROUND((l.latest_rating - a.average_lifetime_rating)::NUMERIC, 2) as difference
    FROM
        average_lifetime_other_actor a
    LEFT JOIN
        latest_rating_other_actor l ON a.actor_name = l.actor_name
    )

-- Union all one actor table and the other actor table - that should be it
SELECT
    actor_name,
    average_lifetime_rating,
    latest_rating,
    difference
FROM
    one_film_actors
UNION ALL
SELECT
    actor_name,
    average_lifetime_rating,
    latest_rating,
    difference
FROM
    other_actors