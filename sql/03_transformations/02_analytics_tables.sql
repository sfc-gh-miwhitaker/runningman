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

-- Fact table: Broadcast Reach Metrics
CREATE OR REPLACE TABLE FCT_BROADCAST_REACH AS
SELECT
    sb.marathon_id,
    sb.marathon_name,
    sb.broadcast_year,
    sb.total_viewership,
    sb.avg_concurrent_viewers,
    sb.broadcast_duration_minutes,
    sb.broadcast_region_count,
    sb.broadcast_regions
FROM STAGING.STG_BROADCAST_METRICS sb;

-- Fact table: Aggregated Fan Engagement & Sentiment
CREATE OR REPLACE TABLE FCT_FAN_ENGAGEMENT AS
SELECT
    esm.marathon_id,
    esm.marathon_name,
    YEAR(esm.post_date) AS sentiment_year,
    COUNT(*) AS total_posts,
    SUM(esm.engagement_count) AS total_engagement,
    AVG(esm.sentiment_score) AS avg_sentiment_score,
    SUM(CASE WHEN esm.sentiment_category = 'Positive' THEN 1 ELSE 0 END) AS positive_posts,
    SUM(CASE WHEN esm.sentiment_category = 'Neutral' THEN 1 ELSE 0 END) AS neutral_posts,
    SUM(CASE WHEN esm.sentiment_category = 'Negative' THEN 1 ELSE 0 END) AS negative_posts,
    ROUND(SUM(CASE WHEN esm.sentiment_category = 'Positive' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS positive_post_pct,
    ROUND(SUM(CASE WHEN esm.sentiment_category = 'Negative' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS negative_post_pct,
    ROUND(AVG(esm.engagement_count), 2) AS avg_engagement_per_post,
    MAX_BY(esm.platform, esm.engagement_count) AS top_platform_by_engagement
FROM ANALYTICS.ENRICHED_SOCIAL_MEDIA esm
GROUP BY 1, 2, 3;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

