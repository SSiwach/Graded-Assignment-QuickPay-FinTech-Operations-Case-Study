CREATE DATABASE transactions;
USE  transactions;

CREATE TABLE transactions (
    transaction_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10),
    merchant_name_clean VARCHAR(100),
    default_region VARCHAR(20),
    standard_date_format DATE,
    standrized_status_value VARCHAR(20),
    standrized_risk_score INT,
    amount_usd DECIMAL(10,2)
);

INSERT INTO transactions (
    transaction_id,
    user_id,
    merchant_name_clean,
    default_region,
    standard_date_format,
    standrized_status_value,
    standrized_risk_score,
    amount_usd
)
VALUES
('T001','U001','Alpha Mart','APAC','2026-03-01','CAPTURED',62,4998),
('T002','U002','Alpha Mart','APAC','2026-03-01','CAPTURED',55,2499),
('T003','U003','Beta Stores','APAC','2026-03-01','CAPTURED',71,6069),
('T004','U004','Beta Stores','APAC','2026-03-02','FAILED',68,1920),
('T005','U001','Alpha Mart','APAC','2026-03-02','CAPTURED',58,4680),
('T006','U005','Beta Stores','APAC','2026-03-02','CAPTURED',64,3300),
('T007','U006','Alpha Mart','APAC','2026-03-02','CHARGEBACK',83,5400),
('T008','U007','Beta Stores','APAC','2026-03-03','CAPTURED',59,4114),
('T009','U002','Alpha Mart','APAC','2026-03-03','CAPTURED',46,1512.50),
('T010','U003','Beta Stores','APAC','2026-03-03','CAPTURED',77,7381),
('T011','U008','Alpha Mart','APAC','2026-03-03','FAILED',61,2359.50),
('T012','U009','Beta Stores','APAC','2026-03-04','CAPTURED',61,3000),
('T013','U010','Alpha Mart','APAC','2026-03-04','CAPTURED',54,3720),
('T014','U001','Beta Stores','APAC','2026-03-04','CAPTURED',73,5640),
('T015','U002','Alpha Mart','APAC','2026-03-04','CAPTURED',52,1560),
('T016','U008','Beta Stores','APAC','2026-03-05','FAILED',69,2596),
('T017','U008','Beta Stores','APAC','2026-03-05','FAILED',72,2124),
('T018','U008','Beta Stores','APAC','2026-03-05','CHARGEBACK',86,1711),
('T019','U008','Alpha Mart','APAC','2026-03-05','FAILED',67,3068),
('T020','U005','Alpha Mart','APAC','2026-03-05','CAPTURED',75,6136),
('T021','U006','Beta Stores','APAC','2026-03-06','CAPTURED',63,3927),
('T022','U007','Alpha Mart','APAC','2026-03-06','CAPTURED',60,4879),
('T023','U003','City Pharma','EU','2026-03-01','CAPTURED',42,5616),
('T024','U004','Eco Home','EU','2026-03-02','CHARGEBACK',65,6649),
('T025','U005','City Pharma','EU','2026-03-03','CAPTURED',38,3024),
('T026','U006','Eco Home','EU','2026-03-05','FAILED',44,3597),
('T027','U007','Delta Travels','US','2026-03-01','CAPTURED',49,7200),
('T028','U008','Delta Travels','US','2026-03-02','CAPTURED',41,3100),
('T029','U009','Delta Travels','US','2026-03-04','CHARGEBACK',58,2500),
('T030','U010','Delta Travels','US','2026-03-06','FAILED',47,1800);


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

    
    
    




