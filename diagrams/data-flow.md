# Data Flow - Global Marathon Analytics Demo

**Author:** Michael Whitaker  
**Last Updated:** 2025-11-17  
**Status:** Reference Implementation

![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)

**Reference Implementation:** This code demonstrates production-grade architectural patterns and best practices. Review and customize security, networking, and business logic for your organization's specific requirements before deployment.

---

## Overview

This diagram shows how marathon data flows through the system, from synthetic generation using native Snowflake functions through transformation layers to the semantic view that powers Snowflake Intelligence natural language queries.

---

## Diagram

```mermaid
graph TB
    subgraph "Data Generation (Native Snowflake)"
        GEN1[GENERATOR Function<br/>ROWCOUNT 50000]
        GEN2[UNIFORM Function<br/>Age, Time, Amount]
        GEN3[RANDOM Function<br/>Categories, Countries]
        GEN4[SEQ8 Function<br/>Unique IDs]
    end

    subgraph "RAW_INGESTION Schema"
        RAW1[(MARATHONS<br/>6 rows)]
        RAW2[(PARTICIPANTS<br/>50000 rows)]
        RAW3[(RACE_RESULTS<br/>300000 rows)]
        RAW4[(SPONSORS<br/>30 rows)]
        RAW5[(SOCIAL_MEDIA_POSTS<br/>10000 rows)]
        RAW6[(BROADCAST_METRICS<br/>18 rows)]
    end

    subgraph "STAGING Schema (Views)"
        STG1[STG_MARATHON_DETAILS<br/>Clean, Type-Cast]
        STG2[STG_PARTICIPANT_DEMOGRAPHICS<br/>Age Groups, Countries]
        STG3[STG_RACE_PERFORMANCE<br/>Times, Placements]
        STG4[STG_SOCIAL_MEDIA<br/>Text Normalization]
    end

    subgraph "ANALYTICS Schema (Tables)"
        FACT1[(FCT_MARATHON_PERFORMANCE<br/>Aggregated Metrics)]
        FACT2[(FCT_SPONSOR_ROI<br/>Investment & Exposure)]
        FACT3[(ENRICHED_SOCIAL_MEDIA<br/>Cortex AI Enhanced)]
    end

    subgraph "Cortex AI Enrichment"
        CORTEX1[SENTIMENT Function<br/>-1.0 to 1.0]
        CORTEX2[SUMMARIZE Function<br/>Text Condensation]
    end

    subgraph "Semantic Layer"
        SEM1[SEMANTIC VIEW:<br/>MARATHON_INSIGHTS<br/>DDL-Based]
        SEM2[Logical Tables:<br/>- marathon_performance<br/>- sponsor_roi<br/>- fan_engagement]
        SEM3[Dimensions:<br/>marathon_name, race_year<br/>sponsor_name, city]
        SEM4[Metrics:<br/>avg_finish_time<br/>total_participants<br/>cost_per_minute]
    end

    subgraph "Intelligence Interface"
        INT1[Snowflake Intelligence<br/>Natural Language Queries]
        INT2[Cortex Analyst<br/>SQL Generation]
        INT3[Verification Shields<br/>Trust Indicators]
    end

    subgraph "Query Examples"
        Q1["Show me fan sentiment<br/>across all six majors"]
        Q2["Which marathon had highest<br/>sponsor visibility per dollar?"]
        Q3["What's the average finish time<br/>trend for Boston Marathon?"]
    end

    GEN1 --> RAW1
    GEN1 --> RAW2
    GEN1 --> RAW3
    GEN2 --> RAW2
    GEN2 --> RAW3
    GEN3 --> RAW2
    GEN3 --> RAW5
    GEN4 --> RAW2
    GEN4 --> RAW3

    RAW1 --> STG1
    RAW2 --> STG2
    RAW3 --> STG3
    RAW5 --> STG4

    STG1 --> FACT1
    STG2 --> FACT1
    STG3 --> FACT1
    STG1 --> FACT2
    RAW4 --> FACT2
    STG4 --> FACT3

    STG4 --> CORTEX1
    STG4 --> CORTEX2
    CORTEX1 --> FACT3
    CORTEX2 --> FACT3

    FACT1 --> SEM1
    FACT2 --> SEM1
    FACT3 --> SEM1
    SEM1 --> SEM2
    SEM2 --> SEM3
    SEM2 --> SEM4

    SEM1 --> INT1
    INT1 --> INT2
    INT2 --> INT3

    INT1 --> Q1
    INT1 --> Q2
    INT1 --> Q3

    style GEN1 fill:#e1f5ff
    style GEN2 fill:#e1f5ff
    style GEN3 fill:#e1f5ff
    style GEN4 fill:#e1f5ff
    style CORTEX1 fill:#fff9c4
    style CORTEX2 fill:#fff9c4
    style SEM1 fill:#c8e6c9
    style INT1 fill:#f8bbd0
```

---

## Component Descriptions

### Data Generation Layer

**Component:** GENERATOR() Function  
**Purpose:** Generate bulk synthetic data without external dependencies  
**Technology:** Native Snowflake table function  
**Location:** `sql/02_data_generation/*.sql`  
**Dependencies:** None (native Snowflake)

