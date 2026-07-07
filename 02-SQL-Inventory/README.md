# Project 2 — Inventory Optimization Dashboard

## Business Context
Acting as a Business Analyst for a DVD rental company operating 
2 stores across the United States. The goal was to analyse 4,581 
inventory items across 1,000 films to identify fast vs slow movers, 
revenue drivers, dead stock, and reorder priorities.

## Tools Used
- MySQL (Sakila database) — data extraction and analysis
- Excel 2016 — data organisation and summary workbook
- Power BI Desktop — interactive dashboard

## Dataset
Sakila sample database — a MySQL training database representing 
a DVD rental business with 16,421 rental transactions across 
2 store locations.

## Business Questions Answered
1. Which films are fast movers vs slow movers?
2. Which category generates the most revenue?
3. Which inventory items have never been rented (dead stock)?
4. Which films need reordering based on demand vs stock ratio?
5. Which store performs better overall?

## Key Findings
- Sports category leads total revenue ($5,314) but Comedy and 
  Sci-Fi show superior revenue per film efficiency ($78 and $80)
- Only 1 film has never been rented — 99.9% inventory activation rate
- 17 films flagged for reorder consideration with 5+ rentals per copy
- Both stores perform near-identically — 599 customers each, 
  ~$33,700 revenue each
- 548 films (57%) are slow movers — opportunity to optimise catalog
- Mystic Truman (Comedy) generates 5 rentals per copy at only 
  $0.99 rental rate — severely underpriced

## Recommendations
1. Increase rental rate for high-demand low-priced films
2. Expand Comedy and Sci-Fi inventory — highest revenue efficiency
3. Reduce Music and Travel inventory on next reorder cycle
4. Replicate Store 1 film mix in Store 2 to improve per-rental revenue
5. Review and retire the 1 dead stock item (Academy Dinosaur, Store 2)

## SQL Queries Written
- Q1: Film performance classification (Fast/Medium/Slow Mover)
- Q2: Revenue analysis by category with efficiency metrics
- Q3: Dead stock identification using LEFT JOIN + NULL filter
- Q4: Reorder suggestions using rentals-per-copy ratio
- Q5: Store comparison across revenue, rentals, and customers

## Skills Demonstrated
MySQL · Multi-table JOINs · CTEs · Window Functions · CASE WHEN · 
GROUP BY · HAVING · Aggregate Functions · Power BI DAX · 
Star Schema · Data Storytelling · Business Recommendations

## Dashboard Preview
<img width="1313" height="742" alt="Inventory_Dashboard" src="https://github.com/user-attachments/assets/4259c3b8-033f-438c-8a49-62d64b82a8a1" />
