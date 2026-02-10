SELECT * FROM customer LIMIT 20;

-- 1. What is our overall churn rate?
SELECT ROUND(AVG(churn) * 100, 2) AS "churn rate percentage"
FROM customer;

-- 2. How many active customers do we currently have?
SELECT COUNT(churn) AS active_customer
FROM customer
WHERE churn = 0;

-- 3. What is our Monthly Recurring Revenue (MRR)?
SELECT ROUND(SUM(monthlycharges::NUMERIC),2) AS "Monthly Recurring Revenue"
FROM customer
WHERE churn = 0;

-- 4. How much monthly revenue is at risk due to churned customers?
SELECT ROUND(SUM(monthlycharges::NUMERIC),2) AS revenue_at_risk
FROM customer
WHERE churn = 1;

-- 5. Which tenure groups have the highest churn?
SELECT tenure_buckets, COUNT(*) AS customers, SUM(churn) AS total_churned, ROUND(AVG(churn) * 100,2) AS churn_rate_perc
FROM customer
GROUP BY tenure_buckets
ORDER BY churn_rate_perc DESC;

-- 6. Which contract types are driving churn?
SELECT contract, COUNT(*) AS customers, ROUND(AVG(churn) * 100, 2) AS churn_rate_by_contract
FROM customer
GROUP BY contract
ORDER BY churn_rate_by_contract DESC;

-- 7. Which payment methods have the highest churn?
SELECT paymentmethod, COUNT(*) AS customers, ROUND(AVG(churn) * 100, 2) AS churn_by_paymethod
FROM customer
GROUP BY paymentmethod
ORDER BY churn_by_paymethod DESC;

-- 8. Are early churners producing lower lifetime revenue?
SELECT early_churn, COUNT(*) AS total_customer, ROUND(AVG(lifetime_revenue::NUMERIC),2) AS avg_lifetime_revenue
FROM customer
GROUP BY early_churn
ORDER BY avg_lifetime_revenue DESC;

-- 9. Which segments generate the highest lifetime value?
SELECT contract, ROUND(AVG(lifetime_revenue::NUMERIC),2) AS avg_lifetime_value
FROM customer
GROUP BY contract
ORDER BY avg_lifetime_value DESC;

-- 10. Top 10 high-risk segments by churn and revenue loss
SELECT tenure_buckets, contract, paymentmethod, COUNT(*) AS customers,
ROUND(AVG(churn::int) * 100, 2) AS churn_rate_percentage,
ROUND(SUM(monthlycharges::NUMERIC), 2) AS revenue_at_risk
FROM customer
WHERE churn = 1
GROUP BY tenure_buckets, contract, paymentmethod
ORDER BY revenue_at_risk DESC
LIMIT 10;
