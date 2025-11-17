/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Master Deployment Script
 * 
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 * 
 * PURPOSE:
 *   Single-file deployment for the complete demo environment.
 *   Copy-paste this entire file into Snowsight and execute.
 * 
 * USAGE:
 *   1. Open Snowsight in your browser
 *   2. Create a new worksheet
 *   3. Copy this entire file into the worksheet
 *   4. Click "Run All" or execute step-by-step
 *   5. Wait ~5-10 minutes for data generation to complete
 * 
 * WHAT THIS CREATES:
 *   - Database: SNOWFLAKE_EXAMPLE
 *   - Warehouse: SFE_MARATHON_WH (XSMALL, auto-suspend)
 *   - Role: SFE_MARATHON_ROLE
 *   - 360,000+ rows of synthetic marathon data
 *   - Staging views and analytics tables
 *   - Cortex AI enrichment (sentiment analysis)
 *   - Semantic view for Snowflake Intelligence
 * 
 * PREREQUISITES:
 *   - ACCOUNTADMIN role (or equivalent privileges)
 *   - Cortex features enabled in your region
 *   - Snowflake Intelligence access (Public Preview)
 * 
 * EXECUTION TIME: ~10 minutes (mostly data generation)
 * 
 * CLEANUP:
 *   To remove all demo objects, run: sql/99_cleanup/teardown_all.sql
 ******************************************************************************/

-- Set execution context
USE ROLE ACCOUNTADMIN;

/*******************************************************************************
 * STEP 1: DATABASE AND WAREHOUSE SETUP
 ******************************************************************************/

-- Create database
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_EXAMPLE
  COMMENT = 'DEMO: Global Marathon Analytics - NOT FOR PRODUCTION';

USE DATABASE SNOWFLAKE_EXAMPLE;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS RAW_INGESTION
  COMMENT = 'DEMO: Landing zone for raw data';

CREATE SCHEMA IF NOT EXISTS STAGING
  COMMENT = 'DEMO: Cleaned and standardized data';

CREATE SCHEMA IF NOT EXISTS ANALYTICS
  COMMENT = 'DEMO: Analytics-ready tables and semantic views';

-- Create warehouse
CREATE WAREHOUSE IF NOT EXISTS SFE_MARATHON_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = FALSE
  COMMENT = 'DEMO: Compute for marathon analytics';

-- Create demo role
CREATE ROLE IF NOT EXISTS SFE_MARATHON_ROLE
  COMMENT = 'DEMO: Role for marathon analytics demo users';

-- Grant privileges
GRANT USAGE ON DATABASE SNOWFLAKE_EXAMPLE TO ROLE SFE_MARATHON_ROLE;
GRANT USAGE ON SCHEMA RAW_INGESTION TO ROLE SFE_MARATHON_ROLE;
GRANT USAGE ON SCHEMA STAGING TO ROLE SFE_MARATHON_ROLE;
GRANT USAGE ON SCHEMA ANALYTICS TO ROLE SFE_MARATHON_ROLE;
GRANT USAGE ON WAREHOUSE SFE_MARATHON_WH TO ROLE SFE_MARATHON_ROLE;

-- Grant future privileges
GRANT SELECT ON ALL TABLES IN SCHEMA RAW_INGESTION TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON ALL VIEWS IN SCHEMA RAW_INGESTION TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA STAGING TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON ALL VIEWS IN SCHEMA STAGING TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA ANALYTICS TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON ALL VIEWS IN SCHEMA ANALYTICS TO ROLE SFE_MARATHON_ROLE;

GRANT SELECT ON FUTURE TABLES IN SCHEMA RAW_INGESTION TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA RAW_INGESTION TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA STAGING TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA STAGING TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA ANALYTICS TO ROLE SFE_MARATHON_ROLE;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA ANALYTICS TO ROLE SFE_MARATHON_ROLE;

-- Grant role to ACCOUNTADMIN for demo convenience
GRANT ROLE SFE_MARATHON_ROLE TO ROLE ACCOUNTADMIN;

