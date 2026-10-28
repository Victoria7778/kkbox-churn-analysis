-- Крок 5: churn rate за сегментами


SELECT last_auto_renew, COUNT(*) AS users, SUM(is_churn) AS churned,
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2) AS churn_pct
FROM user_features GROUP BY 1 ORDER BY 1;

SELECT last_is_cancel, COUNT(*) AS users,
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2) AS churn_pct
FROM user_features GROUP BY 1 ORDER BY 1;

SELECT last_payment_method, COUNT(*) AS users,
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2) AS churn_pct
FROM user_features
GROUP BY 1 HAVING COUNT(*) >= 1000   -- відсікаємо рідкісні методи
ORDER BY users DESC;

-- Перевірка чи пояснює автопродовження різницю між методами оплати та каналами
SELECT last_payment_method, last_auto_renew, COUNT(*) AS users,
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2) AS churn_pct
FROM user_features
WHERE last_payment_method IN (38, 41, 36, 40, 39)
GROUP BY 1, 2 ORDER BY 1, 2;

SELECT registered_via, last_auto_renew, COUNT(*) AS users,
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2) AS churn_pct
FROM user_features
WHERE registered_via IS NOT NULL
GROUP BY 1, 2 ORDER BY 1, 2;

--  Єдина таблиця сегментів для Tableau 
DROP TABLE IF EXISTS segment_churn;

CREATE TABLE segment_churn AS
SELECT 'Автопродовження' AS segment,
       CASE WHEN last_auto_renew = 1 THEN 'Увімкнено' ELSE 'Вимкнено' END AS value,
       COUNT(*) AS users, SUM(is_churn) AS churned,
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2) AS churn_pct
FROM user_features GROUP BY 2

UNION ALL
SELECT 'Тривалість плану',
       CASE WHEN last_plan_days < 30 THEN '1) до 30 днів'
            WHEN last_plan_days = 30 THEN '2) 30 днів'
            WHEN last_plan_days <= 90 THEN '3) 31-90 днів'
            ELSE '4) понад 90 днів' END,
       COUNT(*), SUM(is_churn),
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2)
FROM user_features GROUP BY 2

UNION ALL
SELECT 'Скасування в останній транзакції',
       CASE WHEN last_is_cancel = 1 THEN 'Скасував' ELSE 'Не скасував' END,
       COUNT(*), SUM(is_churn),
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2)
FROM user_features GROUP BY 2

UNION ALL
SELECT 'Канал реєстрації',
       COALESCE('Канал ' || registered_via, 'профіль відсутній'),
       COUNT(*), SUM(is_churn),
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2)
FROM user_features GROUP BY 2

UNION ALL
SELECT 'Вік',
       CASE WHEN age IS NULL THEN 'невідомо'
            WHEN age < 18 THEN '10-17'
            WHEN age < 25 THEN '18-24'
            WHEN age < 35 THEN '25-34'
            WHEN age < 50 THEN '35-49'
            ELSE '50+' END,
       COUNT(*), SUM(is_churn),
       ROUND(100.0 * SUM(is_churn) / COUNT(*), 2)
FROM user_features GROUP BY 2;

SELECT * FROM segment_churn ORDER BY segment, value;