**Example:**
```sql
SELECT * FROM TABLE(GENERATOR(ROWCOUNT => 50000))
```

**Component:** UNIFORM() Function  
**Purpose:** Generate random numeric values within specified ranges  
**Technology:** Native Snowflake random distribution function  
**Usage:** Ages (18-75), finish times (180-300 min), contract values ($100K-$5M)

**Component:** RANDOM() Function  
**Purpose:** Generate random categorical data with seeds for reproducibility  
**Technology:** Native Snowflake pseudo-random generator  
**Usage:** Gender, country, experience level, social media platform

**Component:** SEQ8() Function  
**Purpose:** Generate unique sequential identifiers  
**Technology:** Native Snowflake sequence function  
**Usage:** participant_id, result_id, post_id

---

### RAW_INGESTION Schema

**Component:** Landing Zone Tables  
**Purpose:** Store unmodified generated data  
**Technology:** Snowflake permanent tables with COMMENT metadata  
**Location:** `sql/02_data_generation/*.sql`  
**Dependencies:** Database and schema created by setup scripts

**Tables:**
- **MARATHONS:** 6 records (Tokyo, Boston, London, Berlin, Chicago, NYC)
- **PARTICIPANTS:** 50,000 synthetic runner profiles
- **RACE_RESULTS:** 300,000 results over 3 years
- **SPONSORS:** 30 sponsor companies
- **SOCIAL_MEDIA_POSTS:** 10,000 fan posts
- **BROADCAST_METRICS:** 18 records (6 marathons × 3 years)

---

### STAGING Schema

**Component:** Transformation Views  
**Purpose:** Clean, type-cast, and prepare data for analytics  
**Technology:** Snowflake views (no storage duplication)  
**Location:** `sql/03_transformations/01_staging_views.sql`  
**Dependencies:** RAW_INGESTION tables

**Transformations:**
- Data type conversions (VARCHAR to DATE, STRING to NUMBER)
- NULL handling and default values
- Column renaming for clarity
- Basic calculated fields (age groups, time categories)
- Text normalization (TRIM, UPPER, LOWER)

---

### ANALYTICS Schema

**Component:** Fact Tables  
**Purpose:** Pre-aggregated, business-ready data  
**Technology:** Snowflake materialized tables  
**Location:** `sql/03_transformations/02_analytics_tables.sql`  
**Dependencies:** STAGING views

**Tables:**
- **FCT_MARATHON_PERFORMANCE:** Runner metrics by marathon and year
- **FCT_SPONSOR_ROI:** Sponsorship investment vs. exposure analysis
- **ENRICHED_SOCIAL_MEDIA:** Posts with AI-generated sentiment scores

---

### Cortex AI Enrichment

**Component:** SENTIMENT() Function  
**Purpose:** Analyze emotional tone of social media posts  
**Technology:** Snowflake Cortex AI (LLM-powered)  
**Location:** `sql/03_transformations/03_cortex_enrichment.sql`  
**Dependencies:** CORTEX_USER database role

**Input:** Post text (VARCHAR)  
**Output:** Sentiment score (-1.0 to 1.0)  
**Interpretation:**
- **0.5 to 1.0:** Positive sentiment
- **-0.5 to 0.5:** Neutral sentiment
- **-1.0 to -0.5:** Negative sentiment

**Cost:** ~0.10 credits per 1M tokens

**Component:** SUMMARIZE() Function  
**Purpose:** Generate concise summaries of long text  
**Technology:** Snowflake Cortex AI  
**Usage:** Condense lengthy fan reviews or reports  
**Cost:** ~0.10 credits per 1M tokens

---

### Semantic Layer

**Component:** MARATHON_INSIGHTS Semantic View  
**Purpose:** Map business terminology to database schema for natural language queries  
**Technology:** CREATE SEMANTIC VIEW (DDL)  
**Location:** `sql/04_semantic_layer/01_create_semantic_view.sql`  
**Dependencies:** ANALYTICS fact tables, semantic view feature enabled in account

**Structure:**
- **Logical Tables:** marathon_performance, sponsor_roi, fan_engagement
- **Dimensions:** Filterable columns (marathon_name, race_year, sponsor_name, platform)
- **Metrics:** Calculated measures (COUNT, AVG, SUM with business logic)
- **Synonyms:** Alternative names ("race" = "marathon" = "event")
- **Relationships:** Foreign key connections between logical tables

**Why DDL over YAML:**
- Native Snowflake object with full RBAC
- Discoverable via SHOW SEMANTIC VIEWS
- Version-controlled through DDL history
- Future-proof (YAML models being deprecated)

---

### Intelligence Interface

**Component:** Snowflake Intelligence  
**Purpose:** Natural language query interface for business users  
**Technology:** Cortex Analyst + Semantic View  
**Access:** Snowsight UI → AI & ML → Snowflake Intelligence  
**Dependencies:** Semantic view, Intelligence enabled in account

