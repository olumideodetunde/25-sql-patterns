--Link -- https://platform.stratascratch.com/coding/10285-acceptance-rate-by-date?code_type=1

-- Get 2 tables - 1 for date request sent and the other for day request accepted
WITH request_sent_table AS (
    SELECT
        user_id_sender,
        user_id_receiver,
        date as sent_date
    FROM
        fb_friend_requests
    WHERE
        action='sent'
    ),


request_accepted_table AS (
    SELECT
        user_id_sender,
        user_id_receiver,
        date as accepted_date
    FROM
        fb_friend_requests
    WHERE
        action='accepted'
    ),

-- Join the above tables using both ids
both_merged AS (
    SELECT
        a.user_id_sender,
        a.user_id_receiver,
        a.sent_date,
        b.accepted_date
    FROM
        request_sent_table a
    LEFT JOIN
        request_accepted_table b ON a.user_id_sender = b.user_id_sender AND a.user_id_receiver = b.user_id_receiver
)

--calculate acceptance rate
SELECT
    sent_date as date,
    COUNT(accepted_date)::float /COUNT(sent_date) as percentage_acceptance
FROM
    both_merged
GROUP BY
    sent_date;
