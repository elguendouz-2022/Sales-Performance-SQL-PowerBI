# Retail Sales Performance Dashboard (SQL & Power BI)

##  Project Overview
This project delivers an end-to-end business intelligence solution designed to analyze and track key performance indicators (KPIs) for sales, order volumes, and inventory quantities. Utilizing **SQL** for backend data extraction/aggregation and **Power BI** for interactive frontend visualization, this dashboard transforms raw transactional data into actionable operational insights.

---

## Business Requirements & KPIs

### 1. Core KPI Metrics (Month-on-Month Analysis)
*   **Total Sales:** Calculated total revenue per month, tracking absolute difference and MoM percentage changes to pinpoint growth or decline.
*   **Total Orders:** Monitored total unique transaction counts per month alongside MoM trends to evaluate consumer purchasing frequency.
*   **Total Quantity Sold:** Tracked total product items distributed monthly, isolating MoM volume shifts.

### 2. Advanced Analytical Visualizations
*   **Calendar Heat Map:** A dynamic calendar view color-coded by daily sales volume (darker shades indicating peak revenue days) with multi-metric tooltips (Sales, Orders, Quantity).
*   **Weekday vs. Weekend Analysis:** Grouped segmentation to isolate behavioral differences between business days and weekends.
*   **Restaurant Location Performance:** Spatial/regional performance matrix equipped with dynamic MoM indicators to identify localized growth trends.
*   **Daily Sales & Operational Benchmarks:** A daily sales line/bar chart utilizing an operational moving average line to immediately flag exceptional outlier days.
*   **Product Category Share:** Breakdown of performance distributions across categories to discover top revenue drivers.
*   **Top 5 Products:** Granular ranking showcasing the highest-grossing inventory items.
*   **Sales Activity Matrix (Days & Hours Heat Map):** A dense hour-of-day vs. day-of-week matrix to reveal hourly peak traffic windows for optimized scheduling.

---

##  Tech Stack & Tools
*   **Database Engine:** SQL Server  (Extract, Transform, Aggregate metrics)
*   **Visualization Platform:** Power BI Desktop (DAX, Power Query, Data Modeling)
*   **Documentation & Version Control:**  GitHub

---

### Sample DAX Implementations:
```dax
// Total Sales Metric
Total Sales = SUM(Fact_Sales[Revenue])

// Month-on-Month Sales Variance
MoM Sales Variance = [Total Sales] - CALCULATE([Total Sales], DATEADD('Dim_Calendar'[Date], -1, MONTH))


---

## 📂 How to Explore the Project
1. **Database Setup:** Run the scripts inside `/SQL_Queries` on your SQL database engine to structure tables and verify KPI aggregations.
2. **Interactive Report:** Download the `.pbix` file from the `/Power_BI` folder 
