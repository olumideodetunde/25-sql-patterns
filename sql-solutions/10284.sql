-- Need the total unique users on the platform
WITH all_users AS (
    SELECT user1 AS users
    FROM
        facebook_friends
    UNION ALL
    SELECT user2
    FROM
        facebook_friends
),

all_users_distinct AS (
    SELECT DISTINCT users AS unique_users
    FROM
        all_users
),

-- For each users in either column, get number of connections and then sum it up
conn_table_1 AS (
    SELECT
        user1,
        COUNT(user2) OVER (PARTITION BY user1) AS connection1
    FROM
        facebook_friends
),

conn_table_2 AS (
    SELECT
        user2,
        COUNT(user1) OVER (PARTITION BY user2) AS connection2
    FROM
        facebook_friends
),

-- Get it all together
base AS (
    SELECT
        aud.unique_users,
        COALESCE(ct1.connection1, 0) AS connection_1,
        COALESCE(ct2.connection2, 0) AS connection_2
    FROM
        all_users_distinct AS aud
    LEFT JOIN
        conn_table_1 AS ct1
        ON
            aud.unique_users = ct1.user1
    LEFT JOIN
        conn_table_2 AS ct2 ON
        aud.unique_users = ct2.user2
),

calc AS (
    SELECT DISTINCT
        unique_users,
        connection_1,
        connection_2,
        connection_1 + connection_2 AS total_connections
    FROM base
)

SELECT
    unique_users,
    (total_connections::NUMERIC / (SELECT COUNT(unique_users) FROM calc)) * 100 AS popularity_percentage
FROM
    calc
