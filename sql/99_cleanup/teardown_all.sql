/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Complete Cleanup Script
 * 
 * Author: SE Community
 * Expires: 2025-12-25
 * 
 * ⚠️  THIS SCRIPT REMOVES ALL DEMO ARTIFACTS
 * 
 * PURPOSE:
 *   Complete removal of demo objects while preserving SNOWFLAKE_EXAMPLE database
 *   for other demos (per standards).
 * 
 * USAGE IN SNOWSIGHT:
 *   1. Copy this entire file into a new Snowsight worksheet
 *   2. Click "Run All" ⚡
 *   3. All demo objects will be removed in < 1 minute
 * 
 * OBJECTS REMOVED:
 *   - Schemas: RAW_INGESTION, STAGING, ANALYTICS (CASCADE removes all objects)
 *   - Warehouse: SFE_MARATHON_WH
 *   - Role: SFE_MARATHON_ROLE
 *   - Git Repository: SFE_RUNNINGMAN_GIT_REPO
 *   - API Integration: SFE_RUNNINGMAN_GIT_INTEGRATION
 * 
 * OBJECTS PRESERVED:
 *   - SNOWFLAKE_EXAMPLE database (for other demos)
 *   - SNOWFLAKE_EXAMPLE.GIT_REPOS schema (shared across demos)
 * 
 * TIME: < 1 minute
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;

-- Drop demo schemas (CASCADE removes all objects within)
DROP SCHEMA IF EXISTS SNOWFLAKE_EXAMPLE.RAW_INGESTION CASCADE;
DROP SCHEMA IF EXISTS SNOWFLAKE_EXAMPLE.STAGING CASCADE;
DROP SCHEMA IF EXISTS SNOWFLAKE_EXAMPLE.ANALYTICS CASCADE;

-- Drop dedicated warehouse
DROP WAREHOUSE IF EXISTS SFE_MARATHON_WH;

-- Drop demo role
DROP ROLE IF EXISTS SFE_MARATHON_ROLE;

-- Drop git repository (this demo's repo only)
DROP GIT REPOSITORY IF EXISTS SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO;

-- Drop API integration (this demo's integration only)
DROP API INTEGRATION IF EXISTS SFE_RUNNINGMAN_GIT_INTEGRATION;

-- NOTE: SNOWFLAKE_EXAMPLE database is intentionally preserved for other demos
-- NOTE: GIT_REPOS schema is preserved (may contain other demo repos)
-- To remove database entirely (not recommended): DROP DATABASE IF EXISTS SNOWFLAKE_EXAMPLE CASCADE;

/*******************************************************************************
 * VERIFICATION
 * 
 * Run these queries to confirm cleanup:
 *   SHOW SCHEMAS IN DATABASE SNOWFLAKE_EXAMPLE;
 *   SHOW WAREHOUSES LIKE 'SFE_MARATHON%';
 *   SHOW API INTEGRATIONS LIKE 'SFE_RUNNINGMAN%';
 *   SHOW ROLES LIKE 'SFE_MARATHON%';
 ******************************************************************************/

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