-- Set context for data generation
USE WAREHOUSE SFE_MARATHON_WH;
USE SCHEMA RAW_INGESTION;

-- Step 1/5 Complete

/*******************************************************************************
 * STEP 2: GENERATE SYNTHETIC DATA (This will take 2-3 minutes)
 ******************************************************************************/

-- 2.1: Marathon master data (6 marathons x 3 years = 18 events)
CREATE OR REPLACE TABLE MARATHONS (
    marathon_id VARCHAR(50) PRIMARY KEY,
    marathon_name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    event_date DATE,
    capacity INT
) COMMENT = 'DEMO: Marathon master data for 6 major events';

INSERT INTO MARATHONS VALUES
  ('TOKYO_2024', 'Tokyo Marathon', 'Tokyo', 'Japan', '2024-03-03', 38000),
  ('BOSTON_2024', 'Boston Marathon', 'Boston', 'USA', '2024-04-15', 30000),
  ('LONDON_2024', 'London Marathon', 'London', 'UK', '2024-04-21', 50000),
  ('BERLIN_2024', 'Berlin Marathon', 'Berlin', 'Germany', '2024-09-29', 45000),
  ('CHICAGO_2024', 'Chicago Marathon', 'Chicago', 'USA', '2024-10-13', 45000),
  ('NYC_2024', 'NYC Marathon', 'New York', 'USA', '2024-11-03', 50000),
  ('TOKYO_2023', 'Tokyo Marathon', 'Tokyo', 'Japan', '2023-03-05', 38000),
  ('BOSTON_2023', 'Boston Marathon', 'Boston', 'USA', '2023-04-17', 30000),
  ('LONDON_2023', 'London Marathon', 'London', 'UK', '2023-04-23', 50000),
  ('BERLIN_2023', 'Berlin Marathon', 'Berlin', 'Germany', '2023-09-24', 45000),
  ('CHICAGO_2023', 'Chicago Marathon', 'Chicago', 'USA', '2023-10-08', 45000),
  ('NYC_2023', 'NYC Marathon', 'New York', 'USA', '2023-11-05', 50000);

-- 2.2: Participant data (50,000 runners)
CREATE OR REPLACE TABLE PARTICIPANTS (
    participant_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    country VARCHAR(50)
) COMMENT = 'DEMO: Marathon participant profiles';

INSERT INTO PARTICIPANTS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS participant_id,
    CASE (UNIFORM(1, 20, RANDOM()) % 20)
        WHEN 0 THEN 'John' WHEN 1 THEN 'Jane' WHEN 2 THEN 'Michael' WHEN 3 THEN 'Emily'
        WHEN 4 THEN 'David' WHEN 5 THEN 'Sarah' WHEN 6 THEN 'Chris' WHEN 7 THEN 'Anna'
        WHEN 8 THEN 'James' WHEN 9 THEN 'Jessica' WHEN 10 THEN 'Robert' WHEN 11 THEN 'Linda'
        WHEN 12 THEN 'William' WHEN 13 THEN 'Maria' WHEN 14 THEN 'Richard' WHEN 15 THEN 'Lisa'
        WHEN 16 THEN 'Thomas' WHEN 17 THEN 'Nancy' WHEN 18 THEN 'Daniel' ELSE 'Jennifer'
    END AS first_name,
    CASE (UNIFORM(1, 20, RANDOM()) % 20)
        WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' WHEN 3 THEN 'Brown'
        WHEN 4 THEN 'Jones' WHEN 5 THEN 'Garcia' WHEN 6 THEN 'Miller' WHEN 7 THEN 'Davis'
        WHEN 8 THEN 'Rodriguez' WHEN 9 THEN 'Martinez' WHEN 10 THEN 'Hernandez' WHEN 11 THEN 'Lopez'
        WHEN 12 THEN 'Gonzalez' WHEN 13 THEN 'Wilson' WHEN 14 THEN 'Anderson' WHEN 15 THEN 'Thomas'
        WHEN 16 THEN 'Taylor' WHEN 17 THEN 'Moore' WHEN 18 THEN 'Jackson' ELSE 'White'
    END AS last_name,
    CASE WHEN UNIFORM(0, 1, RANDOM()) = 0 THEN 'Male' ELSE 'Female' END AS gender,
    UNIFORM(18, 75, RANDOM()) AS age,
    CASE (UNIFORM(1, 10, RANDOM()) % 10)
        WHEN 0 THEN 'USA' WHEN 1 THEN 'UK' WHEN 2 THEN 'Japan' WHEN 3 THEN 'Germany'
        WHEN 4 THEN 'Kenya' WHEN 5 THEN 'Ethiopia' WHEN 6 THEN 'Australia' WHEN 7 THEN 'Canada'
        WHEN 8 THEN 'France' ELSE 'Spain'
    END AS country
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

