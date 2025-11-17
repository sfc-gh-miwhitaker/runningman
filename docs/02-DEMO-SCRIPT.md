# Demo Presenter Script - Global Marathon Analytics

**Total Duration:** 30-45 minutes  
**Audience:** Marathon event organizers and sports analytics professionals  
**Presenter Level:** Snowflake Solutions Engineer or Account Executive

---

## Pre-Demo Checklist

- [ ] Demo environment deployed via `sql/00_deploy_all.sql` in Snowsight
- [ ] Snowflake Intelligence configured with MARATHON_INSIGHTS semantic view
- [ ] Snowsight open in browser, logged into demo account
- [ ] Intelligence chat interface ready
- [ ] This script open for reference
- [ ] `docs/04-SAMPLE-QUESTIONS.md` open in separate tab
- [ ] Screen sharing tested (hide personal data/tabs)

---

## Opening: Business Context (2 minutes)

### Talking Points

**Good morning/afternoon. I'm [Name] from Snowflake, and today I'm excited to show you how Snowflake Intelligence can transform the way marathon event organizers analyze data across all six major marathons.**

**Quick context on your organization:**
- You manage the world's six most prestigious marathons: Tokyo, Boston, London, Berlin, Chicago, and New York City
- You have a global title sponsor across all events
- You're balancing multiple data challenges:
  - Understanding fan engagement across global events
  - Measuring sponsorship ROI and media exposure
  - Tracking elite athlete performance
  - Optimizing event operations in real-time

**The challenge:**
Most organizations have data scattered across systems, requiring technical teams to write SQL queries, build dashboards, and wait days or weeks for insights. Business users can't self-serve their analytics needs.

**Today's goal:**
Show you how Snowflake Intelligence lets anyone ask questions in plain English and get accurate, trusted answers instantly—without writing a single line of SQL.

Let's dive in.

---

## Problem Statement: Current Analytics Challenges (3 minutes)

### Talking Points

**Before we jump into the demo, let's talk about the typical analytics workflow you might be experiencing today:**

#### Challenge 1: Siloed Data
- Marathon registration data in one system
- Social media sentiment from Twitter/Instagram APIs
- Broadcast metrics from media partners
- Sponsor activation data in spreadsheets
- Each marathon may have slightly different schemas

**Question to audience:** *"Does this sound familiar? How many different tools do your teams currently use to get a complete picture?"*

#### Challenge 2: Technical Bottleneck
- Business question: *"Which marathon had the best fan sentiment this year?"*
- Current process:
  1. Submit request to data team
  2. Data team writes SQL joins across 3-4 tables
  3. Build visualization
  4. Deliver report (3-5 days later)
  5. Business team has follow-up question → repeat cycle

**Result:** Decisions are delayed, opportunities are missed.

#### Challenge 3: Lack of Context
- Technical teams understand SQL but not business context
- Example: What does "qualified" mean for a runner? Boston qualifying time varies by age group.
- Business metrics like "sponsor visibility per dollar" require tribal knowledge

**The Vision:**
What if marketing managers, event operations teams, and executives could just ask questions conversationally and get instant, accurate answers—with full transparency into where the data came from?

That's Snowflake Intelligence.

---

## Solution Overview: Snowflake Intelligence (5 minutes)

### Talking Points

**Snowflake Intelligence is a conversational AI agent that lets you analyze data using natural language. It's built on three core pillars:**

#### 1. Natural Language Understanding
- Ask questions like you would to a colleague
- No SQL knowledge required
- Understands business terminology (not just database column names)

#### 2. Semantic Layer (The Secret Sauce)
- We define a "semantic view" that maps business terms to your data model
- Example: When you say "fan sentiment," Intelligence knows to look at social media data enriched with Cortex AI sentiment scores
- Includes synonyms: "race," "event," "marathon" all mean the same thing
- Captures business logic: Revenue calculations, aggregations, relationships

#### 3. Transparent & Trustworthy
- Every answer shows the SQL that was generated
- You can see exactly which tables were queried
- Verification shields show confidence level
- Results are always traceable to source data

**[SCREEN SHARE: Show Snowsight Intelligence Interface]**

Let me show you what this looks like.

### Demo Navigation

1. Open Snowsight
2. Click **AI & ML** > **Snowflake Intelligence**
3. Select the **Marathon Analytics** agent
4. Show the semantic view is connected: `MARATHON_INSIGHTS`

**Say:** *"This agent is connected to our marathon data. It understands 6 marathons, 50,000+ runners, 3 years of race results, sponsorship data, and fan sentiment from social media. Let's ask it some questions."*

---

## Demo Scenario 1: Fan Engagement Analysis (10 minutes)

### Introduction

