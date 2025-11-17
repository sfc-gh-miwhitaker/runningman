/*******************************************************************************
 * DEMO: Generate Social Media Posts for Sentiment Analysis
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA RAW_INGESTION;

CREATE OR REPLACE TABLE SOCIAL_MEDIA_POSTS (
    post_id INTEGER PRIMARY KEY,
    marathon_id INTEGER,
    post_date DATE,
    post_text VARCHAR(500),
    platform VARCHAR(20),
    engagement_count INTEGER
) COMMENT = 'DEMO: Fan social media posts for Cortex sentiment analysis';

INSERT INTO SOCIAL_MEDIA_POSTS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ8()) AS post_id,
    UNIFORM(1, 6, RANDOM(10000)) AS marathon_id,
    DATEADD(day, -UNIFORM(0, 1095, RANDOM(20000)), CURRENT_DATE()) AS post_date,
    CASE MOD(UNIFORM(1, 50, RANDOM(30000)), 10)
        WHEN 0 THEN 'Amazing experience at the marathon today! The crowd support was incredible and the weather was perfect.'
        WHEN 1 THEN 'Just finished my first major marathon! Feeling accomplished and exhausted at the same time.'
        WHEN 2 THEN 'The organization of this marathon was top-notch. Water stations were well-placed and volunteers were fantastic.'
        WHEN 3 THEN 'Disappointed with the long wait times at porta-potties. Otherwise great race!'
        WHEN 4 THEN 'Beautiful course through the city. Highly recommend this marathon to anyone training.'
        WHEN 5 THEN 'Beat my personal record by 15 minutes! Training paid off. Thank you to all the supporters!'
        WHEN 6 THEN 'Terrible experience. Too crowded at the start line and confusing course markings.'
        WHEN 7 THEN 'The energy from spectators kept me going through the toughest miles. Forever grateful!'
        WHEN 8 THEN 'First marathon as a charity runner. Raised $5000 for a great cause. Worth every mile!'
        ELSE 'Can''t wait for next year! Already planning my training schedule.'
    END AS post_text,
    CASE MOD(RANDOM(40000), 3) WHEN 0 THEN 'Twitter' WHEN 1 THEN 'Instagram' ELSE 'Facebook' END AS platform,
    UNIFORM(10, 5000, RANDOM(50000)) AS engagement_count
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