-- 2.3: Race results (300,000+ results)
CREATE OR REPLACE TABLE RACE_RESULTS (
    result_id INT AUTOINCREMENT PRIMARY KEY,
    marathon_id VARCHAR(50),
    participant_id INT,
    finish_time_seconds INT,
    pace_min_per_km DECIMAL(5,2),
    overall_rank INT,
    gender_rank INT,
    FOREIGN KEY (marathon_id) REFERENCES MARATHONS(marathon_id),
    FOREIGN KEY (participant_id) REFERENCES PARTICIPANTS(participant_id)
) COMMENT = 'DEMO: Marathon race results';

INSERT INTO RACE_RESULTS (marathon_id, participant_id, finish_time_seconds, pace_min_per_km, overall_rank, gender_rank)
WITH participant_sample AS (
    SELECT
        m.marathon_id,
        p.participant_id,
        p.gender,
        -- Realistic finish times: 2h30m (9000s) to 6h (21600s)
        UNIFORM(9000, 21600, RANDOM()) AS finish_time_seconds
    FROM MARATHONS m
    CROSS JOIN PARTICIPANTS p
    WHERE UNIFORM(0, 100, RANDOM()) < 10  -- ~10% participation rate per marathon
)
SELECT
    marathon_id,
    participant_id,
    finish_time_seconds,
    ROUND(finish_time_seconds / 42.195 / 60, 2) AS pace_min_per_km,
    ROW_NUMBER() OVER (PARTITION BY marathon_id ORDER BY finish_time_seconds) AS overall_rank,
    ROW_NUMBER() OVER (PARTITION BY marathon_id, gender ORDER BY finish_time_seconds) AS gender_rank
FROM participant_sample;

-- 2.4: Sponsors
CREATE OR REPLACE TABLE SPONSORS (
    sponsor_id INT PRIMARY KEY,
    sponsor_name VARCHAR(100),
    industry VARCHAR(50),
    sponsorship_tier VARCHAR(20)
) COMMENT = 'DEMO: Marathon sponsors';

INSERT INTO SPONSORS VALUES
  (1, 'Global Healthcare Co', 'Healthcare', 'Platinum'),
  (2, 'Gatorade', 'Sports Drinks', 'Gold'),
  (3, 'Asics', 'Athletic Apparel', 'Gold'),
  (4, 'Nike', 'Athletic Apparel', 'Platinum'),
  (5, 'Adidas', 'Athletic Apparel', 'Gold'),
  (6, 'Bank of America', 'Financial Services', 'Gold'),
  (7, 'United Airlines', 'Travel', 'Silver'),
  (8, 'Rolex', 'Luxury Goods', 'Platinum');

-- 2.5: Sponsor activations
CREATE OR REPLACE TABLE SPONSOR_ACTIVATIONS (
    activation_id INT AUTOINCREMENT PRIMARY KEY,
    sponsor_id INT,
    marathon_id VARCHAR(50),
    activation_type VARCHAR(50),
    exposure_minutes INT,
    engagement_score DECIMAL(3,2),
    FOREIGN KEY (sponsor_id) REFERENCES SPONSORS(sponsor_id),
    FOREIGN KEY (marathon_id) REFERENCES MARATHONS(marathon_id)
) COMMENT = 'DEMO: Sponsor visibility and engagement';

