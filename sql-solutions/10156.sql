-- Get all units that are apartment owned by hosts under 30
WITH base_table_under_30 AS (
    SELECT
        au.unit_id,
        ah.age,
        ah.nationality
    FROM
        airbnb_hosts ah
    INNER JOIN
        airbnb_units au ON ah.host_id = au.host_id
    WHERE ah.age < 30 AND au.unit_type = 'Apartment'
    )

-- Group by the nationality and get distinct count of units for each nationality - sort in descending order
SELECT
    nationality,
    COUNT(DISTINCT unit_id) as total_unit_count
FROM
    base_table_under_30
GROUP BY
    nationality
ORDER BY total_unit_count DESC