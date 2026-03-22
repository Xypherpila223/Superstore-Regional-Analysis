

/*

 * Retrieves overall sales and profit growth percentage
 * from 2014 to 2017 using a subquery as the base.
 * Subquery aggregates total sales and profit per year.
 * Outer query compares 2014 vs 2017 using CASE pivot.
 * Formula  : (2017 - 2014) / 2014 * 100
 * Table    : test

*/


SELECT
    ROUND(
        (MAX(CASE WHEN "Year" = 2017 THEN "Total Sales" END) -
         MAX(CASE WHEN "Year" = 2014 THEN "Total Sales" END))
        / MAX(CASE WHEN "Year" = 2014 THEN "Total Sales" END) * 100
    ::NUMERIC, 0) AS "Sales Growth %",

    ROUND(
        (MAX(CASE WHEN "Year" = 2017 THEN "Total Profit" END) -
         MAX(CASE WHEN "Year" = 2014 THEN "Total Profit" END))
        / MAX(CASE WHEN "Year" = 2014 THEN "Total Profit" END) * 100
    ::NUMERIC, 2) AS "Profit Growth %"

FROM (
    SELECT
        EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY')) AS "Year",
        ROUND(SUM("Sales")::NUMERIC, 2)                        AS "Total Sales",
        ROUND(SUM("Profit")::NUMERIC, 2)                       AS "Total Profit"
    FROM test
    GROUP BY EXTRACT(YEAR FROM TO_DATE("Order Date", 'MM/DD/YYYY'))
) AS yearly;