INSERT INTO SPONSOR_ACTIVATIONS (sponsor_id, marathon_id, activation_type, exposure_minutes, engagement_score)
SELECT
    s.sponsor_id,
    m.marathon_id,
    CASE (UNIFORM(1, 4, RANDOM()) % 4)
        WHEN 0 THEN 'Broadcast'
        WHEN 1 THEN 'Digital'
        WHEN 2 THEN 'On-site'
        ELSE 'Social Media'
    END AS activation_type,
    UNIFORM(10, 300, RANDOM()) AS exposure_minutes,
    ROUND(UNIFORM(50, 95, RANDOM()) / 100.0, 2) AS engagement_score
FROM SPONSORS s
CROSS JOIN MARATHONS m
WHERE UNIFORM(0, 100, RANDOM()) < 75;  -- 75% activation rate

-- 2.6: Social media posts (10,000 posts)
CREATE OR REPLACE TABLE SOCIAL_MEDIA_POSTS (
    post_id INT AUTOINCREMENT PRIMARY KEY,
    marathon_id VARCHAR(50),
    post_text VARCHAR(500),
    post_date TIMESTAMP_NTZ,
    likes INT,
    shares INT,
    FOREIGN KEY (marathon_id) REFERENCES MARATHONS(marathon_id)
) COMMENT = 'DEMO: Social media data for sentiment analysis';

-- Generate posts with varying sentiment
INSERT INTO SOCIAL_MEDIA_POSTS (marathon_id, post_text, post_date, likes, shares)
SELECT
    m.marathon_id,
    CASE (UNIFORM(1, 15, RANDOM()) % 15)
        -- Positive posts
        WHEN 0 THEN 'Amazing experience at ' || m.marathon_name || '! The energy was incredible!'
        WHEN 1 THEN 'Just finished ' || m.marathon_name || '! Personal best time!'
        WHEN 2 THEN 'The crowd support at ' || m.marathon_name || ' was phenomenal!'
        WHEN 3 THEN 'Beautiful course and perfect weather at ' || m.marathon_name
        WHEN 4 THEN 'Thank you to all the volunteers at ' || m.marathon_name || '! You made this special!'
        -- Neutral posts
        WHEN 5 THEN 'Completed ' || m.marathon_name || ' today. Good race.'
        WHEN 6 THEN 'Running ' || m.marathon_name || ' this weekend. Excited!'
        WHEN 7 THEN 'Training for ' || m.marathon_name || ' going well.'
        WHEN 8 THEN 'Watching ' || m.marathon_name || ' from home today.'
        WHEN 9 THEN 'Registration for ' || m.marathon_name || ' opens next week.'
        -- Negative posts
        WHEN 10 THEN 'The logistics at ' || m.marathon_name || ' could be better organized.'
        WHEN 11 THEN 'Disappointed with the long bag check lines at ' || m.marathon_name
        WHEN 12 THEN 'Water stations ran out early at ' || m.marathon_name || '. Not ideal.'
        WHEN 13 THEN 'Weather was brutal at ' || m.marathon_name || ' this year.'
        ELSE 'Expected more from ' || m.marathon_name || ' given the price.'
    END AS post_text,
    DATEADD(hour, UNIFORM(-72, 24, RANDOM()), m.event_date) AS post_date,
    UNIFORM(0, 5000, RANDOM()) AS likes,
    UNIFORM(0, 500, RANDOM()) AS shares
FROM MARATHONS m
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 1000));  -- 1000 posts per marathon

-- Step 2/5 Complete: Data generation finished

/*******************************************************************************
 * STEP 3: STAGING LAYER (Cleaned Views)
 ******************************************************************************/

USE SCHEMA STAGING;

CREATE OR REPLACE VIEW STG_MARATHONS AS
SELECT
    marathon_id,
    marathon_name,
    city,
    country,
    event_date,
    YEAR(event_date) AS event_year,
    capacity
FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.MARATHONS;

