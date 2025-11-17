/*******************************************************************************
 * DEMO: Create Analytics Fact Tables
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA ANALYTICS;

-- Fact table: Marathon Performance Metrics
CREATE OR REPLACE TABLE FCT_MARATHON_PERFORMANCE AS
SELECT
    m.marathon_id,
    m.marathon_name,
    m.city,
    m.country,
    m.course_difficulty,
    r.race_year,
    COUNT(DISTINCT r.participant_id) AS total_participants,
    AVG(r.finish_time_minutes) AS avg_finish_time_minutes,
    MIN(r.finish_time_minutes) AS fastest_time_minutes,
    MAX(r.finish_time_minutes) AS slowest_time_minutes,
    SUM(CASE WHEN r.qualified_for_boston THEN 1 ELSE 0 END) AS boston_qualifiers,
    ROUND(SUM(CASE WHEN r.qualified_for_boston THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS qualification_rate_pct
FROM RAW_INGESTION.MARATHONS m
LEFT JOIN RAW_INGESTION.RACE_RESULTS r ON m.marathon_id = r.marathon_id
GROUP BY 1, 2, 3, 4, 5, 6;

-- Fact table: Sponsor ROI Analysis
CREATE OR REPLACE TABLE FCT_SPONSOR_ROI AS
SELECT
    s.sponsor_id,
    s.sponsor_name,
    s.sponsorship_tier,
    s.industry,
    m.marathon_id,
    m.marathon_name,
    sc.contract_year,
    sc.contract_value,
    sc.activation_spend,
    sc.contract_value + sc.activation_spend AS total_investment,
    sc.media_exposure_minutes,
    ROUND((sc.contract_value + sc.activation_spend) / NULLIF(sc.media_exposure_minutes, 0), 2) AS cost_per_minute
FROM RAW_INGESTION.SPONSORS s
JOIN RAW_INGESTION.SPONSOR_CONTRACTS sc ON s.sponsor_id = sc.sponsor_id
JOIN RAW_INGESTION.MARATHONS m ON sc.marathon_id = m.marathon_id;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

