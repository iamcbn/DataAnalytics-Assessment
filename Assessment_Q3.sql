-- Getting the last transaction date
WITH last_transactions AS
  (SELECT 
    plan_id,
    owner_id,
    MAX(transaction_date) AS last_transaction_date
  FROM savings_savingsaccount
  WHERE confirmed_amount > 0 -- Considering inflow of money
  GROUP BY plan_id, owner_id)
 
  
SELECT
  l.plan_id,
  l.owner_id,
  CASE 
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund          = 1 THEN 'Investment'
  END AS `type`,
  l.last_transaction_date,
  DATEDIFF(CURDATE(), l.last_transaction_date) AS inactivity_days
FROM last_transactions l
JOIN plans_plan p 
  ON p.id = l.plan_id
WHERE 
  DATEDIFF(CURDATE(), l.last_transaction_date) > 365
  AND p.is_archived = 0
  AND p.is_deleted  = 0
  AND (p.is_regular_savings = 1 OR p.is_a_fund = 1) -- The task wants active accounts(savings and investments)
ORDER BY inactivity_days; -- Not a criterion but I think targeting recent inacitivity would be better than staled inactivity