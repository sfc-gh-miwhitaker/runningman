# Demo Walkthrough - Step-by-Step Execution Guide

**Reference During Live Demo**

This guide provides detailed steps for executing the Global Marathon Analytics Snowflake Intelligence demo. Use this alongside `docs/02-DEMO-SCRIPT.md` during your presentation.

---

## Pre-Demo Setup (15 minutes before start)

### 1. Verify Demo Environment

Run validation script:
```bash
See verification queries in docs/01-SETUP.md
```

**Expected Output:**
```
✓ Database SNOWFLAKE_EXAMPLE exists
✓ Warehouse SFE_MARATHON_WH exists
✓ Schema RAW_INGESTION exists
✓ Schema STAGING exists
✓ Schema ANALYTICS exists
✓ Table MARATHONS: 6 rows
✓ Table PARTICIPANTS: 50000+ rows
✓ Table RACE_RESULTS: 300000+ rows
✓ Semantic view MARATHON_INSIGHTS exists
All checks passed!
```

### 2. Open Snowsight

1. Navigate to your Snowflake account URL
2. Log in with demo credentials (use ACCOUNTADMIN role)
3. Open Snowsight interface (modern UI)

### 3. Verify Intelligence Agent

- AI & ML → Snowflake Intelligence
- Confirm **Marathon Analytics** appears in curated list (auto-created by script)
- Click the agent → **Settings** → confirm semantic view = `SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS`
- Optional: tweak sample questions/instructions (see `docs/06-INTELLIGENCE-AGENT.md`) then re-run agent script

### 4. Test Query

Run a simple test to ensure Intelligence is working:

**Test Query:** `How many marathons are in the system?`

**Expected Answer:** `There are 6 marathons in the system.`

If this works, you're ready to demo!

### 5. Prepare Your Screen

**Browser Tabs:**
1. Snowsight Intelligence (main demo tab)
2. This walkthrough guide
3. `docs/04-SAMPLE-QUESTIONS.md` (backup questions)

**Close/Hide:**
- Personal email, Slack, other apps
- Any tabs with sensitive data
- Desktop notifications (Do Not Disturb mode)

---

## Demo Execution Steps

### Opening: Introduction (2 min)

**Action:** Share your screen (Snowsight tab)

**Say:** Follow opening from `docs/02-DEMO-SCRIPT.md`

**Show:** Snowsight home page, then navigate to Intelligence

---

### Problem Statement (3 min)

**Action:** Don't share screen yet (or show simple slides if you have them)

**Say:** Discuss current analytics challenges (see demo script)

**Tip:** Engage the audience—ask if these challenges sound familiar

---

### Solution Overview (5 min)

**Action:** Navigate to Intelligence interface

**Steps:**
1. Click **AI & ML** in left sidebar
2. Click **Snowflake Intelligence**
3. Select **Marathon Analytics** agent
4. Show the chat interface

**Say:** "This is Snowflake Intelligence. Let me show you how it works by asking some real business questions."

**Point out:**
- Clean, simple chat interface
- Semantic view connection shown at top
- History of previous queries (if any) on left

---

### Scenario 1: Fan Engagement (10 min)

#### Query 1: Overall Sentiment

**Type:** `Show me fan sentiment across all six major marathons this year`

**Wait for response** (should be 2-5 seconds)

**Actions while waiting:**
- Don't say anything—let the audience see the speed
- When results appear, pause for effect

**When results appear:**

1. **Point to visualization:**
   - "Here's a bar chart showing average sentiment by marathon"
   - "London has the highest sentiment at 0.72"

2. **Click 'View SQL':**
   - "Let me show you the SQL that was generated"
   - Scroll through the query briefly
   - Point out: JOIN, AVG(), WHERE year = 2025
   - "I didn't write this—Intelligence did"

3. **Click verification shield:**
   - "Green shield means high confidence"
   - "The answer is directly supported by data"

#### Query 2: Specific Marathon Posts

**Type:** `What are fans saying about the London Marathon? Show me the most positive posts.`

**When results appear:**

1. **Read one actual post aloud:**
   - Pick a positive, family-friendly post
   - "These are real social media posts analyzed by Cortex AI"

2. **Point to sentiment scores:**
   - "Each post has a sentiment score from -1 to 1"
   - "These are all 0.8 or higher—very positive"

3. **Business value:**
   - "This helps you understand what fans love"
   - "You can share these with sponsors or use in marketing"

#### Query 3: Comparative Analysis

**Type:** `Compare fan engagement between Boston Marathon and Chicago Marathon over the last 3 years`

**When results appear:**

1. **Point to trends:**
   - If visualization shows trend lines: "Chicago is improving"
   - If table: "Look at the year-over-year growth"

2. **Ask audience:**
   - "What might explain this trend?"
   - "Could Chicago have improved course amenities? Better marketing?"

3. **Business value:**
   - "You can identify best practices and replicate across events"

#### Query 4: Negative Sentiment

**Type:** `Show me negative sentiment posts from New York City Marathon and identify common themes`

**When results appear:**

