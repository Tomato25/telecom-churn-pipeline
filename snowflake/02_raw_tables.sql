USE DATABASE telecom_dw;
USE SCHEMA raw;
USE WAREHOUSE telecom_wh;

CREATE OR REPLACE TABLE telecom_dw.raw.telco_customers (
    customerID        VARCHAR,
    gender            VARCHAR,
    SeniorCitizen     VARCHAR,
    Partner           VARCHAR,
    Dependents        VARCHAR,
    tenure            VARCHAR,
    PhoneService      VARCHAR,
    MultipleLines     VARCHAR,
    InternetService   VARCHAR,
    OnlineSecurity    VARCHAR,
    OnlineBackup      VARCHAR,
    DeviceProtection  VARCHAR,
    TechSupport       VARCHAR,
    StreamingTV       VARCHAR,
    StreamingMovies   VARCHAR,
    Contract          VARCHAR,
    PaperlessBilling  VARCHAR,
    PaymentMethod     VARCHAR,
    MonthlyCharges    VARCHAR,
    TotalCharges      VARCHAR,
    Churn             VARCHAR
);