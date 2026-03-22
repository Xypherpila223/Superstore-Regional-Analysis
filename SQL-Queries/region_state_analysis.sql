-- Regional and State Performance Overview
-- Author: John Butch Gromontil
-- Date: 2026-03-21

/* 
-- region


*/





SELECT
    "Region",
    "State",
    ROUND(SUM("Sales")::NUMERIC, 2)                                        AS "Total Sales",
    ROUND(SUM("Profit")::NUMERIC, 2)                                       AS "Total Profit",
    ROUND(SUM("Profit")::NUMERIC / SUM("Sales")::NUMERIC * 100, 2)        AS "Profit Margin %"
FROM test
GROUP BY "Region", "State"
ORDER BY "Region" ASC, "Total Sales" DESC;
