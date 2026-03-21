# Superstore-Regional-Analysis
This Project Analyze the Saample Superstore dataset to identify businness bperformance gaps and regional underperfornnabce across the United State. The Analysis was built to simulate a real-world business intellegence task assigned by stake holders

## Stakeholders Problem Statement
"I need a complete business performance report. The centerpiece must answer why some regions and states are underperforming, and what we should do about it. I want data-backend recommendation, not just pretty charts" - Sales Director

## Problem Addressed

| Problem 1  | Problem 2 |
| ------------- | ------------- |
| Which regions and states are underperforming in sales and profits  | Full Businesss performance review for board-level presentation  |

## Dataset Information
| Detail  | Link |
| ------------- | ------------- |
|   Kaggle            |     kaggle.com/datasets/vivek468/superstore-dataset-final      |

## Metrics Used 

| Metrics  | Formula / column |   Purpose | 
| ------------- | ------------- | ------------- |
| Total Sales  | Sum(sales) |   overall revenue / sales | 
| Total Profit  | Sum(profit) |   overall actual earning after cost | 
| Profit Margin  | Sum(profit) / sum(sales) * 100 |   Operational Effiency  | 
| AVG Discount  | avg(discount) * 100 |   Discount impact on profit | 
| Sales & Profit by Category  | sum(sales) and sum(profits) group by Category  |  Category Performance | 
| Sales & Profit by Region |  sum(sales) and sum(profits) group by Region |   Region Performance | 
| Sales & Profit by State |  sum(sales) and sum(profits) group by Region |   Map Visulaization includes Region / State | 
| Year over Year Trend |  Order date, sales, profit Group by Extract Year|   Business Growth | 
| Sales Growth % |  (current-previous) / previous * 100 |   Year over Year Validation | 
| Top 5 / Bottom 5 States |  Group by profit asc / desc limit 5 |   best and worse state performance | 
