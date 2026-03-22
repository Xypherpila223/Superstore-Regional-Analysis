-- Total Profits 
-- Author: John Butch Gromontil
-- Date: 2026-03-21


/*
-- Retrievel Total Profit
-- 


*/





select ROUND(SUM("Profit"):: numeric,0) as "Total Profit"
from test;
