/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Complete Cleanup Script
 * 
 * ⚠️  THIS SCRIPT REMOVES ALL DEMO ARTIFACTS
 * 
 * PURPOSE:
 *   Complete removal of demo objects while preserving SNOWFLAKE_EXAMPLE database
 *   for other demos (per standards).
 * 
 * OBJECTS REMOVED:
 *   - All schemas (CASCADE removes tables, views, semantic views)
 *   - SFE_MARATHON_WH warehouse
 * 
 * OBJECTS PRESERVED:
 *   - SNOWFLAKE_EXAMPLE database (empty, for other demos)
 *   - SFE_* API integrations (shared resources)
 * 
 * TIME: < 1 minute
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;

-- Drop schemas (CASCADE removes all objects within)
DROP SCHEMA IF EXISTS SNOWFLAKE_EXAMPLE.MARATHON_ANALYTICS CASCADE;
DROP SCHEMA IF EXISTS SNOWFLAKE_EXAMPLE.RAW_INGESTION CASCADE;
DROP SCHEMA IF EXISTS SNOWFLAKE_EXAMPLE.STAGING CASCADE;
DROP SCHEMA IF EXISTS SNOWFLAKE_EXAMPLE.ANALYTICS CASCADE;

-- Drop dedicated warehouse
DROP WAREHOUSE IF EXISTS SFE_MARATHON_WH;

-- Note: SNOWFLAKE_EXAMPLE database preserved for other demos
-- To remove database: DROP DATABASE IF EXISTS SNOWFLAKE_EXAMPLE CASCADE;

-- Verification
SELECT 'Cleanup complete. SNOWFLAKE_EXAMPLE database preserved.' AS status;
SHOW SCHEMAS IN DATABASE SNOWFLAKE_EXAMPLE;
SHOW WAREHOUSES LIKE 'SFE_MARATHON_WH';

/*******************************************************************************
 * VERIFICATION QUERIES
 * 
 * Confirm all objects removed:
 ******************************************************************************/

-- Should return no results:
-- SHOW TABLES IN SCHEMA SNOWFLAKE_EXAMPLE.RAW_INGESTION;
-- SHOW VIEWS IN SCHEMA SNOWFLAKE_EXAMPLE.STAGING;
-- SHOW TABLES IN SCHEMA SNOWFLAKE_EXAMPLE.ANALYTICS;

-- Warehouse should not exist:
-- SHOW WAREHOUSES LIKE 'SFE_MARATHON_WH';

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

