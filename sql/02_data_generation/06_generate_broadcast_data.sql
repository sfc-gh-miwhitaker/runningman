/*******************************************************************************
 * DEMO: Generate Broadcast Metrics
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA RAW_INGESTION;

CREATE OR REPLACE TABLE BROADCAST_METRICS (
    broadcast_id INTEGER PRIMARY KEY,
    marathon_id INTEGER,
    broadcast_year INTEGER,
    total_viewership BIGINT,
    avg_concurrent_viewers INTEGER,
    broadcast_duration_minutes INTEGER,
    broadcast_regions VARIANT
) COMMENT = 'DEMO: TV broadcast metrics';

INSERT INTO BROADCAST_METRICS
SELECT
    ROW_NUMBER() OVER (ORDER BY m.marathon_id, y.year) AS broadcast_id,
    m.marathon_id,
    y.year AS broadcast_year,
    UNIFORM(1000000, 10000000, RANDOM(m.marathon_id * y.year)) AS total_viewership,
    UNIFORM(500000, 3000000, RANDOM(m.marathon_id * y.year * 2)) AS avg_concurrent_viewers,
    UNIFORM(180, 300, RANDOM(m.marathon_id * y.year * 3)) AS broadcast_duration_minutes,
    PARSE_JSON(
        CASE m.country
            WHEN 'Japan' THEN '["Japan", "South Korea", "China", "Taiwan"]'
            WHEN 'USA' THEN '["USA", "Canada", "Mexico", "UK", "Australia"]'
            WHEN 'UK' THEN '["UK", "Ireland", "France", "Germany", "USA"]'
            WHEN 'Germany' THEN '["Germany", "Austria", "Switzerland", "Netherlands"]'
        END
    ) AS broadcast_regions
FROM MARATHONS m
CROSS JOIN (SELECT 2023 AS year UNION ALL SELECT 2024 UNION ALL SELECT 2025) y;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

