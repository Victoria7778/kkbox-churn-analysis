-- Крок 2: перевірка якості даних

-- Дублікати користувачів 
SELECT msno, COUNT(*) AS c FROM train GROUP BY msno HAVING c > 1 LIMIT 5;

-- Аномалії у віці 
SELECT
  COUNT(*) FILTER (WHERE bd <= 0)             AS zero_or_neg,
  COUNT(*) FILTER (WHERE bd BETWEEN 1 AND 9)  AS under_10,
  COUNT(*) FILTER (WHERE bd > 80)             AS over_80,
  COUNT(*) FILTER (WHERE bd BETWEEN 10 AND 80) AS ok
FROM members;

-- Пропуски в gender
SELECT gender, COUNT(*) FROM members GROUP BY gender;

-- Користувачі з train без профілю або без транзакцій
SELECT
  COUNT(*) AS train_users,
  COUNT(*) FILTER (WHERE msno NOT IN (SELECT msno FROM members))      AS no_profile,
  COUNT(*) FILTER (WHERE msno NOT IN (SELECT msno FROM transactions)) AS no_trans
FROM train;

-- Загальний churn
SELECT is_churn, COUNT(*) FROM train GROUP BY is_churn;
