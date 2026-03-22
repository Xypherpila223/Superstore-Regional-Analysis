-- KPI: Profit Margin Overview
-- Author: John Butch Gromontil 
-- Date: 2026-03-21

/*




*/


SELECT
    ROUND(SUM("Profit"::numeric) / SUM("Sales"::numeric) * 100, 1) AS "Profit Margin %",
    CASE
        WHEN SUM("Profit"::numeric) / SUM("Sales"::numeric) * 100 >= 20  THEN 'Excellent'
        WHEN SUM("Profit"::numeric) / SUM("Sales"::numeric) * 100 >= 10  THEN 'Healthy'
        WHEN SUM("Profit"::numeric) / SUM("Sales"::numeric) * 100 >= 0   THEN 'High Risk'
        ELSE 'Negative'
    END AS "Margin Status"
FROM products;
