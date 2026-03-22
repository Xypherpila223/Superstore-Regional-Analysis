-- Year over Year Trend Analysis
-- AUthor: John Butch Gromontil
-- Date: 2026-03-21

/* 
-- Calculates Sales and Profit as well as Growth vs Previous year.
-- Lag() window function too look back column / function to compare current vs prior year
-- (current year - previous year)  / previous year * 100 to get growth &
-- Used for Year over Year Dashboard
-- Table: test(table_name)
*/

SELECT
    "Year",
    "Total Sales",
    "Total Profit",
    ROUND(
        ("Total Sales" - LAG("Total Sales") OVER (ORDER BY "Year"))
        / LAG("Total Sales") OVER (ORDER BY "Year") * 100
    ::NUMERIC, 2) AS "Sales Growth %",
    ROUND(
        ("Total Profit" - LAG("Total Profit") OVER (ORDER BY "Year"))
        / LAG("Total Profit") OVER (ORDER BY "Year") * 100
    ::NUMERIC, 2) AS "Profit Growth %"
FROM (
    SELECT
        EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY')) AS "Year",
        ROUND(SUM("Sales")::NUMERIC, 2)                        AS "Total Sales",
        ROUND(SUM("Profit")::NUMERIC, 2)                       AS "Total Profit"
    FROM test
    GROUP BY EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY'))
) AS yearly
ORDER BY "Year" ASC;
