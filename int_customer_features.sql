WITH stg AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

features AS (
    SELECT
        -- carry forward all staging columns
        customer_id,
        gender,
        is_senior_citizen,
        has_partner,
        has_dependents,
        contract_type,
        internet_service_type,
        payment_method,
        tenure_months,
        monthly_charges,
        total_charges,
        has_churned,

        -- tenure banding for easier analysis
        CASE
            WHEN tenure_months <= 12 THEN '0-12 months'
            WHEN tenure_months <= 24 THEN '13-24 months'
            WHEN tenure_months <= 48 THEN '25-48 months'
            ELSE '49+ months'
        END AS tenure_band,

        -- number of services (your idea)
        (
            CASE WHEN has_phone = TRUE THEN 1 ELSE 0 END +
            CASE WHEN has_online_security = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN has_online_backup = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN has_device_protection = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN has_tech_support = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN has_streaming_tv = 'Yes' THEN 1 ELSE 0 END +
            CASE WHEN has_streaming_movies = 'Yes' THEN 1 ELSE 0 END
        ) AS number_of_services,

        -- churn risk score (higher = more at risk)
        CASE contract_type
            WHEN 'Month-to-month' THEN 3
            WHEN 'One year'       THEN 1
            WHEN 'Two year'       THEN 0
        END +
        CASE
            WHEN tenure_months <= 12 THEN 2
            WHEN tenure_months <= 24 THEN 1
            ELSE 0
        END AS churn_risk_score,

        -- revenue at risk
        CASE
            WHEN has_churned = TRUE THEN monthly_charges
            ELSE 0
        END AS monthly_revenue_at_risk

    FROM stg
)

SELECT * FROM features