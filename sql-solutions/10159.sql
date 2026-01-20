--Link: https://platform.stratascratch.com/coding/10159-ranking-most-active-guests?code_type=1

-- The word total suggests that some grouping needs to be done and assumption that n_messages between each guest and host is unique. Grouping that first
WITH messages_grouped AS (
    SELECT
        id_guest,
        SUM(n_messages) as sum_of_n_messages
    FROM
        airbnb_contacts
    GROUP BY
        id_guest
)

-- Dense rank using summed up messages for each guest
SELECT
    DENSE_RANK() OVER (ORDER BY sum_of_n_messages DESC) as ranking,
    id_guest,
    sum_of_n_messages
FROM
    messages_grouped;