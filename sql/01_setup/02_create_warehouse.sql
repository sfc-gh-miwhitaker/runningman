/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Snowflake Intelligence Demo
 * Script: Virtual Warehouse Creation
 * 
 * Author: SE Community
 * Expires: 2025-12-25
 * 
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 * 
 * PURPOSE:
 *   Creates a dedicated virtual warehouse for demo compute
 * 
 * CREATES:
 *   - Warehouse: SFE_MARATHON_WH (XSMALL, auto-suspend 60s)
 * 
 * PREREQUISITES:
 *   - ACCOUNTADMIN role (or CREATE WAREHOUSE privilege)
 * 
 * SIZING:
 *   XSMALL suitable for 360K rows, <10 concurrent users
 *   Estimated cost: 2 credits/hour when running
 * 
 * IDEMPOTENT: Yes (safe to re-run)
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;

-- Create warehouse with aggressive auto-suspend for cost control
CREATE WAREHOUSE IF NOT EXISTS SFE_MARATHON_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = FALSE
  COMMENT = 'DEMO: Compute for marathon analytics - Expires 2025-12-25';

-- Grant usage to demo role
GRANT USAGE ON WAREHOUSE SFE_MARATHON_WH TO ROLE SFE_MARATHON_ROLE;

/*******************************************************************************
 * NOTE: DEFAULT_WAREHOUSE is a USER property, not a ROLE property.
 * Users can set their own default warehouse with:
 *   ALTER USER <username> SET DEFAULT_WAREHOUSE = SFE_MARATHON_WH;
 * 
 * For this demo, explicit USE WAREHOUSE statements handle context.
 ******************************************************************************/

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/
