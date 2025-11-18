# Global Marathon Analytics - Snowflake Intelligence Demo

![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)

**Demo Project - NOT FOR PRODUCTION USE**

This is a flagship reference implementation that MUST set the bar for Snowflake Intelligence best practices—fully scripted deployment, governed semantic models, and a turnkey demo experience for global marathon analytics.

**Database:** All artifacts created in `SNOWFLAKE_EXAMPLE` database  
**Isolation:** Uses `SFE_` prefix for account-level objects

---

## 👋 First Time Here?

**100% Snowflake-Native Deployment** - One file, one click!

### Quick Start (Recommended)

1. **Open & Run in Snowsight** (10 min)
   - Copy the entire `sql/00_deploy_all.sql` file into a new Snowsight worksheet
   - Click **"Run All"** ⚡ (or Cmd/Ctrl+Shift+Enter)
   - Script automatically:
     - Creates API integration for git access
     - Creates git repository stage  
     - Clones repo and executes all SQL files via `EXECUTE IMMEDIATE FROM`
   - Wait for data generation (~10 min)
   - **Zero configuration required!**

2. **Verify Intelligence Agent** (2 min)
   - Script now auto-creates agent `SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT`
   - Confirm via Snowsight → AI & ML → Snowflake Intelligence (should see **Marathon Analytics**)
   - (Optional) Customize instructions/model via [docs/06-INTELLIGENCE-AGENT.md](docs/06-INTELLIGENCE-AGENT.md)

3. **Run Demo** - [docs/02-DEMO-SCRIPT.md](docs/02-DEMO-SCRIPT.md) (30-45 min)
   - Follow presenter script
   - Try queries from [docs/04-SAMPLE-QUESTIONS.md](docs/04-SAMPLE-QUESTIONS.md)

**Total setup: ~15 minutes** | **Demo: 30-45 minutes**

### What Happens Under the Hood?

The `00_deploy_all.sql` script:
1. Creates API integration (connects Snowflake to git)
2. Creates git repository stage (clones your repo)
3. Fetches latest code from remote
4. Executes each SQL file using `EXECUTE IMMEDIATE FROM @repo/branches/main/sql/...`
5. Builds semantic view and provisions the Snowflake Intelligence agent

**Safe to re-run!** Uses `OR REPLACE` for idempotency.

### Alternative: Manual Deployment

For environments without git integration:
1. Copy-paste each SQL file from `sql/` directories into Snowsight
2. Execute in order: 01_setup → 02_data_generation → 03_transformations → 04_semantic_layer

---

## What This Demo Shows

### Business Outcomes
- **Fan 360 Analytics:** Unified view of marathon participants, spectators, and digital audiences
- **Sponsorship ROI:** Measure sponsor exposure and engagement across all 6 major marathons
- **Performance Insights:** Athlete performance analysis and predictive modeling
- **Real-time Analytics:** Natural language queries for instant business insights
- **Media Reach Intelligence:** Compare broadcast viewership and regional coverage for every event

### Technical Capabilities
- **Snowflake Intelligence:** Natural language queries via Cortex Analyst
- **Semantic Views (DDL):** Native Snowflake semantic layer (`CREATE SEMANTIC VIEW`)
- **Cortex AI Functions:** SENTIMENT, SUMMARIZE for text analysis
- **Native Data Generation:** 100% Snowflake-native synthetic data using GENERATOR()
- **Fan & Broadcast Facts:** Aggregated sentiment (FCT_FAN_ENGAGEMENT) and media reach (FCT_BROADCAST_REACH) exposed directly in the semantic view
- **Agent Governance:** Documented agent creation + REST automation patterns

---

## Project Structure

```
runningman/
├── README.md                    # This file
├── docs/                        # User-facing documentation
│   ├── 01-SETUP.md             # Prerequisites & setup
│   ├── 02-DEMO-SCRIPT.md       # Complete presenter script
│   ├── 03-DEMO-WALKTHROUGH.md  # Step-by-step guide
│   ├── 04-SAMPLE-QUESTIONS.md  # Natural language queries
│   ├── 05-TECHNICAL-REFERENCE.md # Architecture details
│   └── 06-INTELLIGENCE-AGENT.md # Agent specification & customization
├── sql/                         # SQL scripts
│   ├── 00_deploy_all.sql       # 🚀 MASTER SCRIPT - Copy-paste into Snowsight!
│   ├── 01_setup/               # Database, warehouse, schema creation
│   ├── 02_data_generation/     # Synthetic data (50K+ rows)
│   ├── 03_transformations/     # Staging & analytics layers
│   ├── 04_semantic_layer/      # Semantic views (DDL)
│   ├── 05_agent_setup/         # Snowflake Intelligence agent creation
│   └── 99_cleanup/             # Complete teardown
└── diagrams/                    # Architecture diagrams (Mermaid)
    ├── data-flow.md
    ├── network-flow.md
    └── auth-flow.md
```