**Say:** *"Let's start with fan engagement. One of your key goals is understanding how fans across the globe feel about each marathon. You have social media data from Twitter, Instagram, and Facebook—but it's raw text. We've used Snowflake Cortex AI to analyze sentiment automatically. Now let's see what Intelligence can tell us."*

### Query 1: Overall Sentiment Summary

**Type in chat:**
```
Show me fan sentiment across all six major marathons this year
```

**Expected Response:**
- Table showing each marathon with average sentiment score
- Visualization: Bar chart or similar
- SQL query shown at bottom

#### Presenter Notes:
- **Pause for effect:** *"Notice how quickly that came back—instant."*
- **Click 'View SQL':** Show the generated query
- **Point out:** 
  - It knew "sentiment" meant the SENTIMENT_SCORE column
  - It aggregated across all 6 marathons automatically
  - It filtered to "this year" (2025)

**Say:** *"Intelligence wrote this SQL for me. I didn't have to know table names, join conditions, or aggregation logic. The semantic layer handled all of that."*

### Query 2: Deep Dive on Specific Marathon

**Ask audience:** *"Let's say you notice London has the highest sentiment. You want to understand why. Let's dig deeper."*

**Type in chat:**
```
What are fans saying about the London Marathon? Show me the most positive posts.
```

**Expected Response:**
- Top 10-20 posts with highest sentiment scores
- Actual post text shown
- May include summary

#### Presenter Notes:
- **Read one or two actual posts:** Show it's real data
- **Say:** *"This is where Cortex AI comes in. We used Snowflake's native SENTIMENT function to analyze every social media post. No external API calls, no data movement—it all happens inside Snowflake."*

### Query 3: Comparative Analysis

**Type in chat:**
```
Compare fan engagement between Boston Marathon and Chicago Marathon over the last 3 years
```

**Expected Response:**
- Trend lines showing engagement metrics (post volume, sentiment) over time
- Year-over-year comparison

#### Presenter Notes:
- **Point out trend:** *"Interesting—looks like Chicago's sentiment has been improving each year. You might investigate what changed in their fan experience."*
- **Business value:** *"This kind of insight helps you share best practices across events."*

### Query 4: Negative Sentiment Investigation

**Type in chat:**
```
Show me negative sentiment posts from New York City Marathon and identify common themes
```

**Expected Response:**
- Posts with negative sentiment
- (If Cortex COMPLETE was used) Summarized themes

#### Presenter Notes:
- **Say:** *"This is proactive issue detection. Instead of waiting for PR crises, you can monitor sentiment in real-time and respond quickly."*
- **Use case:** *"Imagine if you could do this during the event itself—adjust staffing, address crowd concerns, improve the experience on the fly."*

---

## Demo Scenario 2: Sponsorship ROI (10 minutes)

### Introduction

**Say:** *"Now let's shift to sponsorship analytics. You have a title sponsor, plus dozens of other partners—Gatorade, Asics, banks, airlines. Each pays significant fees and activation costs. How do you prove ROI? Let's ask Intelligence."*

### Query 5: Sponsor Visibility

**Type in chat:**
```
Which marathon provided the highest media exposure for the title sponsor this year?
```

**Expected Response:**
- Table showing total media exposure minutes by marathon
- Title sponsor logo appearances during TV broadcasts
- Cost per minute of exposure

#### Presenter Notes:
- **Say:** *"This data comes from broadcast monitoring. We track every time a sponsor logo appears on screen, how long it's visible, and calculate cost efficiency."*
- **Point to cost per minute:** *"This is the kind of metric sponsors care about. You can now justify premium pricing for high-visibility events."*

### Query 6: Sponsorship Tier Analysis

**Type in chat:**
```
Compare ROI across Platinum, Gold, and Silver sponsorship tiers for the Berlin Marathon
```

**Expected Response:**
- Table showing investment vs. exposure by tier
- ROI calculation (exposure value / total spend)

#### Presenter Notes:
- **Business impact:** *"This helps you optimize sponsorship packages. If Silver sponsors are getting disproportionate value, maybe you need to adjust pricing or benefits."*

### Query 7: Sponsor Activation Effectiveness

**Type in chat:**
```
Did the title sponsor's activation spend correlate with higher fan engagement at Chicago Marathon?
```

**Expected Response:**
- Correlation analysis or comparative metrics
- Activation spend vs. social media mentions/sentiment

#### Presenter Notes:
- **Say:** *"This is where it gets interesting. You're not just measuring exposure—you're measuring impact. Did the money your title sponsor spent on on-ground activations actually move the needle on fan engagement?"*
- **Strategic value:** *"These insights help you guide sponsors on where to invest their activation budgets for maximum impact."*

### Query 8: Multi-Year Trend