1. **Scan the posts:**
   - Look for common complaints (crowding, water stations, etc.)
   - "I see several mentions of long porta-potty lines"

2. **Proactive monitoring:**
   - "Imagine monitoring this during the event"
   - "You could dispatch more volunteers to problem areas in real-time"

---

### Scenario 2: Sponsorship ROI (10 min)

#### Query 5: Sponsor Visibility

**Type:** `Which marathon provided the highest media exposure for the title sponsor this year?`

**When results appear:**

1. **Identify the winner:**
   - "New York City Marathon gave the title sponsor 127 minutes of TV exposure"
   - "That's over 2 hours of brand visibility"

2. **Show cost calculation:**
   - "Cost per minute was $X"
   - "Compare that to a 30-second Super Bowl ad"

3. **Sponsor conversation:**
   - "This is the data sponsors want to see"
   - "Justifies their investment"

#### Query 6: Tier Analysis

**Type:** `Compare ROI across Platinum, Gold, and Silver sponsorship tiers for the Berlin Marathon`

**When results appear:**

1. **Point to ROI column:**
   - "Platinum sponsors get 4.2x return"
   - "Gold gets 3.1x"
   - "Silver gets 2.8x"

2. **Pricing strategy:**
   - "Are these tiers priced correctly?"
   - "If Silver is getting close to Gold ROI, maybe Silver is underpriced"

#### Query 7: Activation Effectiveness

**Type:** `Did the title sponsor's activation spend correlate with higher fan engagement at Chicago Marathon?`

**When results appear:**

1. **Interpret correlation:**
   - If positive: "Yes, higher activation spend = higher engagement"
   - If negative or neutral: "Interesting—maybe activation strategy needs adjustment"

2. **Strategic guidance:**
   - "This helps sponsors allocate budgets"
   - "On-ground activations vs. digital campaigns"

#### Query 8: Multi-Year Trend

**Type:** `Show me sponsor media exposure trends across all six marathons from 2023 to 2025`

**When results appear:**

1. **Identify growth:**
   - "Overall exposure is up 15% over 3 years"
   - "You're delivering more value to sponsors year over year"

2. **Renewal conversations:**
   - "This data supports contract renewals"
   - "Shows you're continuously improving sponsor value"

---

### Scenario 3: Performance Insights (10 min)

#### Query 9: Qualification Rates

**Type:** `What's the Boston Marathon qualification rate for runners from New York City Marathon over the past 3 years?`

**When results appear:**

1. **State the number:**
   - "22% of NYC finishers achieved Boston qualifying times"

2. **Marketing angle:**
   - "NYC can market itself as a fast, qualifier-friendly course"
   - "Partner with Boston to promote the connection"

#### Query 10: Course Difficulty

**Type:** `Compare average finish times across easy, moderate, and hard difficulty courses`

**When results appear:**

1. **Point out differences:**
   - "Easy courses (Berlin, Chicago): 4:15 average"
   - "Hard courses (Boston): 4:42 average"
   - "27-minute difference"

2. **Expectations setting:**
   - "Helps runners choose the right race"
   - "Boston runners should train for hills"

#### Query 11: Age Group

**Type:** `Which age group has the highest participation rate across all six majors?`

**When results appear:**

1. **Identify peak demographic:**
   - "35-44 age group is 38% of all runners"

2. **Marketing implications:**
   - "Tailor messaging to mid-career professionals"
   - "Partner with brands that appeal to this demographic"

#### Query 12: Predictive (Optional)

**Type:** `Based on historical trends, predict participant registration for Tokyo Marathon 2026`

**If it works:**
- "Intelligence projects 35,000 registrations"
- "Helps with logistics planning"

**If it doesn't work:**
- "This is a stretch goal—predictive analytics"
- "Not all questions have enough data yet"
- "But you can see the potential"

---

### Scenario 4: Media Reach & Fan Sentiment (10 min)

#### Query 13: Highest Viewership

**Type:** `Which marathon delivered the highest total broadcast viewership in 2025?`

**When results appear:**

1. **Call out the winner:**
   - "Chicago drew 9.8M viewers—most-watched broadcast."
   - "Use this to justify premium sponsorship slots."

2. **Highlight data lineage:**
   - "Numbers come from `FCT_BROADCAST_REACH`, fed by raw broadcast metrics."

#### Query 14: Sentiment vs Viewership

**Type:** `Compare fan sentiment and total viewership for each marathon this year`

**When results appear:**

1. **Cross-insight storytelling:**
   - "London tops sentiment (0.72) and sits third in viewership."
   - "Berlin has strong sentiment but lower reach—opportunity to expand broadcast partners."

2. **Tie back to sponsors:**
   - "Shows where fans are happiest and where eyeballs are highest."

#### Query 15: Platform Effectiveness

**Type:** `What is the top social platform by engagement for each marathon?`

**When results appear:**

1. **Use `top_platform_by_engagement`:**
   - "Boston: Instagram leads engagement."
   - "Tokyo: Twitter dominates due to time zone."

2. **Actionable takeaway:**
   - "Helps marketing teams prioritize platform-specific creative."

---

### Transparency Demo (5 min)

#### Show SQL Generation

