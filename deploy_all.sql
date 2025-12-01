/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Git-Integrated Deployment
 * 
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 * ⚠️  EXPIRES: 2025-12-25
 * 
 * Author: SE Community
 * Created: 2025-11-17
 * Expires: 2025-12-25 (30 days from creation)
 * 
 * PURPOSE:
 *   Single-script deployment that creates git integration and executes all
 *   SQL files from the repository via EXECUTE IMMEDIATE FROM.
 * 
 * USAGE IN SNOWSIGHT:
 *   1. Copy this entire file into a new Snowsight worksheet
 *   2. Click "Run All" ⚡ (or Cmd/Ctrl+Shift+Enter)
 *   3. Wait ~10 minutes for complete deployment
 *   4. No manual intervention required!
 * 
 * WHAT THIS CREATES:
 *   - API Integration: SFE_RUNNINGMAN_GIT_INTEGRATION
 *   - Git Repository Stage: SFE_RUNNINGMAN_GIT_REPO
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
 * EXPIRATION CHECK
 * 
 * This demo expires on 2025-12-25. After this date, the script will not run.
 * To extend, update the expiration date in this header and the check below.
 ******************************************************************************/

SET demo_expiration_date = '2025-12-25'::DATE;

-- Check if demo has expired
SELECT 
    CASE 
        WHEN CURRENT_DATE() > $demo_expiration_date 
        THEN 'ERROR: This demo expired on ' || $demo_expiration_date || '. Please contact SE Community for an updated version.'
        ELSE 'Demo valid until ' || $demo_expiration_date || '. Proceeding with deployment...'
    END AS expiration_status;

-- Fail if expired (this will cause an error if the demo is expired)
SELECT IFF(CURRENT_DATE() > $demo_expiration_date, 
    1/0,  -- This will cause a division by zero error to halt execution
    'Demo is valid - continuing deployment'
) AS validation;

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
CREATE OR REPLACE API INTEGRATION SFE_RUNNINGMAN_GIT_INTEGRATION
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/sfc-gh-miwhitaker/')
  ENABLED = TRUE
  COMMENT = 'DEMO: API integration for runningman git repository - Expires 2025-12-25';

-- Create git repository stage (clones the remote repository)
-- Using unqualified name here is safe because we just set the context above
CREATE OR REPLACE GIT REPOSITORY SFE_RUNNINGMAN_GIT_REPO
  API_INTEGRATION = SFE_RUNNINGMAN_GIT_INTEGRATION
  ORIGIN = 'https://github.com/sfc-gh-miwhitaker/runningman.git'
  COMMENT = 'DEMO: Git repository for Global Marathon Analytics demo - Expires 2025-12-25';

-- Fetch latest from remote (use fully qualified name for idempotency)
ALTER GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO FETCH;

/*******************************************************************************
 * STEP 2: CREATE WAREHOUSE FIRST
 * 
 * Create and set warehouse before executing any scripts via EXECUTE IMMEDIATE FROM.
 * Even DDL-only scripts require a warehouse context in the session.
 ******************************************************************************/

-- Create warehouse inline (before EXECUTE IMMEDIATE FROM)
CREATE WAREHOUSE IF NOT EXISTS SFE_MARATHON_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = FALSE
  COMMENT = 'DEMO: Compute for marathon analytics';

-- Grant usage to ACCOUNTADMIN
GRANT USAGE ON WAREHOUSE SFE_MARATHON_WH TO ROLE ACCOUNTADMIN;

-- Set warehouse context for all operations
USE WAREHOUSE SFE_MARATHON_WH;

/*******************************************************************************
 * STEP 3: SETUP - Database, Schemas, Role
 * 
 * NOTE: Using fully qualified stage paths (@database.schema.stage) to ensure
 * correct resolution even if child scripts change the database/schema context.
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/01_setup/01_create_database.sql';

/*******************************************************************************
 * STEP 4: DATA GENERATION - Synthetic Marathon Data (~360k rows)
 * This step takes 2-3 minutes
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/01_generate_marathons.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/02_generate_participants.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/03_generate_race_results.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/04_generate_sponsors.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/05_generate_social_media.sql';
EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/02_data_generation/06_generate_broadcast_data.sql';

/*******************************************************************************
 * STEP 5: STAGING LAYER - Cleaned Views
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/03_transformations/01_staging_views.sql';

/*******************************************************************************
 * STEP 6: CORTEX AI ENRICHMENT - Sentiment Analysis
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/03_transformations/03_cortex_enrichment.sql';

/*******************************************************************************
 * STEP 7: ANALYTICS LAYER - Denormalized Tables  
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/03_transformations/02_analytics_tables.sql';

/*******************************************************************************
 * STEP 8: SEMANTIC VIEW - Snowflake Intelligence
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/04_semantic_layer/01_create_semantic_view.sql';

/*******************************************************************************
 * STEP 9: SNOWFLAKE INTELLIGENCE AGENT - Marathon Analytics
 ******************************************************************************/

EXECUTE IMMEDIATE FROM '@SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/05_agent_setup/01_create_agent.sql';

/*******************************************************************************
 * DEPLOYMENT COMPLETE
 * 
 * NEXT STEPS:
 * 1. AI & ML > Snowflake Intelligence > Open agent "Marathon Analytics"
 * 2. Ask: "Show me fan sentiment across the six majors this year"
 * 3. Explore SQL + verification shields for transparency
 * 
 * OBJECTS CREATED:
 *   - Database: SNOWFLAKE_EXAMPLE
 *   - Schemas: GIT_REPOS, RAW_INGESTION, STAGING, ANALYTICS
 *   - Git Repo: SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO
 *   - API Integration: SFE_RUNNINGMAN_GIT_INTEGRATION
 *   - Warehouse: SFE_MARATHON_WH
 *   - Role: SFE_MARATHON_ROLE
 *   - Agent: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT
 * 
 * CLEANUP:
 *   Run: sql/99_cleanup/teardown_all.sql (removes demo data/schemas)
 *   Keep: SNOWFLAKE_EXAMPLE database and GIT_REPOS schema (for other demos)
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
 * → Refresh: ALTER GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO FETCH;
 * 
 * ERROR: File not found in stage
 * → Verify git fetch succeeded
 * → Check files: LIST @SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/;
 * → Check branches: SHOW GIT BRANCHES IN GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO;
 * 
 * VERIFY DEPLOYMENT:
 *   SHOW API INTEGRATIONS LIKE 'SFE_RUNNINGMAN%';
 *   SHOW GIT REPOSITORIES IN SCHEMA SNOWFLAKE_EXAMPLE.GIT_REPOS;
 *   LIST @SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO/branches/main/sql/;
 *   DESCRIBE GIT REPOSITORY SNOWFLAKE_EXAMPLE.GIT_REPOS.SFE_RUNNINGMAN_GIT_REPO;
 ******************************************************************************/
