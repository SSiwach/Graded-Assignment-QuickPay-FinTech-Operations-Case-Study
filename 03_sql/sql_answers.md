-- Q1: 

SELECT
    standrized_status_value AS transaction_status,
    COUNT(transaction_id) AS transaction_count
FROM transactions
GROUP BY standrized_status_value;


-- Q2:

SELECT
    merchant_name_clean,
    SUM(amount_usd) AS total_captured_gmv
FROM transactions
WHERE standrized_status_value = 'CAPTURED'
GROUP BY merchant_name_clean;

-- Q3: 

SELECT
    merchant_name_clean,
    SUM(amount_usd) AS captured_gmv
FROM transactions
WHERE standrized_status_value = 'CAPTURED'
GROUP BY merchant_name_clean
ORDER BY captured_gmv DESC
LIMIT 10;

-- Q4: 

SELECT
    standard_date_format,
    SUM(amount_usd) AS daily_gmv,
    COUNT(transaction_id) AS successful_transaction_count
FROM transactions
WHERE standrized_status_value = 'CAPTURED'
GROUP BY standard_date_format
ORDER BY standard_date_format;

-- Q5: 

SELECT
    merchant_name_clean,
    COUNT(
        CASE
            WHEN standrized_status_value = 'CHARGEBACK'
            THEN 1
        END
    ) * 100.0 / COUNT(transaction_id) AS chargeback_ratio
FROM transactions
GROUP BY merchant_name_clean
HAVING COUNT(
        CASE
            WHEN standrized_status_value = 'CHARGEBACK'
            THEN 1
        END
    ) * 100.0 / COUNT(transaction_id) > 1;
    
    
-- Q6: 
SELECT
    default_region,
    AVG(standrized_risk_score) AS avg_risk_score,
    COUNT(transaction_id) AS transaction_count
FROM transactions
GROUP BY default_region
HAVING AVG(standrized_risk_score) > 50
   AND COUNT(transaction_id) > 20;
    
-- Q7: 

SELECT
    user_id,
    standard_date_format,
    COUNT(transaction_id) AS risky_transaction_count
FROM transactions
WHERE standrized_status_value IN ('FAILED', 'CHARGEBACK')
GROUP BY user_id, standard_date_format
HAVING COUNT(transaction_id) >= 3;


-- Q8: 

SELECT
    merchant_name_clean,
    COUNT(transaction_id) AS chargeback_count,
    COUNT(DISTINCT user_id) AS unique_affected_users,
    SUM(amount_usd) AS total_chargeback_amount
FROM transactions
WHERE standrized_status_value = 'CHARGEBACK'
GROUP BY merchant_name_clean;
