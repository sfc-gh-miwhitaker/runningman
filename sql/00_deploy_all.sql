/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Git-Integrated Deployment
 * 
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 * 
 * PURPOSE:
 *   Single-script deployment that creates git integration and executes all
 *   SQL files from the repository via EXECUTE IMMEDIATE FROM.
 * 
 * USAGE IN SNOWSIGHT:
 *   1. Open this file in Snowsight
 *   2. Click "Run All" ⚡
 *   3. Wait ~10 minutes for complete deployment
 * 
 * WHAT THIS CREATES:
 *   - API Integration: RUNNINGMAN_GIT_INTEGRATION
 *   - Git Repository Stage: RUNNINGMAN_GIT_REPO
 *   - Complete demo environment (360k+ rows of data)
 * 
 * SAFE TO RE-RUN:
 *   Uses OR REPLACE - no errors if objects already exist
 * 
 * CLEANUP:
 *   Run: sql/99_cleanup/teardown_all.sql
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;

/*******************************************************************************
 * STEP 0: Create Database & Schema for Git Repository
 * 
 * Git repositories are schema-level objects, so we need a database/schema first.
 * We'll use SNOWFLAKE_EXAMPLE (same as the demo data).
 ******************************************************************************/

CREATE DATABASE IF NOT EXISTS SNOWFLAKE_EXAMPLE
  COMMENT = 'DEMO: Repository for example/demo projects - NOT FOR PRODUCTION';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_EXAMPLE.GIT_REPOS
  COMMENT = 'DEMO: Schema for git repository stages';

-- Grant explicit privileges to ensure we can create objects
GRANT USAGE ON DATABASE SNOWFLAKE_EXAMPLE TO ROLE ACCOUNTADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_EXAMPLE.GIT_REPOS TO ROLE ACCOUNTADMIN;

USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA GIT_REPOS;

/*******************************************************************************
 * STEP 1: Create API Integration & Git Repository
 * 
 * This section creates the Snowflake objects needed to access the git repo.
 * Safe to re-run - uses OR REPLACE for idempotency.
 ******************************************************************************/

-- Create API integration for public repository access
CREATE OR REPLACE API INTEGRATION RUNNINGMAN_GIT_INTEGRATION
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/sfc-gh-miwhitaker/')
  ENABLED = TRUE
  COMMENT = 'DEMO: API integration for runningman git repository';

-- Create git repository stage (clones the remote repository)
-- Using unqualified name here is safe because we just set the context above
CREATE OR REPLACE GIT REPOSITORY RUNNINGMAN_GIT_REPO
  API_INTEGRATION = RUNNINGMAN_GIT_INTEGRATION
  ORIGIN = 'https://github.com/sfc-gh-miwhitaker/runningman.git'
  COMMENT = 'DEMO: Git repository for Global Marathon Analytics demo';

-- Fetch latest from remote (use fully qualified name for idempotency)
ALTER GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO FETCH;

/*******************************************************************************
 * STEP 2: SETUP - Additional Schemas, Warehouse, Role
 * 
 * NOTE: Using fully qualified stage paths (@database.schema.stage) to ensure
 * correct resolution even if child scripts change the database/schema context.
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/01_setup/01_create_database.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/01_setup/02_create_warehouse.sql';

/*******************************************************************************
 * STEP 3: DATA GENERATION - Synthetic Marathon Data (~360k rows)
 * This step takes 2-3 minutes
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/01_generate_marathons.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/02_generate_participants.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/03_generate_race_results.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/04_generate_sponsors.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/05_generate_social_media.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/06_generate_broadcast_data.sql';

/*******************************************************************************
 * STEP 4: STAGING LAYER - Cleaned Views
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/03_transformations/01_staging_views.sql';

/*******************************************************************************
 * STEP 5: ANALYTICS LAYER - Denormalized Tables  
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/03_transformations/02_analytics_tables.sql';

/*******************************************************************************
 * STEP 6: CORTEX AI ENRICHMENT - Sentiment Analysis
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/03_transformations/03_cortex_enrichment.sql';

/*******************************************************************************
 * STEP 7: SEMANTIC VIEW - Snowflake Intelligence
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/04_semantic_layer/01_create_semantic_view.sql';

/*******************************************************************************
 * DEPLOYMENT COMPLETE
 * 
 * NEXT STEPS:
 * 1. AI & ML > Snowflake Intelligence > Create agent "Marathon Analytics"
 * 2. Connect: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS
 * 3. Try: "Show me average finish times by marathon"
 * 
 * OBJECTS CREATED:
 *   - Database: SNOWFLAKE_EXAMPLE
 *   - Schemas: GIT_REPOS, RAW_INGESTION, STAGING, ANALYTICS
 *   - Git Repo: SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO
 *   - API Integration: RUNNINGMAN_GIT_INTEGRATION
 *   - Warehouse: SFE_MARATHON_WH
 *   - Role: SFE_MARATHON_ROLE
 * 
 * CLEANUP:
 *   Run: sql/99_cleanup/teardown_all.sql (removes demo data/schemas)
 *   Keep: SNOWFLAKE_EXAMPLE.GIT_REPOS schema (for other demos)
 *   Manual: DROP GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO;
 *   Manual: DROP API INTEGRATION RUNNINGMAN_GIT_INTEGRATION;
 ******************************************************************************/

/*******************************************************************************
 * TROUBLESHOOTING
 * 
 * ERROR: Session does not have a current database
 * → Fixed! Script now explicitly sets database/schema context
 * 
 * ERROR: Insufficient privileges to CREATE INTEGRATION
 * → Solution: USE ROLE ACCOUNTADMIN;
 * 
 * ERROR: Could not fetch from Git repository
 * → Verify network access to github.com
 * → Check: SHOW GIT REPOSITORIES IN SCHEMA SNOWFLAKE_EXAMPLE.GIT_REPOS;
 * → Refresh: ALTER GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO FETCH;
 * 
 * ERROR: File not found in stage
 * → Verify git fetch succeeded
 * → Check files: LIST @SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/;
 * → Check branches: SHOW GIT BRANCHES IN GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO;
 * 
 * VERIFY DEPLOYMENT:
 *   SHOW API INTEGRATIONS LIKE 'RUNNINGMAN%';
 *   SHOW GIT REPOSITORIES IN SCHEMA SNOWFLAKE_EXAMPLE.GIT_REPOS;
 *   LIST @SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO/branches/main/sql/;
 *   DESCRIBE GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.RUNNINGMAN_GIT_REPO;
 ******************************************************************************/
