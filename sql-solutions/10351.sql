--Link: https://platform.stratascratch.com/coding/10351-activity-rank?code_type=1

--Count emails sent by each user
WITH email_sent_table AS(
    SELECT
        from_user as user_id,
        COUNT(from_user) as total_email
    FROM
        google_gmail_emails
    GROUP BY from_user
)

-- Rank the table using total_email in descending order and user id to break ties
SELECT
    user_id,
    total_email,
    DENSE_RANK() OVER (ORDER BY total_email DESC, user_id ASC) as activity_rank
FROM
    email_sent_table;