/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Snowflake Intelligence Demo
 * Script: Create Snowflake Intelligence Agent
 *
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 *
 * PURPOSE:
 *   Creates the Marathon Analytics Cortex Agent, adds it to the default
 *   Snowflake Intelligence curated list, and grants usage to demo roles.
 *
 * CREATES:
 *   - Agent: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT
 *   - Snowflake Intelligence object (if missing)
 *
 * IDEMPOTENT: Yes (safe to re-run)
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE AGENT MARATHON_AGENT
  COMMENT = 'DEMO: Marathon Analytics Snowflake Intelligence agent'
  PROFILE = '{"display_name": "Marathon Analytics", "avatar": "finish-line", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: claude-4-sonnet

  orchestration:
    budget:
      seconds: 60
      tokens: 32000

  instructions:
    response: >
      Provide concise, business-friendly answers grounded in Snowflake data.
      Always highlight key metrics and recommend next best questions.
    orchestration: >
      Route all structured marathon analytics questions through the AnalystMarathon tool.
    system: >
      You are a Snowflake Intelligence agent helping organizers run global marathons.
    sample_questions:
      - question: "Which marathon had the highest fan sentiment this year?"
        answer: "I'll analyze the sentimental scores across marathons to see which one resonated most."
      - question: "Show sponsor ROI by marathon and highlight outliers."
        answer: "I'll compare sponsor exposure and investment to surface the strongest returns."
      - question: "How did average finish times trend for Boston over the last three years?"
        answer: "I'll review performance metrics for Boston Marathon across multiple years."
      - question: "Which city delivered the best broadcast reach per dollar?"
        answer: "I'll combine broadcast impressions and sponsor spend to determine efficiency."
      - question: "Which marathon delivered the highest fan sentiment and TV viewership this year?"
        answer: "I'll compare aggregated sentiment with broadcast reach to highlight the top event."

  tools:
    - tool_spec:
        type: cortex_analyst_text_to_sql
        name: AnalystMarathon
        description: Converts marathon business questions to SQL using the MARATHON_INSIGHTS semantic view.

  tool_resources:
    AnalystMarathon:
      semantic_view: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS
      execution_environment:
        type: warehouse
        warehouse: SFE_MARATHON_WH
        query_timeout: 60
  $$;

-- Ensure Snowflake Intelligence object exists
CREATE SNOWFLAKE INTELLIGENCE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;

-- Remove the agent if it already exists in the curated list (ignore errors)
EXECUTE IMMEDIATE
$$
BEGIN
  ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
    DROP AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT;
EXCEPTION
  WHEN STATEMENT_ERROR THEN
    NULL;
END;
$$;

-- Add agent to curated list for Snowsight visibility
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
  ADD AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT;

-- Grant usage to demo role for presenters
GRANT USAGE ON AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT TO ROLE SFE_MARATHON_ROLE;

