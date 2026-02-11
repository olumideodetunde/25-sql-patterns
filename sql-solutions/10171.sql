--Link: https://platform.stratascratch.com/coding/10171-find-the-genre-of-the-person-with-the-most-number-of-oscar-winnings?code_type=1

--Create a base table using the names to join (weird)
WITH base_table AS (
    SELECT
        ons.*,
        ni.top_genre
    FROM
        oscar_nominees ons
    LEFT JOIN
        nominee_information ni ON ons.nominee = ni.name
    WHERE
        ons.winner = 'TRUE'
    ),

-- Get the number of awards and sort by award in desc and then by name alphabetically
awards_count_table AS (
    SELECT
        nominee,
        count(winner) as total_awards
    FROM
        base_table
    GROUP BY nominee
    ORDER BY count(winner) DESC, nominee ASC
    )

-- Add the genre with a left join and limit to one
SELECT
    bt.top_genre
FROM
    awards_count_table act
LEFT JOIN
    base_table bt on act.nominee = bt.nominee
LIMIT 1