**Component:** Cortex Analyst  
**Purpose:** LLM-powered text-to-SQL translation engine  
**Technology:** Meta Llama, Mistral models (hosted by Snowflake)  
**Process:**
1. Parse natural language question
2. Understand intent using semantic view metadata
3. Generate syntactically correct SQL
4. Execute on Snowflake engine
5. Return results with confidence indicators

**Component:** Verification Shields  
**Purpose:** Trust indicators for query results  
**Types:**
- **Green Shield:** High confidence (direct data match)
- **Yellow Shield:** Medium confidence (interpretation required)
- **Red Shield:** Low confidence (verify manually)

---

## Data Flow Stages

### Stage 1: Generation (1-2 minutes)

**Input:** SQL scripts with GENERATOR() functions  
**Process:** Bulk insert of synthetic data  
**Output:** Raw tables in RAW_INGESTION schema  
**Volume:** 360,000+ total rows across 6 tables

### Stage 2: Staging (Seconds)

**Input:** Raw tables  
**Process:** View-based transformations (no data movement)  
**Output:** Cleaned views in STAGING schema  
**Key Operations:** Type casting, NULL handling, text normalization

### Stage 3: Analytics (30-60 seconds)

**Input:** Staging views  
**Process:** Aggregations, joins, denormalization  
**Output:** Materialized fact tables  
**Key Operations:** GROUP BY, JOIN, calculated metrics

### Stage 4: Cortex Enrichment (2-3 minutes)

**Input:** Social media post text  
**Process:** Sentiment analysis via Cortex AI  
**Output:** ENRICHED_SOCIAL_MEDIA table with sentiment_score column  
**Volume:** 10,000 posts × ~100 tokens each = 1M tokens  
**Cost:** ~0.10 credits

### Stage 5: Semantic View Creation (Instant)

**Input:** Fact tables  
**Process:** DDL execution (CREATE SEMANTIC VIEW)  
**Output:** MARATHON_INSIGHTS semantic view object  
**No Data Movement:** Semantic view is metadata only

### Stage 6: Query Execution (2-5 seconds per query)

**Input:** Natural language question  
**Process:** Cortex Analyst generates SQL → Execute → Return results  
**Output:** Table, chart, or text response with verification shield

---

## Data Freshness Strategy

### Batch Processing (Demo)

**Pattern:** Generate all data once during setup  
**Refresh:** Manual re-run of generation scripts  
**Latency:** Static dataset (no incremental updates)

### Incremental Pattern (Production)

**Pattern:** Load only new data  
**Implementation:**
```sql
-- Incremental load pattern
INSERT INTO RAW_INGESTION.SOCIAL_MEDIA_POSTS
SELECT * FROM external_stage
WHERE post_date > (SELECT MAX(post_date) FROM RAW_INGESTION.SOCIAL_MEDIA_POSTS);
```

**Cortex Re-enrichment:**
```sql
-- Enrich only new posts
INSERT INTO ANALYTICS.ENRICHED_SOCIAL_MEDIA
SELECT 
  *,
  SNOWFLAKE.CORTEX.SENTIMENT(post_text) AS sentiment_score
FROM RAW_INGESTION.SOCIAL_MEDIA_POSTS
WHERE post_id NOT IN (SELECT post_id FROM ANALYTICS.ENRICHED_SOCIAL_MEDIA);
```

### Real-Time Pattern (Advanced)

**Pattern:** Snowpipe Streaming + Dynamic Tables  
**Implementation:** Not included in demo (stretch goal)  
**Latency:** <1 minute from data arrival to query-ready

---

## Performance Metrics

### Data Generation Performance

| Table | Rows | Generation Time | Method |
|-------|------|----------------|--------|
| MARATHONS | 6 | <1 second | Static VALUES |
| PARTICIPANTS | 50,000 | 5-10 seconds | GENERATOR(ROWCOUNT => 50000) |
| RACE_RESULTS | 300,000 | 30-45 seconds | GENERATOR + CROSS JOIN |
| SPONSORS | 30 | <1 second | Static VALUES |
| SOCIAL_MEDIA_POSTS | 10,000 | 10-15 seconds | GENERATOR + text templates |
| BROADCAST_METRICS | 18 | <1 second | CROSS JOIN marathons × years |

**Total Generation Time:** ~2-3 minutes on XSMALL warehouse

### Query Performance

| Query Type | Avg Response Time | Example |
|------------|-------------------|---------|
| Simple aggregation | 1-2 seconds | "How many marathons?" |
| Single-table filter | 2-3 seconds | "Show me London Marathon posts" |
| Multi-table join | 3-5 seconds | "Compare sponsor ROI across marathons" |
| Cortex AI enrichment | 5-10 seconds | First-time sentiment analysis |
| Complex time-series | 5-8 seconds | "Show trends over 3 years" |

**Note:** First query on a cold warehouse may take 10-15 seconds (warehouse startup time)

---

## Change History

See `.cursor/DIAGRAM_CHANGELOG.md` for version history and architecture decisions.

---

**Last Updated:** 2025-11-17  
**Next:** See `network-flow.md` for Snowflake infrastructure architecture

