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

-- NOTE: SNOWFLAKE_EXAMPLE database is intentionally preserved for other demos
-- NOTE: Do NOT drop shared SFE_* API integrations (may be used by sibling projects)
-- To remove database entirely (not recommended): DROP DATABASE IF EXISTS SNOWFLAKE_EXAMPLE CASCADE;

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