**Type in chat:**
```
Show me sponsor media exposure trends across all six marathons from 2023 to 2025
```

**Expected Response:**
- Line chart or table showing 3-year trends
- Growth or decline indicators

#### Presenter Notes:
- **Say:** *"You can track long-term trends. Are you delivering more value to sponsors year over year? This data supports renewal conversations."*

---

## Demo Scenario 3: Performance Insights (10 minutes)

### Introduction

**Say:** *"Finally, let's look at runner performance and event operations. You attract the world's best athletes, but you also have 50,000+ everyday runners. Let's see what Intelligence can tell us about performance trends."*

### Query 9: Qualification Rates

**Type in chat:**
```
What's the Boston Marathon qualification rate for runners from New York City Marathon over the past 3 years?
```

**Expected Response:**
- Percentage of NYC Marathon finishers who achieved Boston qualifying times
- Broken down by year
- Possibly by age group

#### Presenter Notes:
- **Say:** *"This is a strategic metric. Boston has qualifying standards. If you know that X% of NYC finishers go on to qualify, you can market NYC as a 'Boston qualifier' course."*

### Query 10: Performance by Course Difficulty

**Type in chat:**
```
Compare average finish times across easy, moderate, and hard difficulty courses
```

**Expected Response:**
- Table showing average finish time by course difficulty
- Marathons grouped by terrain

#### Presenter Notes:
- **Say:** *"Berlin and Chicago are known as fast, flat courses. Boston has hills. This data validates what you already know, but it also helps set realistic expectations for runners."*

### Query 11: Age Group Analysis

**Type in chat:**
```
Which age group has the highest participation rate across all six majors?
```

**Expected Response:**
- Bar chart showing participant distribution by age group
- Peak age range highlighted

#### Presenter Notes:
- **Marketing insight:** *"If you see 30-39 as your largest demographic, you tailor sponsorships and marketing to that audience. If 60+ is growing, you might add more age-group awards."*

### Query 12: Predictive Question (Stretch Goal)

**Type in chat:**
```
Based on historical trends, predict participant registration for Tokyo Marathon 2026
```

**Expected Response:**
- (May work if semantic view includes time-series forecasting, or may say "not enough data")
- If it works: Projected registration number

#### Presenter Notes:
- **Say:** *"This is where Intelligence gets really powerful. You're not just looking backwards—you're forecasting. This helps with logistics planning, venue sizing, volunteer staffing."*

---

## Transparency & Trust: How It Works (5 minutes)

### Show the Under-the-Hood View

**Say:** *"Let's talk about what's happening behind the scenes. A lot of AI is a black box—you don't know how it arrived at an answer. Snowflake Intelligence is different."*

### Demo: View Generated SQL

1. Go back to one of your earlier queries (e.g., fan sentiment)
2. Click **View SQL**
3. Show the complete SQL query that was generated

**Say:** *"This is the actual SQL that ran. Notice:"*
- It joined the right tables (marathons, social media posts)
- It filtered correctly (this year, specific marathon)
- It calculated the average sentiment
- All of this was generated from my natural language question

**Point out:** *"If you have a data governance team or a technical user who wants to validate the results, they can see exactly what happened. No mysteries."*

### Demo: Verification Shields

**Say:** *"You'll also see verification indicators:"*
- Green shield = High confidence (answer is directly supported by data)
- Yellow shield = Medium confidence (some assumptions made)
- Red shield = Low confidence (Intelligence is guessing, validate manually)

**Business value:** *"You can trust the green-shielded answers for decision-making. For yellow or red, you might want a human to double-check."*

---

## Q&A & Objection Handling (5 minutes)

### Common Questions

#### Q: "What if Intelligence gives a wrong answer?"

**A:** *"Great question. First, the verification shields help you identify low-confidence answers. Second, you always have the SQL query to audit. Third, we use a concept called 'Verified Queries'—you can provide example question-and-SQL pairs to train Intelligence on your specific business logic. Over time, accuracy improves."*

#### Q: "Does my data leave Snowflake?"

**A:** *"No. This is critical. Unlike ChatGPT or other external AI tools, Snowflake Intelligence runs entirely inside your Snowflake account. Your data never leaves your secure environment. The LLMs are hosted by Snowflake and comply with all your data governance policies."*

#### Q: "How long does it take to set up?"

**A:** *"For what we just showed—about 2-4 weeks. The heavy lifting is building the semantic view, which requires mapping your business terminology to your data model. Once that's done, adding new tables or metrics is quick. And non-technical users can start asking questions immediately."*

#### Q: "Can I integrate this into our existing tools?"

**A:** *"Yes. Intelligence has a REST API. You can embed it into:*
- Microsoft Teams (native integration available)
- Slack
- Custom web apps
- Streamlit dashboards
*The chat interface we're using today is just one way to interact with it."*

