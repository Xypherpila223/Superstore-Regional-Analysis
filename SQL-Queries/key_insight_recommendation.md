# Key Insights

## Furniture Profit Gap
Furniture generates $741K in sales (2nd highest) but only $18K in profit 
(2.49% margin) compared to 17% for other categories. 
Root cause is the highest average discount at 17%.

### Supporting Query
```sql
/*
 * Purpose  : Validate Furniture profit gap vs other categories.
 * Method   : SUM(Sales), SUM(Profit), Profit Margin %, AVG(Discount)
 * Table    : test
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