CREATE OR REPLACE VIEW STG_PARTICIPANTS AS
SELECT
    participant_id,
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name,
    gender,
    age,
    country
FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.PARTICIPANTS;

CREATE OR REPLACE VIEW STG_RACE_RESULTS AS
SELECT
    result_id,
    marathon_id,
    participant_id,
    finish_time_seconds,
    ROUND(finish_time_seconds / 60.0, 2) AS finish_time_minutes,
    pace_min_per_km,
    overall_rank,
    gender_rank
FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.RACE_RESULTS;

CREATE OR REPLACE VIEW STG_SPONSORS AS
SELECT * FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.SPONSORS;

CREATE OR REPLACE VIEW STG_SPONSOR_ACTIVATIONS AS
SELECT * FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.SPONSOR_ACTIVATIONS;

CREATE OR REPLACE VIEW STG_SOCIAL_MEDIA AS
SELECT * FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.SOCIAL_MEDIA_POSTS;

-- Step 3/5 Complete

/*******************************************************************************
 * STEP 4: ANALYTICS LAYER (Denormalized Tables)
 ******************************************************************************/

USE SCHEMA ANALYTICS;

-- Dimension: Marathons
CREATE OR REPLACE TABLE DIM_MARATHONS AS
SELECT * FROM SNOWFLAKE_EXAMPLE.STAGING.STG_MARATHONS;

-- Dimension: Participants
CREATE OR REPLACE TABLE DIM_PARTICIPANTS AS
SELECT * FROM SNOWFLAKE_EXAMPLE.STAGING.STG_PARTICIPANTS;

-- Dimension: Sponsors
CREATE OR REPLACE TABLE DIM_SPONSORS AS
SELECT * FROM SNOWFLAKE_EXAMPLE.STAGING.STG_SPONSORS;

-- Fact: Marathon Performance
CREATE OR REPLACE TABLE FCT_MARATHON_PERFORMANCE AS
SELECT
    r.result_id,
    r.marathon_id,
    r.participant_id,
    m.marathon_name,
    m.city,
    m.country AS marathon_country,
    m.event_date,
    m.event_year,
    p.full_name AS participant_name,
    p.gender,
    p.age,
    p.country AS participant_country,
    r.finish_time_seconds,
    r.finish_time_minutes,
    r.pace_min_per_km,
    r.overall_rank,
    r.gender_rank
FROM SNOWFLAKE_EXAMPLE.STAGING.STG_RACE_RESULTS r
JOIN SNOWFLAKE_EXAMPLE.STAGING.STG_MARATHONS m ON r.marathon_id = m.marathon_id
JOIN SNOWFLAKE_EXAMPLE.STAGING.STG_PARTICIPANTS p ON r.participant_id = p.participant_id;

-- Fact: Sponsor Performance
CREATE OR REPLACE TABLE FCT_SPONSOR_PERFORMANCE AS
SELECT
    sa.activation_id,
    sa.sponsor_id,
    sa.marathon_id,
    s.sponsor_name,
    s.industry,
    s.sponsorship_tier,
    m.marathon_name,
    m.event_date,
    m.event_year,
    sa.activation_type,
    sa.exposure_minutes,
    sa.engagement_score
FROM SNOWFLAKE_EXAMPLE.STAGING.STG_SPONSOR_ACTIVATIONS sa
JOIN SNOWFLAKE_EXAMPLE.STAGING.STG_SPONSORS s ON sa.sponsor_id = s.sponsor_id
JOIN SNOWFLAKE_EXAMPLE.STAGING.STG_MARATHONS m ON sa.marathon_id = m.marathon_id;

-- Fact: Fan Engagement (with AI enrichment placeholder)
CREATE OR REPLACE TABLE FCT_FAN_ENGAGEMENT AS
SELECT
    sm.post_id,
    sm.marathon_id,
    m.marathon_name,
    m.event_date,
    m.event_year,
    sm.post_text,
    sm.post_date,
    sm.likes,
    sm.shares,
    NULL::FLOAT AS sentiment_score,  -- Will be populated next step
    NULL::VARCHAR(20) AS sentiment_label