#### Q: "What if I have data outside Snowflake?"

**A:** *"You have two options:*
1. Load that data into Snowflake (we have 200+ connectors for databases, SaaS apps, cloud storage)
2. Use Snowflake's data federation features to query external sources without moving data
*Intelligence works with any data accessible via Snowflake SQL."*

---

## Next Steps & Call to Action (5 minutes)

### Immediate Next Steps

**Say:** *"Here's what I recommend as next steps for your organization:"*

#### Step 1: Proof of Concept (2-3 weeks)
- **Goal:** Get Intelligence running on a subset of your real data (e.g., one marathon, one year)
- **Deliverable:** A working semantic view that answers 10-20 key business questions
- **Effort:** Snowflake + your data team (20-30 hours total)

#### Step 2: Expand Semantic View (4-6 weeks)
- Add all 6 marathons
- Integrate more data sources (broadcast, sponsor contracts, athlete bios)
- Build out Verified Query Repository for high-accuracy answers

#### Step 3: Roll Out to Business Users (Ongoing)
- Train marketing, operations, and executive teams on how to use Intelligence
- Embed into daily workflows (Slack, Teams, dashboards)
- Monitor usage and refine semantic view based on question patterns

### What Snowflake Will Provide

**Say:** *"If you decide to move forward, here's what you get from us:"*
- **Solutions Engineer** (me!) to design and build the semantic view
- **Best practices documentation** from other sports/entertainment customers
- **Training sessions** for your technical and business teams
- **Ongoing support** as you scale usage

### Timeline Proposal

**Propose a concrete next meeting:**

*"I'd love to schedule a follow-up in the next 1-2 weeks with your data team to discuss:"*
1. What data sources you want to include
2. The top 20 business questions you want to answer
3. Technical architecture (where data lives today, access requirements)

*"From there, we can scope a POC and have something working within a month. Does that sound reasonable?"*

---

## Closing

**Say:** *"Let me leave you with this: The world's best organizations don't wait for reports—they ask questions and get answers instantly. Snowflake Intelligence turns your data team into a force multiplier. Instead of spending days writing SQL queries, they can focus on strategy while business users self-serve their analytics needs."*

*"For marathon event organizers, this means:*
- Faster decisions on event operations
- Better ROI reporting for sponsors (and easier renewals)
- Deeper understanding of your global fanbase
- The ability to learn from one marathon and apply it to others

*"And all of this happens securely, inside Snowflake, with full transparency into how every answer was generated."*

*"Thank you for your time today. I'm happy to take any final questions, or we can dive deeper into specific use cases you're thinking about."*

---

## Appendix: Backup Questions (If Time Allows)

If you have extra time or the audience wants to see more, try these:

```
How many participants from Japan ran in marathons outside of Tokyo?
```

```
What's the correlation between weather conditions and finish times for Chicago Marathon?
```

```
Show me the top 10 fastest marathon times across all six majors in 2025
```

```
Which sponsors had the most social media mentions during London Marathon?
```

```
Compare male vs female participation rates across all six marathons
```

---

## Technical Fallback: If Intelligence Fails

If Snowflake Intelligence is unavailable or gives poor results during the demo:

**Fallback Option 1: Use SQL Directly**
- Open Snowsight SQL editor
- Run one of the queries from `sql/04_semantic_layer/02_verified_queries.sql`
- Say: *"While Intelligence is in preview, we can also query the data directly using SQL. The semantic view still provides business-friendly column names."*

**Fallback Option 2: Show the Semantic View Definition**
- Navigate to `ANALYTICS.MARATHON_INSIGHTS`
- Run: `DESCRIBE SEMANTIC VIEW MARATHON_INSIGHTS;`
- Say: *"Let me show you how the semantic layer is structured. This is what makes natural language queries possible."*

**Fallback Option 3: Focus on Cortex AI**
- Pivot to showing Cortex functions directly:
```sql
SELECT 
  post_text,
  SNOWFLAKE.CORTEX.SENTIMENT(post_text) AS sentiment,
  SNOWFLAKE.CORTEX.SUMMARIZE(post_text) AS summary
FROM RAW_INGESTION.SOCIAL_MEDIA_POSTS
LIMIT 10;
```
- Say: *"Even without Intelligence, Snowflake Cortex gives you enterprise AI functions you can call directly from SQL. No external APIs, no data movement."*

---

**End of Script**

**Presenter Notes:** Practice this script 2-3 times before the live demo. Familiarize yourself with the sample questions in `docs/04-SAMPLE-QUESTIONS.md` so you can adapt if the conversation goes in a different direction.

Good luck!

