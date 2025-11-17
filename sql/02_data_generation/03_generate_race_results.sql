/*******************************************************************************
 * DEMO: Generate 300K Race Results (3 years historical data)
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA RAW_INGESTION;

CREATE OR REPLACE TABLE RACE_RESULTS (
    result_id INTEGER PRIMARY KEY,
    participant_id INTEGER,
    marathon_id INTEGER,
    race_year INTEGER,
    finish_time_minutes INTEGER,
    placement_overall INTEGER,
    age_group VARCHAR(20),
    qualified_for_boston BOOLEAN
) COMMENT = 'DEMO: Historical race results';

-- Generate results: 50K participants × 6 marathons × partial participation = ~300K rows
INSERT INTO RACE_RESULTS
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ8()) AS result_id,
    UNIFORM(1, 50000, RANDOM(1000)) AS participant_id,
    UNIFORM(1, 6, RANDOM(2000)) AS marathon_id,
    UNIFORM(2023, 2025, RANDOM(3000)) AS race_year,
    UNIFORM(180, 420, RANDOM(4000)) AS finish_time_minutes, -- 3-7 hours
    UNIFORM(1, 45000, RANDOM(5000)) AS placement_overall,
    CASE UNIFORM(1, 10, RANDOM(6000))
        WHEN 1 THEN '18-24' WHEN 2 THEN '25-29' WHEN 3 THEN '30-34' WHEN 4 THEN '35-39'
        WHEN 5 THEN '40-44' WHEN 6 THEN '45-49' WHEN 7 THEN '50-54' WHEN 8 THEN '55-59'
        ELSE '60+'
    END AS age_group,
    CASE WHEN UNIFORM(1, 100, RANDOM(7000)) <= 20 THEN TRUE ELSE FALSE END AS qualified_for_boston
FROM TABLE(GENERATOR(ROWCOUNT => 300000));

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

