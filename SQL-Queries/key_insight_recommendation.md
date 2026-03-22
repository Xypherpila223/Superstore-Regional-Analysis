# Key Insights

## Furniture Profit Gap
Furniture generates $741K in sales (2nd highest) but only $18K in profit 
(2.49% margin) compared to 17% for other categories. 
Root cause is the highest average discount at 17%.

### Supporting Query
```sql
/*
 -- Purpose  : Validate Furniture profit gap vs other categories.
 -- Method   : SUM(Sales), SUM(Profit), Profit Margin %, AVG(Discount)
 -- Table    : test
 */

SELECT
    "Category",
    ROUND(SUM("Sales")::NUMERIC, 2)                                  AS "Total Sales",
    ROUND(SUM("Profit")::NUMERIC, 2)                                 AS "Total Profit",
    ROUND(SUM("Profit")::NUMERIC / SUM("Sales")::NUMERIC * 100, 2)  AS "Profit Margin %",
    ROUND(AVG("Discount")::NUMERIC * 100, 2)                        AS "Avg Discount %"
FROM test
GROUP BY "Category"
ORDER BY "Total Sales" DESC;
```

## Discount Kills Profit
Clear negative correlation found — orders with 40% or more discount consistently result in negative profit. The company is losing money on heavily discounted sales.

### Supporting Query
    ### Validation that 0.4 and 0.8 exist
``` sql
 -- Purpose  : Validate that discount values of 40% or more exist.
 -- Method   : COUNT orders and DISTINCT discount values WHERE Discount >= 0.4
 -- Used for : Data validation before analysis
 -- Table    : test

SELECT
    COUNT(*)                                        AS "Total Orders",
    COUNT(DISTINCT "Discount")                      AS "Unique Discount Levels",
    ROUND(MIN("Discount")::NUMERIC * 100, 0)        AS "Min Discount %",
    ROUND(MAX("Discount")::NUMERIC * 100, 0)        AS "Max Discount %"
FROM test
WHERE "Discount" >= 0.4;

```
### Proving High Discount affects profits
```sql
/*
 -- Purpose  : Prove that discounts of 40% or more
 --            consistently result in negative profit.
 -- Method   : GROUP BY Discount, AVG(Profit), COUNT orders.
 -- Filter   : WHERE Discount >= 0.4
 -- Format   : Rounded to 2 decimal places.
 -- Used for : Key Insight validation
 -- Table    : test
 */

SELECT
    ROUND("Discount"::NUMERIC * 100, 0)       AS "Discount %",
    COUNT(*)                                   AS "No. of Orders",
    ROUND(AVG("Profit")::NUMERIC, 2)           AS "Avg Profit",
    ROUND(SUM("Profit")::NUMERIC, 2)           AS "Total Profit",
    CASE
        WHEN AVG("Profit") < 0  THEN '🔴 Loss'
        WHEN AVG("Profit") = 0  THEN '🟡 Break Even'
        ELSE                         '🟢 Gain'
    END                                        AS "Profit Status"
FROM test
WHERE "Discount" >= 0.4
GROUP BY "Discount"
ORDER BY "Discount" ASC;

```

## Regional Underperformance

Central region has the lowest profit margin at 7.92% despite $501K in sales 
— the only region below the 10% benchmark. South at 11.94% sits below the 
regional average margin, indicating room for improvement. 
West leads at 14.94% profit margin.

### Supporting Query
  ### Validates Region Exist
```sql

/*
 * Purpose  : Validate all regions exist in the dataset.
 * Method   : COUNT orders and DISTINCT regions.
 * Used for : Data validation before analysis
 * Table    : test
 */

SELECT DISTINCT
    "Region",
    COUNT(*) AS "No. of Orders"
FROM test
GROUP BY "Region"
ORDER BY "Region" ASC;

```

 ### Proving that Central and South Region are underperforming

 ```sql

/*
 * Purpose  : Prove that Central is the only region below 10% benchmark,
 *            South sits below regional average, and West leads all regions.
 * Method   : CTE for regional summary and overall average margin.
 *            CASE flags based on 10% benchmark and regional average.
 * Formula  : SUM(Profit) / SUM(Sales) * 100
 * Format   : Rounded to 2 decimal places.
 * Used for : Key Insight — Regional Profit Performance
 * Table    : test
 */

WITH regional_summary AS (
    -- STEP 1: Calculate sales, profit and margin per region
    SELECT
        "Region",
        ROUND(SUM("Sales")::NUMERIC, 2)                                  AS "Total Sales",
        ROUND(SUM("Profit")::NUMERIC, 2)                                 AS "Total Profit",
        ROUND(SUM("Profit")::NUMERIC / SUM("Sales")::NUMERIC * 100, 2)  AS "Profit Margin %"
    FROM test
    GROUP BY "Region"
),
overall_avg AS (
    -- STEP 2: Calculate regional average margin as baseline
    SELECT ROUND(AVG("Profit Margin %")::NUMERIC, 2) AS "Avg Margin %"
    FROM regional_summary
)

-- STEP 3: Flag each region against 10% benchmark and regional average
SELECT
    r."Region",
    r."Total Sales",
    r."Total Profit",
    r."Profit Margin %",
    o."Avg Margin %",
    CASE
        WHEN r."Profit Margin %" < 10                THEN '🔴 Below 10% Benchmark'
        WHEN r."Profit Margin %" < o."Avg Margin %"  THEN '🟡 Below Regional Average'
        ELSE                                              '🟢 Above Regional Average'
    END                                               AS "Performance Status",
    CASE
        WHEN r."Profit Margin %" < 10
        THEN 'Underperforming — only region below 10% benchmark'
        WHEN r."Profit Margin %" < o."Avg Margin %"
        THEN 'Room for improvement — below regional average'
        WHEN r."Profit Margin %" = (SELECT MAX("Profit Margin %") FROM regional_summary)
        THEN 'Leads all regions in profit margin'
        ELSE 'Performing well'
    END                                               AS "Insight"
FROM regional_summary r
CROSS JOIN overall_avg o
ORDER BY r."Profit Margin %" ASC;

```
