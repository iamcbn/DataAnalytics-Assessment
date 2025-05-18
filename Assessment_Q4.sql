SELECT
  u.id AS customer_id,
  CONCAT(u.first_name, " ", u.last_name) AS name,
  TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
  COUNT(s.id) AS total_transactions,
  -- Calculating the CLV = (transaction/tenure) * 12 * avg_profit_per_txn
  ROUND(
    (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()),0)) -- NULLIF to prevent ~div/0 error
    * 12
    * AVG(s.confirmed_amount) * 0.001
  , 2) AS estimated_clv
FROM
  users_customuser u
LEFT JOIN
  savings_savingsaccount s
    ON s.owner_id = u.id
    AND s.confirmed_amount > 0    
GROUP BY u.id
ORDER BY estimated_clv DESC;
