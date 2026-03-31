# Email-analysis-SQL-
Email Marketing Analytics with BigQuery SQL: Advanced data modeling for tracking user account dynamics and email engagement funnel (Sent, Open, Visit) with Looker Studio visualization.

#  Email Marketing Engagement & User Dynamics Analysis

## Project Overview
This project focuses on analyzing user behavior and email campaign effectiveness. Using **Advanced SQL in BigQuery**, I developed a robust data model that synchronizes user account creation trends with email interaction metrics (Delivery, Open, and Click rates). The final output provides a segmented view of the user base by country, verification status, and subscription activity.

## Tech Stack
- **Database:** Google BigQuery (Standard SQL)
- **Visualization:** Looker Studio
- **Advanced SQL Techniques:** CTEs (Common Table Expressions), Window Functions, UNION ALL logic for multi-source data merging.

## Analytical Workflow & Requirements

### 1. SQL Data Modeling (BigQuery)
I designed a high-performance query to aggregate metrics across two different logic layers (Accounts and Emails) using a unified schema:
* **Account Metrics:** Tracking `account_cnt` (registrations) and `total_country_account_cnt`.
* **Email Engagement:** Calculating the full funnel — `sent_msg`, `open_msg`, and `visit_msg`.
* **Categorical Segmentation:** Data is sliced by `date`, `country`, `send_interval`, `is_verified`, and `is_unsubscribed`.

### 2. Advanced Ranking & Logic
* **Window Functions:** Implemented `RANK()` to identify the **Top 10 Countries** based on registration volume and email activity.
* **Unified Reporting:** Used `UNION ALL` to merge account creation dates with email dispatch dates into a single chronological timeline, ensuring data integrity for both dimensions.
* **CTEs:** Structured the query with logical blocks for better readability and maintainability.

### 3. Business Intelligence (Looker Studio)
The transformed data was visualized to provide instant marketing insights:
* **Country Ranking Dashboard:** Comparative analysis of `account_cnt` vs. `total_country_sent_cnt`.
* **Engagement Funnel:** Visualizing the drop-off between sent, opened, and clicked emails.
* **Registration Dynamics:** Time-series charts showing how user acquisition scales over time.

## Key SQL Features Used
- **RANK() OVER (PARTITION BY ...):** To filter only the most significant markets (Top 10).
- **Aggregated Window Functions:** To calculate total country-level metrics while maintaining granular detail in other columns.
- **CTEs for Modular Logic:** Separate blocks for account data and email data before the final union.

## Key Insights
- Identified the **Top 10 performing countries** by user engagement.
- Analyzed the correlation between **account verification status** (`is_verified`) and the probability of users unsubscribing.

## Vizualization in Looker
https://lookerstudio.google.com/reporting/582b8463-750e-4489-8d10-98a0ba092e1d

## 📁 Project Structure
* [View SQL Query](sql/email_marketing_query.sql) — The full BigQuery script with CTEs and Window Functions.
  
---
*Developed as a portfolio project for the SQL Advanced Module.*
