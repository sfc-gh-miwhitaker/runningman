# Setup Guide - Global Marathon Analytics Demo

**Estimated Time:** 15 minutes  
**Method:** 100% Snowflake-native (no CLI tools required!)

---

## Prerequisites

### 1. Snowflake Account Access
- **Required Role:** `ACCOUNTADMIN` (or role with equivalent privileges)
- **Account Type:** Any Snowflake account
- **Region:** Must support Snowflake Cortex (most regions do)

### 2. Feature Availability

**Cortex AI Functions (Required):**
- ✅ `SNOWFLAKE.CORTEX.SENTIMENT()` - For social media analysis
- ✅ Generally Available in most regions
- Verify: https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions#availability

**Snowflake Intelligence (Required for NL queries):**
- ✅ Cortex Analyst for natural language queries
- Ensure the feature is enabled in your account (contact your Snowflake team if access is missing)

### 3. Browser Access
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Access to your Snowflake account via Snowsight

---

## Deployment Steps

### Step 1: Access Snowsight (1 minute)

1. Open your browser
2. Navigate to your Snowflake account URL:
   ```
   https://<your_account>.snowflakecomputing.com
   ```
3. Log in with credentials that have `ACCOUNTADMIN` role
4. Click **Projects** → **Worksheets** → **+ Worksheet**

### Step 2: Verify Cortex Access (1 minute)

Copy-paste this test query into your worksheet:

```sql
-- Test Cortex availability
SELECT SNOWFLAKE.CORTEX.SENTIMENT('This is a great demo!') AS test_sentiment;
```

**Expected Result:** A decimal number (e.g., `0.85`)

**If Error:** Cortex may not be available in your region. Check:
- https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions#availability
- Contact your Snowflake account team

### Step 3: Deploy Demo Environment (10 minutes)

> **Standard practice:** Always copy/paste the full SQL file into a fresh Snowsight worksheet. Snowsight does not execute local files directly, so every deployment follows this “copy all → paste → Run All” flow.

1. **Open the master deployment script:**
   - Navigate to `sql/00_deploy_all.sql` in this repository
   - **OR** open it directly in your editor

2. **Copy entire file contents:**
   - Select all (Cmd/Ctrl+A)
   - Copy (Cmd/Ctrl+C)

3. **Paste into Snowsight worksheet:**
   - Create a new worksheet in Snowsight
   - Paste the entire script (Cmd/Ctrl+V)

4. **Execute the script:**
   - **Option A:** Click **"Run All"** button (⚡ lightning icon) at top right
   - **Option B:** Press `Cmd+Shift+Enter` (Mac) or `Ctrl+Shift+Enter` (Windows)

5. **Wait for completion:**
   - Progress messages appear in the results pane
   - Data generation takes ~10 minutes
   - You should see nine major milestones (git setup → data → semantic view → agent)

6. **Verify deployment:**
   - Final message should show "DEPLOYMENT COMPLETE!"
   - Review object counts in the results

**What Was Created:**
- ✅ Database: `SNOWFLAKE_EXAMPLE`
- ✅ Schemas: `GIT_REPOS`, `RAW_INGESTION`, `STAGING`, `ANALYTICS`
- ✅ Warehouse: `SFE_MARATHON_WH`
- ✅ Role: `SFE_MARATHON_ROLE`
- ✅ API Integration + Git repository stage
- ✅ Synthetic data: 12 marathons, 50K participants, 300K+ race results, 10K+ social posts, 18 broadcast entries
- ✅ Aggregated facts: `FCT_FAN_ENGAGEMENT`, `FCT_BROADCAST_REACH`, plus existing performance & sponsor tables
- ✅ Semantic view: `MARATHON_INSIGHTS`
- ✅ Snowflake Intelligence agent: `SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT`

### Step 4: Verify Snowflake Intelligence Agent (3 minutes)

The deployment script now provisions the agent for you. This step is to confirm (and optionally customize) the experience.

1. **Check via SQL (optional):**
   ```sql
   SHOW AGENTS LIKE 'MARATHON_AGENT';
   DESCRIBE AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT;
   ```

2. **Open Snowsight Intelligence:**
   - AI & ML → Snowflake Intelligence
   - The curated list should include **Marathon Analytics**

3. **Run a smoke test:**
   - Ask: `How many marathons are in the system?`
   - Expect a quick response (6 marathons)

