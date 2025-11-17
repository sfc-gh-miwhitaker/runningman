/*******************************************************************************
 * DEMO: Enrich Social Media with Cortex AI SENTIMENT()
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA ANALYTICS;

-- Ensure Cortex access
-- GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ACCOUNTADMIN;

-- Create enriched social media table with sentiment scores
CREATE OR REPLACE TABLE ENRICHED_SOCIAL_MEDIA AS
SELECT
    smp.post_id,
    smp.marathon_id,
    m.marathon_name,
    smp.post_date,
    smp.post_text AS post_text_original,
    smp.platform,
    smp.engagement_count,
    SNOWFLAKE.CORTEX.SENTIMENT(smp.post_text) AS sentiment_score,
    CASE 
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(smp.post_text) > 0.5 THEN 'Positive'
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(smp.post_text) < -0.5 THEN 'Negative'
        ELSE 'Neutral'
    END AS sentiment_category
FROM RAW_INGESTION.SOCIAL_MEDIA_POSTS smp
JOIN RAW_INGESTION.MARATHONS m ON smp.marathon_id = m.marathon_id;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

