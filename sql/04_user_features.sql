-- Крок 4: таблиця на рівні користувача (1 рядок = 1 користувач із train)


DROP TABLE IF EXISTS user_features;

CREATE TABLE user_features AS
WITH last_tx AS (
  SELECT *
  FROM (
    SELECT *,
           ROW_NUMBER() OVER (
             PARTITION BY msno
             ORDER BY transaction_date DESC, expire_date DESC
           ) AS rn
    FROM transactions_clean
  )
  WHERE rn = 1
),
agg AS (
  SELECT
    msno,
    COUNT(*)                AS n_transactions,
    SUM(actual_amount_paid) AS total_paid,
    AVG(actual_amount_paid) AS avg_paid,
    SUM(is_cancel)          AS n_cancels,
    MIN(transaction_date)   AS first_tx_date,
    MAX(transaction_date)   AS last_tx_date
  FROM transactions_clean
  GROUP BY msno
)
SELECT
  t.msno,
  t.is_churn,
  l.payment_plan_days  AS last_plan_days,
  l.payment_method_id  AS last_payment_method,
  l.is_auto_renew      AS last_auto_renew,
  l.is_cancel          AS last_is_cancel,
  l.plan_list_price    AS last_list_price,
  l.actual_amount_paid AS last_amount_paid,
  a.n_transactions,
  a.total_paid,
  a.avg_paid,
  a.n_cancels,
  a.first_tx_date,
  m.city,
  m.age,
  m.gender,
  m.registered_via,
  m.registration_date
FROM train t
JOIN last_tx l ON t.msno = l.msno
JOIN agg a     ON t.msno = a.msno
LEFT JOIN members_clean m ON t.msno = m.msno;   -- LEFT JOIN: не втрачаємо користувачів без профілю
