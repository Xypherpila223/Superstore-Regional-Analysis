-- KPI Total Sales Overview
-- Author: John Butch Gromontil
-- Date: 2026-03-21


/*
-- Retrievel Total Sales
-- Round to 0 decimal places]
-- Table: Products / Test (table_name)
-- Used as KPI Card
*/


select ROUND(SUM("Sales"):: numeric,0) as "Total Sales"
from test;
