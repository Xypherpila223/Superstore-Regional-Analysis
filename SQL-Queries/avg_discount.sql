-- KPI total average discount overview
-- AUthor: John Butch Gromontil 
-- Date: 2026-03-21


/*
-- Overall average discount
-- round to 1 decimal place
-- Table: Products / test (table_name)
-- Used for KPI Dashboard Card
*/

SELECT 
   ROUND(AVG("Discount")::NUMERIC * 100, 1) AS "Average Discount %"
FROM products;
