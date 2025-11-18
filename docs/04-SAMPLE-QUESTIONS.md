# Sample Natural Language Queries

**30+ Questions for Snowflake Intelligence Demo**

This document contains tested natural language queries you can use with Snowflake Intelligence. Queries are organized by business use case and complexity level.

---

## How to Use This Document

1. **During Demo:** Pick 8-12 questions that align with your storyline
2. **Practice:** Test all queries before your demo to understand expected answers
3. **Customization:** Modify questions based on audience interests
4. **Backup:** Keep this open during demo in case primary queries fail

---

## Fan Engagement Analysis

### Basic Queries

**Q1:** `How many marathons are in the system?`
- **Purpose:** Test query - verify Intelligence is working
- **Expected Answer:** 6 marathons
- **Complexity:** ⭐ Simple

**Q2:** `Show me all six major marathons`
- **Purpose:** List basic data
- **Expected Answer:** Table with marathon names, cities, countries
- **Complexity:** ⭐ Simple

**Q3:** `Show me fan sentiment across all six major marathons this year`
- **Purpose:** Aggregate sentiment analysis
- **Expected Answer:** Table/chart showing average sentiment by marathon
- **Complexity:** ⭐⭐ Medium

**Q4:** `Which marathon has the highest fan sentiment?`
- **Purpose:** Ranking/comparison
- **Expected Answer:** Single marathon name (e.g., "London Marathon")
- **Complexity:** ⭐⭐ Medium

### Intermediate Queries

**Q5:** `What are fans saying about the London Marathon? Show me the most positive posts.`
- **Purpose:** Detail drill-down with filtering
- **Expected Answer:** List of social media posts with high sentiment scores
- **Complexity:** ⭐⭐ Medium

**Q6:** `Show me negative sentiment posts from New York City Marathon`
- **Purpose:** Filter by sentiment and marathon
- **Expected Answer:** Posts with negative sentiment scores (<-0.5)
- **Complexity:** ⭐⭐ Medium

**Q7:** `Compare fan engagement between Boston Marathon and Chicago Marathon over the last 3 years`
- **Purpose:** Multi-entity, multi-year comparison
- **Expected Answer:** Trend data showing engagement metrics over time
- **Complexity:** ⭐⭐⭐ Advanced

**Q8:** `What's the average sentiment by marathon, sorted from highest to lowest?`
- **Purpose:** Aggregation with sorting
## Broadcast Reach & Media Impact

**Q31:** `Which marathon delivered the highest total broadcast viewership this year?`
- **Purpose:** Highlights `FCT_BROADCAST_REACH` totals
- **Expected Answer:** Marathon name with total viewers
- **Complexity:** ⭐⭐ Medium

**Q32:** `Show average concurrent viewers by marathon over the last three years`
- **Purpose:** Trend comparison across events
- **Expected Answer:** Table or chart with per-marathon averages
- **Complexity:** ⭐⭐ Medium

**Q33:** `Compare fan sentiment and broadcast reach for each marathon in 2025`
- **Purpose:** Demonstrates combining fan engagement and broadcast facts
- **Expected Answer:** Table with sentiment + viewership metrics per marathon
- **Complexity:** ⭐⭐⭐ Advanced

- **Expected Answer:** Ranked list of marathons by sentiment
- **Complexity:** ⭐⭐ Medium

### Advanced Queries

**Q9:** `Show me sentiment trends for Tokyo Marathon from 2023 to 2025`
- **Purpose:** Time series analysis for single entity
- **Expected Answer:** Trend line or table showing sentiment by year
- **Complexity:** ⭐⭐⭐ Advanced

**Q10:** `Which marathon had the biggest improvement in fan sentiment from 2023 to 2025?`
- **Purpose:** Delta calculation across time
- **Expected Answer:** Marathon name with percentage/absolute change
- **Complexity:** ⭐⭐⭐ Advanced

**Q11:** `Identify common themes in negative posts about Boston Marathon`
- **Purpose:** Text analysis and summarization
- **Expected Answer:** List of themes (if Cortex COMPLETE is used)
- **Complexity:** ⭐⭐⭐⭐ Expert

---

## Sponsorship ROI Analysis

### Basic Queries

**Q12:** `Show me all sponsors`
- **Purpose:** List basic sponsor data
- **Expected Answer:** Table with sponsor names and tiers
- **Complexity:** ⭐ Simple

**Q13:** `Which marathon provided the highest media exposure for the title sponsor this year?`
- **Purpose:** Filter by sponsor + aggregate by marathon
- **Expected Answer:** Marathon name with exposure minutes
- **Complexity:** ⭐⭐ Medium

