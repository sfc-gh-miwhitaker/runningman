/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Snowflake Intelligence Demo
 * Script: Create Semantic View
 * 
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 * 
 * PURPOSE:
 *   Creates native semantic view using CREATE SEMANTIC VIEW DDL
 * 
 * CREATES:
 *   - Semantic View: MARATHON_INSIGHTS
 * 
 * PREREQUISITES:
 *   - Analytics tables created (DIM_*, FCT_*)
 *   - Snowflake Intelligence enabled
 * 
 * IDEMPOTENT: Yes (CREATE OR REPLACE)
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE SFE_MARATHON_WH;

CREATE OR REPLACE SEMANTIC VIEW MARATHON_INSIGHTS
  TABLES (
    marathons AS DIM_MARATHONS
      PRIMARY KEY (marathon_id)
      WITH SYNONYMS = ('events', 'races'),
    
    participants AS DIM_PARTICIPANTS
      PRIMARY KEY (participant_id)
      WITH SYNONYMS = ('runners', 'athletes'),
    
    sponsors AS DIM_SPONSORS
      PRIMARY KEY (sponsor_id)
      WITH SYNONYMS = ('partners'),
    
    performance AS FCT_MARATHON_PERFORMANCE,
    
    sponsor_perf AS FCT_SPONSOR_PERFORMANCE,
    
    fan_engagement AS FCT_FAN_ENGAGEMENT
  )
  RELATIONSHIPS (
    performance(marathon_id) REFERENCES marathons(marathon_id),
    performance(participant_id) REFERENCES participants(participant_id),
    sponsor_perf(marathon_id) REFERENCES marathons(marathon_id),
    sponsor_perf(sponsor_id) REFERENCES sponsors(sponsor_id),
    fan_engagement(marathon_id) REFERENCES marathons(marathon_id)
  )
  DIMENSIONS (
    marathons.marathon_name AS marathons.marathon_name
      WITH SYNONYMS = ('event name'),
    marathons.city AS marathons.city,
    marathons.country AS marathons.country,
    marathons.event_year AS marathons.event_year
      WITH SYNONYMS = ('year'),
    participants.full_name AS participants.full_name
      WITH SYNONYMS = ('runner name'),
    participants.gender AS participants.gender,
    participants.age AS participants.age,
    participants.runner_country AS participants.country,
    sponsors.sponsor_name AS sponsors.sponsor_name,
    sponsors.industry AS sponsors.industry,
    sponsors.sponsorship_tier AS sponsors.sponsorship_tier
      WITH SYNONYMS = ('tier'),
    performance.overall_rank AS performance.overall_rank
      WITH SYNONYMS = ('position'),
    fan_engagement.sentiment_label AS fan_engagement.sentiment_label
      WITH SYNONYMS = ('sentiment')
  )
  METRICS (
    performance.avg_finish_time AS AVG(performance.finish_time_minutes)
      WITH SYNONYMS = ('average time'),
    performance.avg_pace AS AVG(performance.pace_min_per_km),
    performance.participant_count AS COUNT(DISTINCT performance.participant_id)
      WITH SYNONYMS = ('runner count'),
    sponsor_perf.avg_exposure AS AVG(sponsor_perf.exposure_minutes),
    sponsor_perf.avg_engagement AS AVG(sponsor_perf.engagement_score),
    fan_engagement.avg_sentiment AS AVG(fan_engagement.sentiment_score),
    fan_engagement.total_likes AS SUM(fan_engagement.likes),
    fan_engagement.total_shares AS SUM(fan_engagement.shares)
  )
  COMMENT = 'DEMO: Semantic view for Snowflake Intelligence';

GRANT SELECT ON SEMANTIC VIEW MARATHON_INSIGHTS TO ROLE SFE_MARATHON_ROLE;

/*******************************************************************************
 * USAGE:
 * 1. AI & ML > Snowflake Intelligence
 * 2. Create agent: "Marathon Analytics"  
 * 3. Connect: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS
 ******************************************************************************/
