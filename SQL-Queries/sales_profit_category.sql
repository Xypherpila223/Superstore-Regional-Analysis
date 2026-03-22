SELECT "Category",
   round(SUM("Profit")::numeric, 2) AS "Total Profit"
FROM products
GROUP BY "Category"
ORDER BY "Total Profit" ASC;