**Q14:** `How much did the title sponsor spend on sponsorships across all six marathons?`
- **Purpose:** SUM aggregation
- **Expected Answer:** Total dollar amount
- **Complexity:** ⭐⭐ Medium

### Intermediate Queries

**Q15:** `Compare ROI across Platinum, Gold, and Silver sponsorship tiers for the Berlin Marathon`
- **Purpose:** Multi-tier comparison with calculated metric
- **Expected Answer:** Table showing investment vs. exposure by tier
- **Complexity:** ⭐⭐⭐ Advanced

**Q16:** `Which sponsors had the most social media mentions during London Marathon?`
- **Purpose:** Cross-table analysis (sponsors + social media)
- **Expected Answer:** Ranked list of sponsors by mention count
- **Complexity:** ⭐⭐⭐ Advanced

**Q17:** `What's the cost per minute of media exposure for the title sponsor across all marathons?`
- **Purpose:** Calculated metric (total spend / total exposure)
- **Expected Answer:** Dollar amount per minute
- **Complexity:** ⭐⭐ Medium

### Advanced Queries

**Q18:** `Show me sponsor media exposure trends across all six marathons from 2023 to 2025`
- **Purpose:** Multi-entity, multi-year aggregation
- **Expected Answer:** Table or line chart showing trends
- **Complexity:** ⭐⭐⭐ Advanced

**Q19:** `Did the title sponsor's activation spend correlate with higher fan engagement at Chicago Marathon?`
- **Purpose:** Correlation analysis
- **Expected Answer:** Correlation coefficient or comparative metrics
- **Complexity:** ⭐⭐⭐⭐ Expert

**Q20:** `Which marathon delivers the best value per dollar for Platinum sponsors?`
- **Purpose:** Value calculation with filtering
- **Expected Answer:** Marathon name with exposure/cost ratio
- **Complexity:** ⭐⭐⭐ Advanced

---

## Runner Performance & Operations

### Basic Queries

**Q21:** `How many participants ran across all six marathons this year?`
- **Purpose:** COUNT aggregation
- **Expected Answer:** Total participant count
- **Complexity:** ⭐ Simple

**Q22:** `What's the average finish time for the Boston Marathon?`
- **Purpose:** AVG aggregation
- **Expected Answer:** Time in hours:minutes format
- **Complexity:** ⭐⭐ Medium

**Q23:** `Which marathon has the most participants?`
- **Purpose:** MAX + GROUP BY
- **Expected Answer:** Marathon name with participant count
- **Complexity:** ⭐⭐ Medium

### Intermediate Queries

**Q24:** `Compare average finish times across easy, moderate, and hard difficulty courses`
- **Purpose:** Group by attribute with aggregation
- **Expected Answer:** Table showing avg finish time by difficulty
- **Complexity:** ⭐⭐⭐ Advanced

**Q25:** `What's the Boston Marathon qualification rate for runners from New York City Marathon over the past 3 years?`
- **Purpose:** Multi-step calculation across tables
- **Expected Answer:** Percentage (e.g., "22% qualified")
- **Complexity:** ⭐⭐⭐ Advanced

**Q26:** `Which age group has the highest participation rate across all six majors?`
- **Purpose:** Demographic analysis
- **Expected Answer:** Age range (e.g., "35-44")
- **Complexity:** ⭐⭐ Medium

**Q27:** `Show me the top 10 fastest marathon times across all six majors in 2025`
- **Purpose:** Cross-marathon ranking
- **Expected Answer:** Table with runner names, times, marathons
- **Complexity:** ⭐⭐ Medium

### Advanced Queries

**Q28:** `What's the average finish time trend for Boston Marathon over the past 3 years?`
- **Purpose:** Time series analysis
- **Expected Answer:** Trend data showing change over time
- **Complexity:** ⭐⭐⭐ Advanced

**Q29:** `How many participants from Japan ran in marathons outside of Tokyo?`
- **Purpose:** Filter exclusion logic
- **Expected Answer:** Count with breakdown by marathon
- **Complexity:** ⭐⭐⭐ Advanced

**Q30:** `Compare male vs female participation rates across all six marathons`
- **Purpose:** Demographic comparison
- **Expected Answer:** Table showing gender split by marathon
- **Complexity:** ⭐⭐ Medium

---

## Predictive & Advanced Analytics

### Stretch Goals (May Require Additional Setup)

**Q31:** `Based on historical trends, predict participant registration for Tokyo Marathon 2026`
- **Purpose:** Forecasting
- **Expected Answer:** Projected registration number
- **Complexity:** ⭐⭐⭐⭐ Expert
- **Note:** May require ML model or fail gracefully

