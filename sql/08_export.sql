-- Крок 8: експорт агрегованих таблиць для Tableau


COPY segment_churn   TO 'segment_churn.csv'   (HEADER);
COPY monthly_revenue TO 'monthly_revenue.csv' (HEADER);


COPY (
  SELECT *,
         FIRST_VALUE(users) OVER (PARTITION BY cohort_month ORDER BY month_number) AS cohort_size,
         ROUND(100.0 * users / FIRST_VALUE(users) OVER (PARTITION BY cohort_month ORDER BY month_number), 1) AS pct_of_cohort
  FROM cohort_retention
  WHERE month_number <= 12
) TO 'cohort_retention.csv' (HEADER);
