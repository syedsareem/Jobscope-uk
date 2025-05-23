# Tableau Visualisations – JobScope UK

This folder contains the Tableau visualisations and dashboard assets used to explore and present insights from UK job market data.

---

## Dashboard Overview

The **JobScope UK** dashboard is built using Tableau Public and powered by Snowflake data.

It includes 7 core visualisations:

1. **Job Count by City** – Bubble map showing regional job density
2. **Job Category Demand** – Treemap of job listings by category
3. **Average Salary by Category** – Bar chart showing average salaries
4. **Job Count by Region** – Stacked bar by region + job type
5. **Salary by Region** – Bar chart of average salaries by UK region
6. **Top Hiring Cities** – Horizontal bar chart of top cities by listings
7. **Regional Opportunity Matrix** – Scatterplot of job count vs average salary by category

---

## Metrics Tracked

- **Job Count** by category, city, region
- **Average Salary** by category and region
- **Posting Trends** (min/max date, deduplicated listings)

---

## Design Philosophy

- **Interactive Filtering**: Region-level filters allow scoped exploration
- **Analyst Ready**: Designed for use by workforce planners, recruiters, and decision-makers
- **Real Tools**: Backed by Snowflake, AWS, and real Adzuna job data

---

## Bonus

All dashboard logic stems from the `DASH_KPIS` view in Snowflake. This ensures consistent KPIs across all charts and filters.

---

## Suggestions?

This project was built as part of my learning journey. Feedback is welcome.

