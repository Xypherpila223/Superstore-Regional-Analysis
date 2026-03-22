-- Total Profits 
-- Author: John Butch Gromontil
-- Date: 2026-03-21


/*
-- Retrievel Total Profit
-- Round to 0 decimal places
-- Used as KPI Card


*/





select ROUND(SUM("Profit"):: numeric,0) as "Total Profit"
from test;
