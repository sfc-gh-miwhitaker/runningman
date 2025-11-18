/*******************************************************************************
 * DEMO PROJECT: Global Marathon Analytics - Snowflake Intelligence Demo
 * Script: Create Semantic View
 * 
 * ⚠️  NOT FOR PRODUCTION USE - EXAMPLE IMPLEMENTATION ONLY
 * 
 * PURPOSE:
 *   Creates native semantic view using CREATE SEMANTIC VIEW DDL
 *   Maps to DENORMALIZED fact tables (no separate dimension tables)
 * 
 * CREATES:
 *   - Semantic View: MARATHON_INSIGHTS
 * 
 * PREREQUISITES:
 *   - Analytics tables created (FCT_*)
 *   - Enriched tables created (ENRICHED_*)
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
    performance AS FCT_MARATHON_PERFORMANCE
      PRIMARY KEY (marathon_id, race_year)
      UNIQUE (marathon_id)
      WITH SYNONYMS = ('marathon stats', 'event performance', 'race results'),
    
    sponsor_roi AS FCT_SPONSOR_ROI
      PRIMARY KEY (sponsor_id, marathon_id, contract_year)
      WITH SYNONYMS = ('sponsor performance', 'sponsorship'),

    fan_engagement AS FCT_FAN_ENGAGEMENT
      PRIMARY KEY (marathon_id, sentiment_year)
      WITH SYNONYMS = ('fan sentiment', 'social engagement metrics'),

    broadcast AS FCT_BROADCAST_REACH
      PRIMARY KEY (marathon_id, broadcast_year)
      WITH SYNONYMS = ('broadcast metrics', 'media reach'),
    
    social AS ENRICHED_SOCIAL_MEDIA
      PRIMARY KEY (post_id)
      WITH SYNONYMS = ('fan engagement', 'social media', 'sentiment')
  )
  RELATIONSHIPS (
    sponsor_roi(marathon_id) REFERENCES performance(marathon_id),
    fan_engagement(marathon_id) REFERENCES performance(marathon_id),
    broadcast(marathon_id) REFERENCES performance(marathon_id),
    social(marathon_id) REFERENCES performance(marathon_id)
  )
  DIMENSIONS (
    -- Marathon attributes (from FCT_MARATHON_PERFORMANCE)
    performance.marathon_name AS performance.marathon_name
      WITH SYNONYMS = ('event name', 'race name'),
    performance.city AS performance.city
      WITH SYNONYMS = ('location'),
    performance.country AS performance.country,
    performance.course_difficulty AS performance.course_difficulty
      WITH SYNONYMS = ('difficulty'),
    performance.race_year AS performance.race_year
      WITH SYNONYMS = ('year', 'season'),
    
    -- Sponsor attributes (from FCT_SPONSOR_ROI)
    sponsor_roi.sponsor_name AS sponsor_roi.sponsor_name
      WITH SYNONYMS = ('sponsor'),
    sponsor_roi.industry AS sponsor_roi.industry
      WITH SYNONYMS = ('sector'),
    sponsor_roi.sponsorship_tier AS sponsor_roi.sponsorship_tier
      WITH SYNONYMS = ('tier', 'sponsorship level'),
    sponsor_roi.contract_year AS sponsor_roi.contract_year
      WITH SYNONYMS = ('sponsorship year'),
    
    -- Social media attributes (from ENRICHED_SOCIAL_MEDIA)
    social.platform AS social.platform
      WITH SYNONYMS = ('social platform', 'social network'),
    social.sentiment_category AS social.sentiment_category
      WITH SYNONYMS = ('sentiment', 'fan sentiment'),
    social.post_date AS social.post_date
      WITH SYNONYMS = ('post date', 'fan post date'),

    -- Fan engagement dimensions (aggregated)
    fan_engagement.sentiment_year AS fan_engagement.sentiment_year
      WITH SYNONYMS = ('sentiment year', 'fan year'),
    fan_engagement.top_platform_by_engagement AS fan_engagement.top_platform_by_engagement
      WITH SYNONYMS = ('top platform', 'most engaging platform'),

    -- Broadcast dimensions
    broadcast.broadcast_year AS broadcast.broadcast_year
      WITH SYNONYMS = ('broadcast year', 'telecast year'),
    broadcast.broadcast_region_count AS broadcast.broadcast_region_count
      WITH SYNONYMS = ('region count', 'market reach')
  )
  METRICS (
    -- Performance metrics
    performance.total_participants AS SUM(performance.total_participants)
      WITH SYNONYMS = ('runner count', 'participant count', 'number of runners'),
    performance.avg_finish_time AS AVG(performance.avg_finish_time_minutes)
      WITH SYNONYMS = ('average time', 'average finish time', 'mean finish time'),
    performance.fastest_time AS MIN(performance.fastest_time_minutes)
      WITH SYNONYMS = ('best time', 'winning time', 'fastest finish'),
    performance.slowest_time AS MAX(performance.slowest_time_minutes)
      WITH SYNONYMS = ('longest time', 'slowest finish'),
    performance.boston_qualifiers AS SUM(performance.boston_qualifiers)
      WITH SYNONYMS = ('boston qualifier count', 'BQ count'),
    performance.qualification_rate AS AVG(performance.qualification_rate_pct)
      WITH SYNONYMS = ('qualification rate', 'BQ rate', 'boston qualifying percentage'),
    
    -- Sponsor ROI metrics
    sponsor_roi.total_investment AS SUM(sponsor_roi.total_investment)
      WITH SYNONYMS = ('sponsor spend', 'investment', 'sponsorship cost'),
    sponsor_roi.contract_value AS SUM(sponsor_roi.contract_value)
      WITH SYNONYMS = ('contract amount'),
    sponsor_roi.activation_spend AS SUM(sponsor_roi.activation_spend)
      WITH SYNONYMS = ('activation cost'),
    sponsor_roi.avg_exposure AS AVG(sponsor_roi.media_exposure_minutes)
      WITH SYNONYMS = ('media exposure', 'tv time'),
    sponsor_roi.cost_efficiency AS AVG(sponsor_roi.cost_per_minute)
      WITH SYNONYMS = ('cost per minute', 'efficiency'),
    
    -- Fan engagement metrics (aggregated)
    fan_engagement.total_posts AS SUM(fan_engagement.total_posts)
      WITH SYNONYMS = ('social media posts', 'post count', 'number of posts'),
    fan_engagement.total_engagement AS SUM(fan_engagement.total_engagement)
      WITH SYNONYMS = ('engagement', 'social engagement', 'total interactions'),
    fan_engagement.avg_sentiment AS AVG(fan_engagement.avg_sentiment_score)
      WITH SYNONYMS = ('sentiment score', 'fan sentiment', 'average sentiment'),
    fan_engagement.positive_posts AS SUM(fan_engagement.positive_posts)
      WITH SYNONYMS = ('positive posts', 'positive mentions'),
    fan_engagement.negative_posts AS SUM(fan_engagement.negative_posts)
      WITH SYNONYMS = ('negative posts', 'negative mentions'),
    fan_engagement.positive_post_pct AS AVG(fan_engagement.positive_post_pct)
      WITH SYNONYMS = ('positive sentiment percent'),
    fan_engagement.negative_post_pct AS AVG(fan_engagement.negative_post_pct)
      WITH SYNONYMS = ('negative sentiment percent'),
    fan_engagement.avg_engagement_per_post AS AVG(fan_engagement.avg_engagement_per_post)
      WITH SYNONYMS = ('avg engagement per post', 'average interactions per post'),
    
    -- Broadcast metrics
    broadcast.total_viewership AS SUM(broadcast.total_viewership)
      WITH SYNONYMS = ('total viewers', 'viewership'),
    broadcast.avg_concurrent_viewers AS AVG(broadcast.avg_concurrent_viewers)
      WITH SYNONYMS = ('avg concurrent viewers', 'live viewers'),
    broadcast.broadcast_duration_minutes AS AVG(broadcast.broadcast_duration_minutes)
      WITH SYNONYMS = ('broadcast duration', 'air time'),
    broadcast.broadcast_region_count AS AVG(broadcast.broadcast_region_count)
      WITH SYNONYMS = ('regions reached', 'market count')
  )
  COMMENT = 'DEMO: Semantic view for Snowflake Intelligence - Marathon Analytics';

GRANT SELECT ON SEMANTIC VIEW MARATHON_INSIGHTS TO ROLE SFE_MARATHON_ROLE;

/*******************************************************************************
 * USAGE:
 * 1. AI & ML > Snowflake Intelligence
 * 2. Create agent: "Marathon Analytics"  
 * 3. Connect: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS
 * 
 * EXAMPLE QUERIES:
 * - "What's the average finish time for Boston Marathon?"
 * - "Show me sponsor investment by marathon"
 * - "What's the sentiment for NYC Marathon?"
 * - "Which marathon has the most boston qualifiers?"
 * - "Compare media exposure across all sponsors"
 ******************************************************************************/
