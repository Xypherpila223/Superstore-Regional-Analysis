-- Overall discount overview
-- AUthor: John Butch Gromontil 
-- Date: 2026-03-21


/*
-- 

*/
SELECT 
   ROUND(AVG("Discount")::NUMERIC * 100, 1) AS "Average Discount %"
FROM products;
