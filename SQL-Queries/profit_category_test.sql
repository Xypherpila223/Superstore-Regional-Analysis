-- Query: Total Profit by Category
-- Author: John Butch Gromontil
-- Date: 2026-03-2021

/* 

-- Retrieves the total profit per product category.
-- Rounded to decimal places and sorted
-- from lowest to highest proft.
-- table: products / test (table name) 
-- Data is split into separate groups but it is highly recommended to query against the full CSV dataset for more accurate results.
-- this was used to check if the query we will use is going to work by checking one side of information which is profit.
*/

SELECT "Category",
    ROUND(SUM("Profit")::numeric, 2) AS "Total Profit"  -- rounded to 2 decimal places
FROM products
GROUP BY "Category"                                      -- one row per category
ORDER BY "Total Profit" ASC;                            -- lowest profit first
