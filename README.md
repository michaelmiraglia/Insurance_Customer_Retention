# Home Insurance Customer Retention and Risk Analysis!

## Overview
This project uses SQLite to model customer, policy, property, claim, payment, coverage, and underwriting data for a made-up home insurance company

## Goal
To use relational data and SQL to identify retention opportunities, coverage concerns, and payment / underwriting risk

## Tools Used
- SQLite
- Letos
- SQL
- GitHub

## Key Skills Demonstrated
SQL joins, aggregations, GROUP BY, HAVING, CASE, CTEs, relational modeling, PK/FK, data validation, data cleaning, business requirements, and risk/retention analysis

## Business Questions
1. Which active customers are both high-value and claim-active?
2. Which customers show the greatest policy activity and engagement?
3. Which policies may need coverage review based on incident activity?
4. Which policies show payment or underwriting risks?

## Data Pipeline
Synthetic dource data > SQLite relational tables > quality checks > SQL analysis > business recommendations > downstream reporting

## Data Quality Checks
Before SQL analysis, the project is checked for:
- Duplicate customer emails
- Missing required customer fields
- Orphan policy relatioships
- Invalid payments or statuses
- Closed claims w/o settlements

## For Visualization:
The SQL outputs can be exported to Tableau or Power BI for a customer retention and risk dashboard!
