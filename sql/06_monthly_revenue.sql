-- Крок 6: виручка по місяцях


DROP TABLE IF EXISTS monthly_revenue;

CREATE TABLE monthly_revenue AS
SELECT
  DATE_TRUNC('month', transaction_date)::DATE AS month,
  COUNT(*)                          AS transactions,
  COUNT(DISTINCT msno)              AS paying_users,
  SUM(actual_amount_paid)           AS revenue,
  ROUND(AVG(actual_amount_paid), 2) AS avg_check,
  SUM(is_cancel)                    AS cancellations
FROM transactions_clean
WHERE transaction_date < '2017-03-01'
GROUP BY 1
ORDER BY 1;

SELECT * FROM monthly_revenue;

