# DataAnalytics-Assessment

## Project Overview

This repository contains my solutions to a SQL proficiency assessment involving customer banking data across savings and investment plans. The queries were written to answer four business-focused questions, demonstrating data aggregation, filtering, and customer segmentation using SQL.

## File Structure
```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql       # High-Value Customers with Multiple Products
├── Assessment_Q2.sql       # Transaction Frequency Analysis
├── Assessment_Q3.sql       # Account Inactivity Alert
├── Assessment_Q4.sql       # Customer Lifetime Value (CLV) Estimation
└── README.md               # Project overview and explanation of methodology.

```


## Assessment Questions & Approaches

### 1. High-Value Customers with Multiple Products

**Task:** Find customers who have at least one funded savings plan and one funded investment plan, and sort them by total deposits.

**Approach:**
- Joined tables `users_customuser`, `plans_plan`, and `savings_savingsaccount` together.
- Filtered for `confirmed_amount > 0` to focus on funded plans.
- Used conditional aggregation (COUNT(DISTINCT CASE WHEN ... THEN plan_id END)) to count unique savings and investment plans per user.
- Grouped by customer and used `HAVING` to ensure only saving and investment plans were present.
- Summed and converted confirmed_amount (in kobo) to currency units (Naira), then ordered by total deposits in a descending order.

---

### 2. Customer Segmentation by Transaction Frequency

**Task:** Categorise users into 'High', 'Medium', or 'Low' frequency groups based on average monthly transactions.

**Approach:**
- Created a CTE (`user_trans`) to calculate total transactions and months active using `TIMESTAMPDIFF` and `MIN/MAX` of transaction dates.
- Another CTE (`users_cat`) computed average monthly transactions and assigned frequency categories using a `CASE` statement.
- Grouped and counted users per category, with ordering to show higher engagement segments first.

---

### 3. Account Inactivity Alert

**Task:** Identify active savings or investment accounts with no **inflow** transactions for over a year.

**Approach:**
- Built a CTE (`last_transactions`) to fetch the most recent inflow (`confirmed_amount > 0`) for each plan.
- Joined with `plans_plan` to determine plan type (Savings or Investment).
- Filtered for plans with no inflow in the last 365 days using `DATEDIFF`.
- Ensured only **active** plans were included by checking `is_archived = 0` and `is_deleted = 0`.

---

### 4. Customer Lifetime Value (CLV) Estimation

**Task:** Estimate CLV using the formula:

CLV = (Total Transactions / Tenure in Months) \* 12 \* Average Profit per Transaction

Assumption: Profit per transaction is 0.1% of the transaction value.

**Approach:**
- Calculated tenure from `date_joined` using `TIMESTAMPDIFF`.
- Counted total transactions per customer from `savings_savingsaccount`.
- Used `NULLIF` to avoid division by zero when calculating CLV.
- Calculated average profit as `AVG(confirmed_amount) * 0.001`.
- Results are ordered by estimated CLV in descending order.

---

## Challenges Faced

- **MySQL Setup**: Experienced PATH and root-password issues. Resolved by adding MySQL bin to PATH and resetting the root password via safe mode.
- **File Import Lock**: MySQL Workbench refused to import the dump due to file locks. Switched to command-line import using the full executable path.
- **Clarifying 'Inflow' Definition**: The question stated “inflow” without specifying transaction types.
Resolved by exploring the data, confirmed_amount > 0 was used to infer actual money-in transactions.
- **Avoiding division by zero**: In CLV calculation, tenure could be zero for new users. Resolved by using NULLIF(..., 0) in the denominator to avoid errors.
