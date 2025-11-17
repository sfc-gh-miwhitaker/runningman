/*******************************************************************************
 * DEMO: Generate 50K Synthetic Participants Using GENERATOR()
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA RAW_INGESTION;

CREATE OR REPLACE TABLE PARTICIPANTS (
    participant_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INTEGER,
    gender VARCHAR(20),
    country VARCHAR(50),
    experience_level VARCHAR(20),
    registration_year INTEGER
) COMMENT = 'DEMO: Synthetic runner participants';

INSERT INTO PARTICIPANTS
SELECT 
    ROW_NUMBER() OVER (ORDER BY SEQ8()) AS participant_id,
    CASE MOD(SEQ8(), 20)
        WHEN 0 THEN 'John' WHEN 1 THEN 'Jane' WHEN 2 THEN 'Michael' WHEN 3 THEN 'Sarah'
        WHEN 4 THEN 'David' WHEN 5 THEN 'Emily' WHEN 6 THEN 'James' WHEN 7 THEN 'Emma'
        WHEN 8 THEN 'Robert' WHEN 9 THEN 'Olivia' WHEN 10 THEN 'William' WHEN 11 THEN 'Ava'
        WHEN 12 THEN 'Richard' WHEN 13 THEN 'Sophia' WHEN 14 THEN 'Joseph' WHEN 15 THEN 'Isabella'
        WHEN 16 THEN 'Thomas' WHEN 17 THEN 'Mia' WHEN 18 THEN 'Charles' ELSE 'Charlotte'
    END AS first_name,
    CASE MOD(SEQ8(), 15)
        WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' WHEN 3 THEN 'Brown'
        WHEN 4 THEN 'Jones' WHEN 5 THEN 'Garcia' WHEN 6 THEN 'Miller' WHEN 7 THEN 'Davis'
        WHEN 8 THEN 'Rodriguez' WHEN 9 THEN 'Martinez' WHEN 10 THEN 'Hernandez' WHEN 11 THEN 'Lopez'
        WHEN 12 THEN 'Wilson' WHEN 13 THEN 'Anderson' ELSE 'Taylor'
    END AS last_name,
    UNIFORM(18, 75, RANDOM(42)) AS age,
    CASE MOD(RANDOM(100), 3) WHEN 0 THEN 'Male' WHEN 1 THEN 'Female' ELSE 'Non-binary' END AS gender,
    CASE MOD(RANDOM(200), 10)
        WHEN 0 THEN 'USA' WHEN 1 THEN 'UK' WHEN 2 THEN 'Japan' WHEN 3 THEN 'Germany'
        WHEN 4 THEN 'Canada' WHEN 5 THEN 'Australia' WHEN 6 THEN 'France' WHEN 7 THEN 'Spain'
        WHEN 8 THEN 'Italy' ELSE 'Netherlands'
    END AS country,
    CASE MOD(RANDOM(300), 4)
        WHEN 0 THEN 'Beginner' WHEN 1 THEN 'Intermediate' WHEN 2 THEN 'Advanced' ELSE 'Elite'
    END AS experience_level,
    UNIFORM(2021, 2025, RANDOM(400)) AS registration_year
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

SELECT 'Participants created: ' || COUNT(*) || ' rows' AS status FROM PARTICIPANTS;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

