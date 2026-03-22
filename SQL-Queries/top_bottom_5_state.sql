-- Identify the top 5 and bottom 5 performing states
-- Author: John Butch Gromontil
-- Date: 2026-03-21

/* 
-- Top 5 and Bottom 5 States Analysis Validation
-- SUM(Sales) and SUM(Profit) grouped by State.
-- Rankings are split into best and worst performers.
-- UNION ALL combines top and bottom into a single table.
-- Result limit to 5 records each group (Top & Bottom)
-- Table: test (table_name)
*/ 

SELECT "Rank Group", "State", "Total Profit", "Total Sales"
FROM (

   SELECT * FROM (
      SELECT
         'Top 5' AS "Rank Group",
         "State",
         ROUND(SUM("Profit")::NUMERIC, 2) AS "Total Profit",
         ROUND(SUM("Sales")::NUMERIC, 2) AS "Total Sales"
      FROM test
      GROUP BY "State"
      ORDER BY "Total Profit" DESC
      LIMIT 5
   ) AS top_states

   UNION ALL

   SELECT * FROM (
      SELECT
         'Bottom 5' AS "Rank Group",
         "State",
         ROUND(SUM("Profit")::NUMERIC, 2) AS "Total Profit",
         ROUND(SUM("Sales")::NUMERIC, 2) AS "Total Sales"
      FROM test
      GROUP BY "State"
      ORDER BY "Total Profit" ASC
      LIMIT 5
   ) AS bottom_states

) AS combined
ORDER BY "Rank Group" DESC, "Total Profit" DESC;
