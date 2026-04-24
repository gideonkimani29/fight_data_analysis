# ✈️ US Domestic Flights — Delay & Performance Analysis

**Author:** Daniel Gideon Kimani  
**Date:** April 2026  
**Dataset:** US DOT Bureau of Transportation Statistics · January 2008

---

## Project Overview

End-to-end SQL + Python analysis of **605,765 US domestic flights**, covering delay patterns, carrier performance, route intelligence, and cancellation trends.

## Business Questions Answered

1. Which days of the week have the most delays?
2. Which carriers perform best on punctuality?
3. What are the primary causes of delays?
4. Which routes are busiest and most delay-prone?
5. What is the overall cancellation landscape?
6. Does flight distance affect delay likelihood?

## Repository Structure

```
flights_project/
├── README.md
├── notebooks/
│   └── flights_analysis.ipynb  ← Main analysis notebook
│   
├── sql/
│   └── analysis_queries.sql     ← Reusable SQL queries (8 analyses)
└── visuals/
    ├── 1_volume_by_day.png
    ├── 2_carrier_performance.png
    ├── 3_delay_types.png
    ├── 4_top_routes.png
    ├── 5_cancellations.png
    ├── 6_delay_distribution.png
    ├── 7_distance_delay.png
    └── 8_busiest_airports.png
```

## Data Model

| Table     | Rows    | Description                              |
|-----------|---------|------------------------------------------|
| flights   | 605,765 | Core fact table: delays, routes, times   |
| airports  | 3,376   | IATA codes, city, state, lat/long        |
| carriers  | 1,491   | Airline codes and descriptions           |
| planes    | 5,029   | Tail number registry                     |

## Key Findings

| Finding | Detail |
|---------|--------|
| Worst delay day | **Thursday** — highest avg arrival delay |
| Best carrier | Top performers show 15%+ advantage in on-time rate |
| #1 delay cause | **Late Aircraft** (cascading effect across routes) |
| Busiest hub | **Atlanta (ATL)** — 33,906 departures in Jan |
| Cancellation rate | ~2.9% overall; weather spikes in January |
| Distance insight | Short-haul (<500 mi) flights are more reliable |

## Tools & Skills Demonstrated

- **SQLite** — multi-table JOINs, aggregations, CASE expressions, window analysis
- **Python (Pandas)** — data wrangling, null handling, type conversion
- **Matplotlib** — dual-axis charts, scatter plots, stacked bar charts, histograms
- **Jupyter Notebook** — reproducible, documented analysis pipeline

## How to Run

```bash
# 1. Ensure flights.db is accessible
# 2. Update the DB path in the notebook (cell 1) if needed
# 3. Run all cells in flights_analysis.ipynb
```

---
*Portfolio project — Data Analytics · ALX Africa*
