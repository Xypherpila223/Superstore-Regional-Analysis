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
## Growth Slowing

Sales grew +51% from 2014 to 2017 which is positive. However profit growth is slowing in 2017 — sales grew 20% but profit only grew 14%, suggesting discounting is eating into margins.

### Supporting Query


```sql
/*
 * Purpose  : Prove that sales grew +51% from 2014 to 2017 but
 *            profit growth is slowing — sales grew 20% in 2017
 *            but profit only grew 14%, suggesting discounts
 *            are eating into margins.
 * Method   : CTE for yearly totals, LAG() for YoY growth %.
 *            Outer query flags slowing profit growth.
 * Formula  : (Current - Previous) / Previous * 100
 * Format   : Rounded to 2 decimal places.
 * Used for : Key Insight — Year over Year Growth Trend
 * Table    : test
 */

WITH yearly_totals AS (
    -- STEP 1: Aggregate total sales and profit per year
    SELECT
        EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY'))  AS "Year",
        ROUND(SUM("Sales")::NUMERIC, 2)                         AS "Total Sales",
        ROUND(SUM("Profit")::NUMERIC, 2)                        AS "Total Profit"
    FROM test
    GROUP BY EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY'))
),
yoy_growth AS (
    -- STEP 2: Calculate year over year growth % using LAG
    SELECT
        "Year",
        "Total Sales",
        "Total Profit",
        ROUND(
            ("Total Sales" - LAG("Total Sales") OVER (ORDER BY "Year"))
            / LAG("Total Sales") OVER (ORDER BY "Year") * 100
        ::NUMERIC, 2)                                           AS "Sales Growth %",
        ROUND(
            ("Total Profit" - LAG("Total Profit") OVER (ORDER BY "Year"))
            / LAG("Total Profit") OVER (ORDER BY "Year") * 100
        ::NUMERIC, 2)                                           AS "Profit Growth %"
    FROM yearly_totals
)

-- STEP 3: Flag years where profit growth lags behind sales growth
SELECT
    "Year",
    "Total Sales",
    "Total Profit",
    "Sales Growth %",
    "Profit Growth %",
    CASE
        WHEN "Profit Growth %" IS NULL                        THEN '⚪ Baseline Year'
        WHEN "Profit Growth %" >= "Sales Growth %"            THEN '🟢 Profit Keeping Pace'
        WHEN "Profit Growth %" >= "Sales Growth %" * 0.8      THEN '🟡 Profit Slightly Lagging'
        ELSE                                                       '🔴 Profit Growth Slowing'
    END                                                       AS "Growth Status",
    CASE
        WHEN "Profit Growth %" IS NULL
        THEN 'Baseline — no prior year'
        WHEN "Profit Growth %" >= "Sales Growth %"
        THEN 'Profit growing in line with sales'
        WHEN "Profit Growth %" >= "Sales Growth %" * 0.8
        THEN 'Profit slightly lagging behind sales growth'
        ELSE
        'Profit growth slowing — discounting likely eating into margins'
    END                                                       AS "Insight"
FROM yoy_growth
ORDER BY "Year" ASC;

```


# Recommendations 

-- ================================================
-- RECOMMENDATIONS
-- ================================================
-- 1. Review Furniture discount policy
--    17% avg discount is the main cause of 2.49% margin.
--
-- 2. Cap discounts at 20% maximum
--    Data shows 40%+ discounts result in net losses.
--
-- 3. Invest more sales resources in Central and South regions
--    Both regions are underperforming below regional average margin.
--
-- 4. Focus growth strategy on Technology
--    Highest margin category at 17.4%.
--
-- 5. Investigate 2015 sales dip
--    Only year sales declined, worth investigating the cause.
-- ================================================


