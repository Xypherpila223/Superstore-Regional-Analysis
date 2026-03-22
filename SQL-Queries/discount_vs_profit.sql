-- Discount VS Profit Analysis
-- Author: John BUtch Gromontil
-- Date: 2026-03-21

/* 
-- Shows the impact of discount on profits
-- includes all even with no discount
-- Table: Products / test (table_name)
*/

SELECT
    "Discount",
    ROUND("Profit"::numeric, 2) AS "Profit"
FROM products
ORDER BY "Discount" ASC;
