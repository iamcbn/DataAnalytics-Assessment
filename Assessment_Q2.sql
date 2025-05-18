WITH 
	-- Calculating the total trans and months
	user_trans AS
		(SELECT 
			owner_id,
			COUNT(*) AS total_transactions,
			TIMESTAMPDIFF(
				MONTH,
				MIN(transaction_date),
				MAX(transaction_date))
			+ 1 AS months_active -- The +1 is to account for the current month as timestampdiff does not do that
		FROM savings_savingsaccount
		GROUP BY owner_id),
    
    -- Calculating the average transaction per month and categorizing customers
	users_cat AS
		(SELECT
			owner_id,
            total_transactions/ months_active AS avg_mon_trans,
			CASE
			  WHEN (total_transactions/ months_active) >= 10 THEN 'High Frequency'
			  WHEN (total_transactions/ months_active) >= 3  THEN 'Medium Frequency'
			  ELSE 'Low Frequency'
			END AS frequency_category
		FROM user_trans)
        
        
SELECT
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_mon_trans), 1) AS avg_transactions_per_month
FROM users_cat
GROUP BY frequency_category
ORDER BY 
	CASE frequency_category
		WHEN "High Frequency" THEN 1
        WHEN "Medium Frequency" THEN 2
        ELSE 3
	END;
    

    
    

    