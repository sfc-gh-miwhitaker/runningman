/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Snowflake Intelligence Demo
 * Script: Generate Marathon Master Data
 * 
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 * 
 * PURPOSE:
 *   Create master table of 6 major marathons with static data.
 * 
 * OBJECTS CREATED:
 *   - RAW_INGESTION.MARATHONS (6 rows)
 * 
 * DEPENDENCIES:
 *   - Database and schemas created (sql/01_setup/01_create_database.sql)
 *   - Warehouse created (sql/01_setup/02_create_warehouse.sql)
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA RAW_INGESTION;

-- Create marathons master table
CREATE OR REPLACE TABLE MARATHONS (
    marathon_id INTEGER PRIMARY KEY,
    marathon_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    typical_month VARCHAR(20),
    elevation_gain_meters INTEGER,
    course_difficulty VARCHAR(20),
    established_year INTEGER,
    average_participants INTEGER
) COMMENT = 'DEMO: Six major world marathons';

-- Insert 6 major marathons
INSERT INTO MARATHONS VALUES
  (1, 'Tokyo Marathon', 'Tokyo', 'Japan', 'March', 120, 'Moderate', 2007, 38000),
  (2, 'Boston Marathon', 'Boston', 'USA', 'April', 240, 'Hard', 1897, 30000),
  (3, 'London Marathon', 'London', 'UK', 'April', 40, 'Easy', 1981, 42000),
  (4, 'Berlin Marathon', 'Berlin', 'Germany', 'September', 20, 'Easy', 1974, 45000),
  (5, 'Chicago Marathon', 'Chicago', 'USA', 'October', 15, 'Easy', 1977, 45000),
  (6, 'New York City Marathon', 'New York', 'USA', 'November', 280, 'Moderate', 1970, 53000);

-- Verify
SELECT 'Marathons table created: ' || COUNT(*) || ' rows' AS status FROM MARATHONS;
SELECT * FROM MARATHONS ORDER BY marathon_id;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