1. **Go back to Query 1 (sentiment across marathons)**
2. **Click 'View SQL' button**
3. **Scroll through the query slowly**

**Point out:**
- Table names (RAW_INGESTION.SOCIAL_MEDIA_POSTS, RAW_INGESTION.MARATHONS)
- JOIN conditions
- WHERE clause (year = 2025)
- AVG() aggregation
- GROUP BY marathon_name

**Say:** "This is production-quality SQL. A data engineer wrote this in their head, and Intelligence generated it in 3 seconds."

#### Show Verification Shield

1. **Point to green shield icon**
2. **Click it to see details**

**Explain:**
- Green = High confidence (direct data match)
- Yellow = Medium confidence (some interpretation)
- Red = Low confidence (verify manually)

**Say:** "You can trust green-shielded answers for decisions. Yellow/red answers should be reviewed by a human."

---

### Q&A Handling (5 min)

Use the objection handling section from `docs/02-DEMO-SCRIPT.md`

#### Common Questions:

**Q: What if it gets something wrong?**
- A: Show SQL, verify manually, add to Verified Queries for future

**Q: Does data leave Snowflake?**
- A: No—100% inside your secure account

**Q: Setup time?**
- A: 2-4 weeks for initial semantic view

**Q: Integration with existing tools?**
- A: REST API—embed in Teams, Slack, custom apps

---

### Closing & Next Steps (5 min)

**Action:** Stop sharing screen (or show closing slide)

**Say:** Follow closing from demo script

**Key points:**
- POC in 2-3 weeks
- Expand over 4-6 weeks
- Roll out to business users

**Propose:** Schedule follow-up meeting with data team

**Thank the audience**

---

## Troubleshooting During Demo

### Issue: Intelligence Query Fails

**Symptoms:**
- Error message
- "I don't have enough information"
- No results returned

**Recovery:**

**Option 1:** Rephrase the question
- Simplify: Instead of "Compare X vs Y," try "Show me X" then "Show me Y"
- Be more specific: Add year, marathon name

**Option 2:** Use a backup question
- Have `docs/04-SAMPLE-QUESTIONS.md` open
- Pick a similar question that you've tested

**Option 3:** Show SQL directly
- Say: "Let me show you the underlying data using SQL"
- Open Snowsight SQL editor
- Run a query from your verified SQL notebook (or adapt one of the sample questions from `docs/04-SAMPLE-QUESTIONS.md`)
- Say: "If Intelligence ever hesitates, we can always query directly"

### Issue: Intelligence is Slow (>10 seconds)

**Recovery:**
- Don't panic—keep talking
- Say: "Intelligence is analyzing all 50,000 runners and 300,000 race results"
- Explain: "First query might take longer—subsequent queries use cache"
- If it takes >30 seconds: Cancel and try a simpler question

### Issue: Results Look Wrong

**Recovery:**
1. **Don't say "that's wrong"** (audience won't know unless you tell them)
2. **Click View SQL** to diagnose
3. **Say:** "Let me verify this result by checking the SQL"
4. **If wrong:** "Interesting—Intelligence interpreted this differently than I expected. Let me rephrase."
5. **Add to Verified Queries** after the demo to improve accuracy

### Issue: Screen Share Fails

**Recovery:**
- Have a backup laptop with the same demo ready
- Or: Continue without screen share, talk through the concept
- Or: Reschedule if critical

---

## Post-Demo Checklist

After the demo concludes:

- [ ] Capture questions you couldn't answer (follow up later)
- [ ] Note which queries failed or gave poor results
- [ ] Update Verified Queries if needed
- [ ] Send follow-up email with:
  - Summary of what was shown
  - Link to schedule follow-up
  - Any resources mentioned
- [ ] Clean up demo environment if needed (or leave for customer testing)

---

## Tips for Success

### 1. Practice the Demo 3 Times

Run through the entire script at least 3 times before going live:
- First time: Learn the flow
- Second time: Test all queries
- Third time: Simulate audience questions

### 2. Know Your Escape Routes

Always have a backup plan:
- If Intelligence fails → Show SQL directly
- If SQL fails → Show the semantic view definition
- If everything fails → Talk through the architecture (use diagrams)

### 3. Pace Yourself

- Don't rush through results—let the audience absorb
- Pause after each query for questions
- If you finish early, use backup questions
- If you're running late, skip Query 12 (predictive)

### 4. Engage the Audience

- Ask questions: "Does this sound familiar?"
- Invite them to suggest queries: "What would you want to ask?"
- React to their responses: "That's a great question—let's try it"

### 5. Stay Calm if Things Break

- Remember: They don't know what you planned to show
- If a query fails, pivot smoothly
- Acknowledge: "That's the nature of live demos—always have a backup"
- Show alternatives: "But here's what we can do..."

---

**Good luck with your demo!**

For questions or additional support, refer to:
- `docs/02-DEMO-SCRIPT.md` - Complete presenter talking points
- `docs/04-SAMPLE-QUESTIONS.md` - 30+ tested queries
- `docs/05-TECHNICAL-REFERENCE.md` - Architecture details

