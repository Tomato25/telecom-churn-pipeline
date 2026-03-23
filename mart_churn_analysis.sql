WITH features AS (
    SELECT * FROM {{ ref('int_customer_features') }}
),

aggregated AS (
    SELECT
        -- dimensions (the segments we're analysing)
        contract_type,
        tenure_band,
        internet_service_type,
        gender,

        -- volume
        COUNT(*)                                                    AS total_customers,
        SUM(CASE WHEN has_churned = TRUE THEN 1 ELSE 0 END)         AS churned_customers,

        -- churn rate
        ROUND(
            SUM(CASE WHEN has_churned = TRUE THEN 1 ELSE 0 END) * 100.0 
            / COUNT(*), 
        2)                                                          AS churn_rate_pct,

        -- revenue metrics
        ROUND(SUM(monthly_revenue_at_risk), 2)                      AS total_revenue_at_risk,
        ROUND(AVG(monthly_charges), 2)                              AS avg_monthly_charge,

        -- risk
        ROUND(AVG(churn_risk_score), 2)                             AS avg_risk_score,
        ROUND(AVG(number_of_services), 2)                           AS avg_services_per_customer

    FROM features
    GROUP BY 1, 2, 3, 4
)

SELECT * FROM aggregated
ORDER BY churn_rate_pct DESC