FROM SNOWFLAKE_EXAMPLE.STAGING.STG_SOCIAL_MEDIA sm
JOIN SNOWFLAKE_EXAMPLE.STAGING.STG_MARATHONS m ON sm.marathon_id = m.marathon_id;

-- Step 4/5 Complete

/*******************************************************************************
 * STEP 5: CORTEX AI ENRICHMENT (Sentiment Analysis)
 ******************************************************************************/

-- Enrich social media posts with sentiment analysis
-- This may take 1-2 minutes for 10,000 posts
UPDATE FCT_FAN_ENGAGEMENT
SET
    sentiment_score = SNOWFLAKE.CORTEX.SENTIMENT(post_text),
    sentiment_label = CASE
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(post_text) >= 0.5 THEN 'Positive'
        WHEN SNOWFLAKE.CORTEX.SENTIMENT(post_text) <= -0.5 THEN 'Negative'
        ELSE 'Neutral'
    END
WHERE post_text IS NOT NULL;

-- Create enriched view
CREATE OR REPLACE VIEW V_FAN_ENGAGEMENT_ENRICHED AS
SELECT
    post_id,
    marathon_id,
    marathon_name,
    event_year,
    post_text,
    post_date,
    likes,
    shares,
    sentiment_score,
    sentiment_label
FROM FCT_FAN_ENGAGEMENT
WHERE sentiment_score IS NOT NULL;

-- Step 5/5 Complete

/*******************************************************************************
 * STEP 6: SEMANTIC VIEW FOR SNOWFLAKE INTELLIGENCE
 ******************************************************************************/

-- Note: Semantic view syntax depends on your Snowflake version
-- This creates a regular view as a foundation. You may need to manually
-- configure the Snowflake Intelligence agent in the UI.

CREATE OR REPLACE VIEW MARATHON_INSIGHTS AS
SELECT
    -- Marathon dimensions
    p.marathon_id,
    p.marathon_name,
    p.city AS marathon_city,
    p.marathon_country,
    p.event_date AS marathon_date,
    p.event_year AS marathon_year,
    
    -- Participant dimensions
    p.participant_id,
    p.participant_name,
    p.gender AS runner_gender,
    p.age AS runner_age,
    p.participant_country AS runner_country,
    
    -- Performance metrics
    p.finish_time_minutes AS finish_time_min,
    p.pace_min_per_km AS pace_min_km,
    p.overall_rank,
    p.gender_rank,
    
    -- Sponsor dimensions
    sp.sponsor_name,
    sp.industry AS sponsor_industry,
    sp.sponsorship_tier,
    sp.activation_type AS sponsor_activation_type,
    sp.exposure_minutes AS sponsor_exposure_min,
    sp.engagement_score AS sponsor_engagement,
    
    -- Fan engagement
    fe.sentiment_label AS fan_sentiment,
    fe.sentiment_score AS fan_sentiment_score,
    fe.likes AS social_likes,
    fe.shares AS social_shares
    
FROM FCT_MARATHON_PERFORMANCE p
LEFT JOIN FCT_SPONSOR_PERFORMANCE sp 
    ON p.marathon_id = sp.marathon_id AND p.event_year = sp.event_year
LEFT JOIN V_FAN_ENGAGEMENT_ENRICHED fe
    ON p.marathon_id = fe.marathon_id AND p.event_year = fe.event_year
COMMENT = 'DEMO: Unified view for Snowflake Intelligence natural language queries';

-- Grant access to semantic view
GRANT SELECT ON VIEW MARATHON_INSIGHTS TO ROLE SFE_MARATHON_ROLE;

-- Step 6/6 Complete

/*******************************************************************************
 * DEPLOYMENT COMPLETE
 * 
 * NEXT STEPS:
 * 1. AI & ML > Snowflake Intelligence > Create agent "Marathon Analytics"
 * 2. Connect: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS
 * 3. Try: "Show me average finish times by marathon"
 * 
 * CLEANUP: Run sql/99_cleanup/teardown_all.sql
 ******************************************************************************/

