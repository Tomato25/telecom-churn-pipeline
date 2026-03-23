WITH features AS (
    SELECT * FROM {{ ref('int_customer_features') }}
)
SELECT
    contract_type,
    COUNT(*)                                                     AS total_customers,
    SUM(CASE WHEN has_churned = TRUE THEN 1 ELSE 0 END)          AS churned_customers,
    ROUND(
        SUM(CASE WHEN has_churned = TRUE THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
    1)                                                           AS churn_rate_pct,
    ROUND(SUM(monthly_revenue_at_risk), 2)                       AS total_revenue_at_risk
FROM features
GROUP BY 1
ORDER BY churn_rate_pct DESC