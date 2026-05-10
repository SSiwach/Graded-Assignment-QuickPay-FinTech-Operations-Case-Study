-- Q1: 

SELECT
    standrized_status_value AS transaction_status,
    COUNT(transaction_id) AS transaction_count
FROM transactions
GROUP BY standrized_status_value;
```
CAPTURED	19
FAILED	7
CHARGEBACK	4
```
-- Q2:

SELECT
    merchant_name_clean,
    SUM(amount_usd) AS total_captured_gmv
FROM transactions
WHERE standrized_status_value = 'CAPTURED'
GROUP BY merchant_name_clean;
```
Alpha Mart	29984.50
Beta Stores	33431.00
City Pharma	8640.00
Delta Travels	10300.00
```
-- Q3: 

SELECT
    merchant_name_clean,
    SUM(amount_usd) AS captured_gmv
FROM transactions
WHERE standrized_status_value = 'CAPTURED'
GROUP BY merchant_name_clean
ORDER BY captured_gmv DESC
LIMIT 10;
```
Beta Stores	33431.00
Alpha Mart	29984.50
Delta Travels	10300.00
City Pharma	8640.00
```

-- Q4: 

SELECT
    standard_date_format,
    SUM(amount_usd) AS daily_gmv,
    COUNT(transaction_id) AS successful_transaction_count
FROM transactions
WHERE standrized_status_value = 'CAPTURED'
GROUP BY standard_date_format
ORDER BY standard_date_format;


```
2026-03-01	26382.00	5
2026-03-02	11080.00	3
2026-03-03	16031.50	4
2026-03-04	13920.00	4
2026-03-05	6136.00	1
2026-03-06	8806.00	2
```

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

```
Alpha Mart	9.09091
Beta Stores	9.09091
Eco Home	50.00000
Delta Travels	25.00000
```
    
-- Q6: 
SELECT
    default_region,
    AVG(standrized_risk_score) AS avg_risk_score,
    COUNT(transaction_id) AS transaction_count
FROM transactions
GROUP BY default_region
HAVING AVG(standrized_risk_score) > 50
   AND COUNT(transaction_id) > 20;

```
APAC	65.2727	22
```
    
-- Q7: 

SELECT
    user_id,
    standard_date_format,
    COUNT(transaction_id) AS risky_transaction_count
FROM transactions
WHERE standrized_status_value IN ('FAILED', 'CHARGEBACK')
GROUP BY user_id, standard_date_format
HAVING COUNT(transaction_id) >= 3;

```
APAC	65.2727	22
```

-- Q8: 

SELECT
    merchant_name_clean,
    COUNT(transaction_id) AS chargeback_count,
    COUNT(DISTINCT user_id) AS unique_affected_users,
    SUM(amount_usd) AS total_chargeback_amount
FROM transactions
WHERE standrized_status_value = 'CHARGEBACK'
GROUP BY merchant_name_clean;

```
Alpha Mart	1	1	5400.00
Beta Stores	1	1	1711.00
Delta Travels	1	1	2500.00
Eco Home	1	1	6649.00
```
