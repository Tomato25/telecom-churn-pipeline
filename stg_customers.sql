WITH source AS (
    SELECT * FROM {{ source('raw', 'telco_customers') }}
),

cleaned AS (
    SELECT
        -- identifiers
        customerid                                              AS customer_id,

        -- demographics
        LOWER(gender)                                          AS gender,
        CASE WHEN seniorcitizen = '1' THEN TRUE ELSE FALSE END AS is_senior_citizen,
        CASE WHEN partner = 'Yes' THEN TRUE ELSE FALSE END     AS has_partner,
        CASE WHEN dependents = 'Yes' THEN TRUE ELSE FALSE END  AS has_dependents,

        -- services
        CASE WHEN phoneservice = 'Yes' THEN TRUE ELSE FALSE END AS has_phone,
        multiplelines                                           AS multiple_lines,
        internetservice                                         AS internet_service_type,
        onlinesecurity                                          AS has_online_security,
        onlinebackup                                            AS has_online_backup,
        deviceprotection                                        AS has_device_protection,
        techsupport                                             AS has_tech_support,
        streamingtv                                             AS has_streaming_tv,
        streamingmovies                                         AS has_streaming_movies,

        -- account
        contract                                               AS contract_type,
        CASE WHEN paperlessbilling = 'Yes' 
             THEN TRUE ELSE FALSE END                          AS has_paperless_billing,
        paymentmethod                                          AS payment_method,
        tenure::INT                                            AS tenure_months,
        monthlycharges::FLOAT                                  AS monthly_charges,
        TRY_TO_DOUBLE(totalcharges)                            AS total_charges,

        -- target
        CASE WHEN churn = 'Yes' THEN TRUE ELSE FALSE END       AS has_churned

    FROM source
)

SELECT * FROM cleaned