4. **Customize if needed:**
   - Update YAML in `sql/05_agent_setup/01_create_agent.sql`
   - Re-run `sql/00_deploy_all.sql`
   - See `docs/06-INTELLIGENCE-AGENT.md` for detailed guidance

---

## Verification Checklist

Run these queries in a new worksheet to verify your deployment:

```sql
-- 1. Check database exists
SHOW DATABASES LIKE 'SNOWFLAKE_EXAMPLE';

-- 2. Check warehouse exists
SHOW WAREHOUSES LIKE 'SFE_MARATHON_WH';

-- 3. Verify data volume
SELECT 'Marathons' AS table_name, COUNT(*) AS row_count 
FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.MARATHONS
UNION ALL
SELECT 'Participants', COUNT(*) 
FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.PARTICIPANTS
UNION ALL
SELECT 'Race Results', COUNT(*) 
FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.RACE_RESULTS
UNION ALL
SELECT 'Social Media Posts', COUNT(*) 
FROM SNOWFLAKE_EXAMPLE.RAW_INGESTION.SOCIAL_MEDIA_POSTS;

-- 4. Verify sentiment analysis worked
SELECT 
    sentiment_label,
    COUNT(*) AS post_count,
    ROUND(AVG(sentiment_score), 3) AS avg_score
FROM SNOWFLAKE_EXAMPLE.ANALYTICS.FCT_FAN_ENGAGEMENT
WHERE sentiment_score IS NOT NULL
GROUP BY sentiment_label
ORDER BY avg_score DESC;

-- 5. Check semantic view
SELECT COUNT(*) AS total_rows
FROM SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS;

-- 6. Verify agent
SHOW AGENTS LIKE 'MARATHON_AGENT';
DESCRIBE AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT;
```

**Expected Results:**
- ✅ 12 marathons
- ✅ 50,000 participants
- ✅ 300,000+ race results
- ✅ 10,000+ social media posts
- ✅ Sentiment distribution: Positive, Neutral, Negative
- ✅ Semantic view has rows (300K+)
- ✅ Agent shows in `SHOW AGENTS` with Schema = ANALYTICS

---

## Troubleshooting

### Issue: "Cortex function not found"

**Cause:** Cortex not available in your region or role doesn't have access.

**Solution:**
```sql
-- Check if Cortex database role exists
SHOW ROLES LIKE 'SNOWFLAKE.CORTEX_USER';

-- If it exists, grant it to your role
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ACCOUNTADMIN;
```

### Issue: "Insufficient privileges to create database"

**Cause:** Current role doesn't have CREATE DATABASE privilege.

**Solution:**
```sql
-- Switch to ACCOUNTADMIN
USE ROLE ACCOUNTADMIN;

-- Re-run deployment script
```

### Issue: "Semantic view query fails"

**Cause:** Joins in semantic view may be slow on first query (cold cache).

**Solution:**
- Wait 10-15 seconds for first query
- Subsequent queries will be faster
- Consider clustering keys in production (not needed for demo)

### Issue: "Intelligence agent not working"

**Possible Causes:**
1. Intelligence feature not enabled → Contact Snowflake account team
2. Semantic view not connected → Re-add data source in agent config
3. View has no data → Run verification queries above

---

## Next Steps

✅ **Environment deployed successfully!**

**Now proceed to:**
1. **`docs/02-DEMO-SCRIPT.md`** - Complete presenter script (30-45 min demo)
2. **`docs/03-DEMO-WALKTHROUGH.md`** - Step-by-step execution guide
3. **`docs/04-SAMPLE-QUESTIONS.md`** - 30+ sample natural language queries to try

**Quick Test Queries:**
- *"Show me average finish times by marathon"*
- *"Which marathon had the most positive fan sentiment?"*
- *"Compare sponsor visibility across all events"*

---

## Cleanup

To remove all demo objects and start fresh:

1. Open `sql/99_cleanup/teardown_all.sql` in Snowsight
2. Review the script (it drops all demo objects)
3. Execute with "Run All"

**Note:** The cleanup script preserves the `SNOWFLAKE_EXAMPLE` database itself for easy redeployment.

---

## Support & Documentation

- **Technical Reference:** `docs/05-TECHNICAL-REFERENCE.md` - Detailed architecture
- **Snowflake Docs:** https://docs.snowflake.com
- **Cortex AI:** https://docs.snowflake.com/en/user-guide/snowflake-cortex
- **Snowflake Intelligence:** https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst

---

**Setup Complete!** ✅  
Ready to demo: Proceed to `docs/02-DEMO-SCRIPT.md`
