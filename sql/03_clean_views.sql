CREATE OR REPLACE VIEW members_clean AS
SELECT
  msno,
  city,
  CASE WHEN bd BETWEEN 10 AND 80 THEN bd END AS age,   
  NULLIF(gender, '') AS gender,
  registered_via,
  strptime(CAST(registration_init_time AS VARCHAR), '%Y%m%d')::DATE AS registration_date
FROM members;

CREATE OR REPLACE VIEW transactions_clean AS
SELECT
  msno,
  payment_method_id,
  payment_plan_days,
  plan_list_price,
  actual_amount_paid,
  is_auto_renew,
  is_cancel,
  strptime(CAST(transaction_date AS VARCHAR), '%Y%m%d')::DATE        AS transaction_date,
  strptime(CAST(membership_expire_date AS VARCHAR), '%Y%m%d')::DATE  AS expire_date
FROM transactions;