---

## Objects Created by This Demo

### Account-Level Objects (Require ACCOUNTADMIN)
| Object Type | Name | Purpose |
|-------------|------|---------|
| Warehouse | `SFE_MARATHON_WH` | Dedicated demo compute (XSMALL, 60s auto-suspend) |

### Database Objects (in SNOWFLAKE_EXAMPLE)
| Schema | Purpose | Key Objects |
|--------|---------|-------------|
| `RAW_INGESTION` | Landing zone | 6 raw tables (marathons, participants, results, sponsors, social media, broadcast) |
| `STAGING` | Cleaned data | Staging views for transformation |
| `ANALYTICS` | Business layer | Fact tables (FCT_MARATHON_PERFORMANCE, FCT_SPONSOR_ROI, FCT_FAN_ENGAGEMENT, FCT_BROADCAST_REACH) + ENRICHED_SOCIAL_MEDIA |
| `ANALYTICS` | Semantic layer | Semantic view: MARATHON_INSIGHTS |
| `ANALYTICS` | Intelligence | Agent: MARATHON_AGENT (added to Snowflake Intelligence object) |

**Total synthetic data:** 50,000+ participants, 300,000+ race results, 10,000+ social posts, 3 years of broadcast and sponsorship data

---

## Demo Scenarios

### Scenario 1: Fan Engagement Analysis (10 min)
Natural language queries to analyze fan sentiment across all 6 major marathons using Cortex SENTIMENT analysis.

**Sample Question:** *"Show me fan sentiment across all six majors this year"*

### Scenario 2: Sponsorship ROI (10 min)
Compare sponsor performance and media exposure across marathons.

**Sample Question:** *"Which marathon had the highest sponsor visibility per dollar for title sponsors?"*

### Scenario 3: Performance Insights (10 min)
Runner statistics, qualification rates, and trend analysis.

**Sample Question:** *"What's the average finish time trend for Boston Marathon over 3 years?"*

### Scenario 4: Media Reach & Fan Sentiment (10 min)
Blend broadcast reach with Cortex-powered sentiment to highlight where brand impact is strongest.

**Sample Question:** *"Which marathon delivered the highest fan sentiment and total TV viewership in 2025?"*

See [docs/04-SAMPLE-QUESTIONS.md](docs/04-SAMPLE-QUESTIONS.md) for 30+ additional queries.

---

## Complete Cleanup

To remove all demo artifacts:

1. Open `sql/99_cleanup/teardown_all.sql` in Snowsight
2. Click "Run All"

**Time:** < 1 minute  
**Note:** Preserves `SNOWFLAKE_EXAMPLE` database for other demos (per standards)

---

## Architecture

See `diagrams/` directory for complete architecture diagrams:
- **Data Flow:** How data moves through the pipeline (generation → transformation → semantic layer)
- **Network Flow:** Snowflake architecture and component connectivity
- **Auth Flow:** RBAC and semantic view permissions

---

## Technical Reference

### Data Generation (100% Native Snowflake)
- **GENERATOR()** for bulk row generation (50K+ records)
- **UNIFORM()** for numeric distributions (ages, times, amounts)
- **RANDOM()** with seeds for reproducible categorical data
- **SEQ8()** for unique identifiers

### Semantic Layer (Native DDL)
- **CREATE SEMANTIC VIEW** DDL (not YAML files)
- Native Snowflake objects with RBAC integration
- Verified Query Repository (VQR) for accuracy

### Cortex AI Features
- **SENTIMENT()** for social media sentiment analysis
- **SUMMARIZE()** for text condensation
- Enterprise AI without external services

---

## Support

For questions or issues:
1. Review [docs/05-TECHNICAL-REFERENCE.md](docs/05-TECHNICAL-REFERENCE.md) for architecture details
2. Check [docs/03-DEMO-WALKTHROUGH.md](docs/03-DEMO-WALKTHROUGH.md) for troubleshooting
3. Contact your Snowflake account team for Snowflake Intelligence access

---

## Reference Implementation Notice

This code demonstrates production-grade architectural patterns and best practices. Review and customize security, networking, and business logic for your organization's specific requirements before any production deployment.

**Status:** Demo/Example Project  
**Last Updated:** 2025-11-17  
**Target Audience:** Marathon event organizers and sports analytics professionals  
**Demo Duration:** 30-45 minutes

