-- Query: Total Sales & Profit by category
-- Author: John Butch Gromontil
-- Date: 2026-03-21

/* 

-- Retrieves Total Sales & Profit by Category
-- Rounded to decimal and sorted by profit and sales
-- From lowest to Highest profit and sales
-- Table: Products / Test (table_name)
-- this query used as my metric for dashboard

*/




select "Category", round(SUM("Profit")::numeric, 2) AS "Total Profit",
round(SUM("Sales")::numeric, 2) AS "Total Sales"
from products 
group by "Category"
order by "Total Profit", "Total Sales";
