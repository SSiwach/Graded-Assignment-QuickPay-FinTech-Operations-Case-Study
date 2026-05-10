---

## 1. Standardize Merchant Names

**Purpose:** Remove extra spaces and unify capitalization.  

**Formula (Transactions sheet, merchant name in M2):**
```excel
=TRIM(PROPER(M2))
````

**Result Examples:**

* `alpha mart` → `Alpha Mart`
* `BETA STORES` → `Beta Stores`

---

## 2. Standardize Transaction Date

**Purpose:** Convert all dates to a consistent Excel date format.

**Formula (raw date in B2):**

```excel
=DATE(RIGHT(B2,4), MID(B2,4,2), LEFT(B2,2))
```

**Format:** `yyyy-mm-dd`

---

## 3. Standardize Status Values

**Purpose:** Make status consistent (`CAPTURED`, `FAILED`, `CHARGEBACK`, `UNKNOWN`)

**Formula (status in F2):**

```excel
=IF(ISNUMBER(SEARCH("chargeback",F2)),"CHARGEBACK", IF(OR(ISNUMBER(SEARCH("fail",F2)),ISNUMBER(SEARCH("e05",F2))),"FAILED", IF(ISNUMBER(SEARCH("captured",F2)),"CAPTURED","UNKNOWN")))
```

---

## 4. Clean Risk Scores

**Purpose:** Extract numeric values from `score:62`, `risk-83`, or plain numbers.

**Formula (risk_score in G2):**

```excel
=VALUE(SUBSTITUTE(SUBSTITUTE(G2,"score:",""),"risk-",""))
```

* Fill missing values with the median if necessary.

---

## 5. Standardize Gateway Region

**Purpose:** Remove extra spaces and unify to uppercase.

**Formula (raw gateway in G2):**

```excel
=UPPER(TRIM(G2))
```

**Result Examples:**
`apac` → `APAC`, `eu` → `EU`, `us` → `US`

---

## 6. Convert Amounts to USD

**Columns:**

* Standardized date → N
* Currency → E
* Raw amount → D

**Exchange_rates sheet:**

* Columns: `rate_date` (Excel date), `currency`, `usd_rate.`
* Add helper column: `rate_key = rate_date_serial|currency`

**Transaction key formula (N2 = transaction date, E2 = currency):**

```excel
=TEXT(N2,"0") & "|" & E2
```

**USD Amount formula (Amount in D2):**

```excel
=D2 * INDEX(exchange_rates!$C$2:$C$19, MATCH(O2, exchange_rates!$D$2:$D$19, 0))
```

---

## 7. High Value Flag

**Purpose:** Flag high value transactions based on region-specific thresholds.

| Region | USD Threshold |
| ------ | ------------- |
| APAC   | > 5000        |
| EU     | > 6000        |
| US     | > 7000        |

**Formula (gateway in P2, USD amount in S2):**

```excel
=IF(AND(P2="APAC", S2>5000), 1,
    IF(AND(P2="EU", S2>6000), 1,
       IF(AND(P2="US", S2>7000), 1, 0)))
```

---

## 8. High Risk Flag

**Purpose:** Flag high risk transactions if risk_score ≥ 70 or status contains CHARGEBACK.

**Formula (status in O2, risk_score in Q2):**

```excel
=IF(OR(Q2>=70, ISNUMBER(SEARCH("CHARGEBACK", O2))), 1, 0)
```

---

## 9. Enrich Transactions with Merchant Master

**Merchant master columns:**
`A: merchant_id`, `B: merchant_name`, `C: account_manager`, `D: merchant_category`, `E: default_region`

**Step 1: Clean merchant_master names (F2):**

```excel
=TRIM(PROPER(B2))
```

**Step 2: Clean transaction merchant names (N2):**

```excel
=TRIM(PROPER(M2))
```

**Step 3: VLOOKUP to Enrich Transactions**

* Merchant ID:

```excel
=VLOOKUP(N2, merchant_master!$F$2:$J$6, 2, FALSE)
```

* Account Manager:

```excel
=VLOOKUP(N2, merchant_master!$F$2:$J$6, 3, FALSE)
```

* Merchant Category:

```excel
=VLOOKUP(N2, merchant_master!$F$2:$J$6, 4, FALSE)
```

* Default Region:

```excel
=VLOOKUP(N2, merchant_master!$F$2:$J$6, 5, FALSE)
```

**Step 4: Fill missing gateway region (P2):**

```excel
=IF(P2="", VLOOKUP(N2, merchant_master!$F$2:$J$6, 5, FALSE), P2)
```

---

## 10. Final Table Columns

| Column                    | Purpose                           |
| ------------------------- | --------------------------------- |
| transaction_id            | Original transaction ID           |
| transaction_date_clean    | Standardized date                 |
| merchant_name_clean       | Standardized merchant name        |
| merchant_id               | From merchant_master              |
| account_manager           | From merchant_master              |
| merchant_category         | From merchant_master              |
| standardized_gateway      | Cleaned and filled gateway region |
| raw_amount                | Original transaction amount       |
| currency                  | Original currency                 |
| Amount_USD                | Converted USD amount              |
| standardized_status_value | Cleaned status                    |
| risk_score_clean          | Cleaned risk score                |
| high_value_flag           | Flag for high value transactions  |
| high_risk_flag            | Flag for high-risk transactions   |




