/*******************************************************************************
 * DEMO: Create Staging Views (No Physical Storage)
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA STAGING;

-- Staging view for marathon details
CREATE OR REPLACE VIEW STG_MARATHON_DETAILS AS
SELECT
    marathon_id,
    UPPER(marathon_name) AS marathon_name,
    city,
    country,
    typical_month,
    elevation_gain_meters,
    course_difficulty
FROM RAW_INGESTION.MARATHONS;

-- Staging view for participant demographics
CREATE OR REPLACE VIEW STG_PARTICIPANT_DEMOGRAPHICS AS
SELECT
    participant_id,
    TRIM(first_name || ' ' || last_name) AS full_name,
    age,
    CASE 
        WHEN age < 25 THEN '18-24'
        WHEN age < 30 THEN '25-29'
        WHEN age < 35 THEN '30-34'
        WHEN age < 40 THEN '35-39'
        WHEN age < 45 THEN '40-44'
        WHEN age < 50 THEN '45-49'
        WHEN age < 55 THEN '50-54'
        WHEN age < 60 THEN '55-59'
        ELSE '60+'
    END AS age_group,
    gender,
    country,
    experience_level
FROM RAW_INGESTION.PARTICIPANTS;

-- Staging view for race performance
CREATE OR REPLACE VIEW STG_RACE_PERFORMANCE AS
SELECT
    r.result_id,
    r.participant_id,
    r.marathon_id,
    m.marathon_name,
    r.race_year,
    r.finish_time_minutes,
    ROUND(r.finish_time_minutes / 60.0, 2) AS finish_time_hours,
    r.placement_overall,
    r.age_group,
    r.qualified_for_boston
FROM RAW_INGESTION.RACE_RESULTS r
JOIN RAW_INGESTION.MARATHONS m ON r.marathon_id = m.marathon_id;

-- Staging view for social media (text normalization)
CREATE OR REPLACE VIEW STG_SOCIAL_MEDIA AS
SELECT
    post_id,
    marathon_id,
    post_date,
    TRIM(REPLACE(REPLACE(post_text, '  ', ' '), CHR(10), ' ')) AS post_text_clean,
    platform,
    engagement_count
FROM RAW_INGESTION.SOCIAL_MEDIA_POSTS;

-- Staging view for broadcast metrics
CREATE OR REPLACE VIEW STG_BROADCAST_METRICS AS
SELECT
    b.broadcast_id,
    b.marathon_id,
    m.marathon_name,
    b.broadcast_year,
    b.total_viewership,
    b.avg_concurrent_viewers,
    b.broadcast_duration_minutes,
    ARRAY_SIZE(b.broadcast_regions) AS broadcast_region_count,
    b.broadcast_regions
FROM RAW_INGESTION.BROADCAST_METRICS b
JOIN RAW_INGESTION.MARATHONS m
  ON b.marathon_id = m.marathon_id;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

