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
