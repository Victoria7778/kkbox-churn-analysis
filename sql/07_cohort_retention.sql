-- Крок 7: когортний аналіз


DROP TABLE IF EXISTS cohort_retention;

CREATE TABLE cohort_retention AS
WITH first_tx AS (
  SELECT msno, DATE_TRUNC('month', MIN(transaction_date))::DATE AS cohort_month
  FROM transactions_clean
  GROUP BY msno
),
activity AS (
  SELECT DISTINCT msno, DATE_TRUNC('month', transaction_date)::DATE AS active_month
  FROM transactions_clean
  WHERE transaction_date < '2017-03-01'
),
joined AS (
  SELECT f.cohort_month,
         DATE_DIFF('month', f.cohort_month, a.active_month) AS month_number,
         a.msno
  FROM first_tx f
  JOIN activity a USING (msno)
  WHERE f.cohort_month BETWEEN '2016-01-01' AND '2016-08-01'
)
SELECT cohort_month, month_number, COUNT(DISTINCT msno) AS users
FROM joined
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT * FROM cohort_retention LIMIT 20;