**Q32:** `What factors correlate most strongly with high fan sentiment?`
- **Purpose:** Correlation analysis across multiple variables
- **Expected Answer:** List of factors (e.g., weather, finish time, course difficulty)
- **Complexity:** ⭐⭐⭐⭐ Expert
- **Note:** Requires statistical analysis capability

**Q33:** `Identify outlier performances in the Chicago Marathon`
- **Purpose:** Anomaly detection
- **Expected Answer:** List of unusually fast/slow times
- **Complexity:** ⭐⭐⭐⭐ Expert

---

## Cross-Functional Queries

These queries span multiple business areas:

**Q34:** `Show me all data for the London Marathon: participants, sentiment, sponsors, and broadcast metrics`
- **Purpose:** Comprehensive single-entity view
- **Expected Answer:** Multi-table summary
- **Complexity:** ⭐⭐⭐ Advanced

**Q35:** `Which marathon offers the best combination of high participant satisfaction and high sponsor ROI?`
- **Purpose:** Multi-metric optimization
- **Expected Answer:** Marathon name with supporting metrics
- **Complexity:** ⭐⭐⭐⭐ Expert

**Q36:** `Compare overall value (fan engagement + sponsor exposure + participation) across all six marathons`
- **Purpose:** Composite metric calculation
- **Expected Answer:** Ranked list with scores
- **Complexity:** ⭐⭐⭐⭐ Expert

---

## Troubleshooting Queries

Use these if primary queries fail:

**Fallback 1:** `Show me the first 10 rows from the social media posts table`
- Simple data retrieval to verify connectivity

**Fallback 2:** `Count how many participants are in the database`
- Basic aggregation

**Fallback 3:** `What data do you have access to?`
- Meta-query to understand semantic view scope

---

## Query Customization Tips

### Make Queries More Specific

**Too vague:** `Show me marathon data`  
**Better:** `Show me participant counts by marathon for 2025`

### Add Time Filters

**Basic:** `Show me fan sentiment`  
**Better:** `Show me fan sentiment for Q4 2025`

### Specify Comparison Entities

**Basic:** `Compare marathons`  
**Better:** `Compare Tokyo Marathon and Berlin Marathon on average finish time`

### Request Specific Formats

**Basic:** `Show me trends`  
**Better:** `Show me trends as a line chart with year-over-year percentage change`

---

## Expected Intelligence Behavior

### What Intelligence Does Well

✅ **Aggregations:** COUNT, AVG, SUM, MAX, MIN  
✅ **Filtering:** WHERE clauses (by year, marathon, sponsor, etc.)  
✅ **Sorting:** ORDER BY (highest to lowest, alphabetical)  
✅ **Joins:** Cross-table queries (marathons + participants + results)  
✅ **Time-based:** Queries with year, quarter, month filters  
✅ **Grouping:** GROUP BY (by marathon, age group, tier, etc.)

### What Intelligence May Struggle With

⚠️ **Complex calculations:** Multi-step formulas  
⚠️ **Statistical analysis:** Correlation, regression  
⚠️ **Unstructured text:** "Summarize all posts" without Cortex integration  
⚠️ **Predictive analytics:** Forecasting without ML models  
⚠️ **Ambiguous terms:** "Best" without definition (best = highest? fastest? cheapest?)

### Tips for Better Results

1. **Use specific entity names:**  
   ✅ "Boston Marathon"  
   ❌ "That race in Massachusetts"

2. **Include time ranges:**  
   ✅ "in 2025"  
   ❌ "recently"

3. **Define ambiguous terms:**  
   ✅ "highest average sentiment score"  
   ❌ "best marathon"

4. **One question at a time:**  
   ✅ "Show me sentiment for London"  
   ❌ "Show me sentiment for London and also sponsors and participation"

5. **Use synonyms Intelligence understands:**  
   - "race" = "marathon" = "event"  
   - "runner" = "participant"  
   - "brand" = "sponsor" = "partner"

---

## Testing Checklist

Before your demo, test:

- [ ] At least 3 queries from Fan Engagement
- [ ] At least 3 queries from Sponsorship ROI
- [ ] At least 3 queries from Runner Performance
- [ ] 1-2 cross-functional queries
- [ ] 1-2 fallback queries (for emergencies)

**Document what works:**
- Which queries return results in <5 seconds?
- Which queries produce visualizations?
- Which queries require rephrasing?

---

## Additional Resources

- **Demo Script:** `docs/02-DEMO-SCRIPT.md` - Full presentation narrative
- **Walkthrough:** `docs/03-DEMO-WALKTHROUGH.md` - Step-by-step execution
- **Technical Reference:** `docs/05-TECHNICAL-REFERENCE.md` - Data model details

---

**Last Updated:** 2025-11-17  
**Total Queries:** 36 (3 basic, 19 medium, 11 advanced, 3 expert)

