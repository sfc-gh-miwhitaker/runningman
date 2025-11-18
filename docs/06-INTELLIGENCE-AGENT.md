# 06 - INTELLIGENCE-AGENT

## Purpose

Document how the Marathon Analytics Snowflake Intelligence agent is provisioned, how to verify it, and how to safely customize the specification (instructions, tools, orchestration models) while preserving best practices.

---

## 1. Auto-Provisioned Agent

- **Name:** `SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT`
- **Display Name:** `Marathon Analytics`
- **Created By:** `sql/05_agent_setup/01_create_agent.sql` (invoked from `sql/00_deploy_all.sql`)
- **Tooling:** Single Cortex Analyst tool (`AnalystMarathon`) pinned to semantic view `SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS`
- **Execution Environment:** Warehouse `SFE_MARATHON_WH`, 60-second timeout
- **Visibility:** Added automatically to `SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT`
- **Access:** `USAGE` granted to `SFE_MARATHON_ROLE`

Deployment script steps:

```sql
-- Creates / replaces the agent from YAML specification
CREATE OR REPLACE AGENT MARATHON_AGENT ... FROM SPECIFICATION $$ ... $$;

-- Ensures the Snowflake Intelligence curated list exists
CREATE SNOWFLAKE INTELLIGENCE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;

-- Adds the agent (idempotent drop + add)
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
  ADD AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT;

-- Grants usage to demo role
GRANT USAGE ON AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT TO ROLE SFE_MARATHON_ROLE;
```

---

## 2. Verification Checklist

Run after `sql/00_deploy_all.sql` completes:

```sql
SHOW AGENTS LIKE 'MARATHON_AGENT';

-- Should return one row with Schema = ANALYTICS

DESCRIBE AGENT SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_AGENT;

SHOW SNOWFLAKE INTELLIGENCES;
DESCRIBE SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;

-- Confirm agent listed under curated_agents array
```

In Snowsight:
1. Go to **AI & ML → Snowflake Intelligence**
2. The **Marathon Analytics** agent is ready in the curated list
3. Click the agent and run a quick question (e.g., “How many marathons are in the system?”)

---

## 3. Customize the Agent

Every customization should modify the YAML in `sql/05_agent_setup/01_create_agent.sql`, then re-run `sql/00_deploy_all.sql`.

### 3.1 Instructions

Inside the specification:

```yaml
instructions:
  response: "tone and style"
  orchestration: "routing guidance"
  system: "global mission"
  sample_questions:
    - question: "..."
      answer: "..."
```

Best practices:
- Keep response instructions concise; highlight KPIs and next actions
- Use orchestration instructions to route between tools (Analyst vs future Search)
- Provide 3-5 sample Q&A pairs reflecting core demo flows

### 3.2 Models & Budgets

- `models.orchestration`: Default `claude-4-sonnet`; swap if account has different model allowlist
- `orchestration.budget.seconds` & `.tokens`: Bound runtime and LLM tokens per request

### 3.3 Tools

Current tool list:

```yaml
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: AnalystMarathon
      description: Natural language to SQL for marathon analytics
```

To add more semantic views, append additional tool_specs and map them in `tool_resources`.

### 3.4 Tool Resources

```yaml
tool_resources:
  AnalystMarathon:
    semantic_view: SNOWFLAKE_EXAMPLE.ANALYTICS.MARATHON_INSIGHTS
    execution_environment:
      type: warehouse
      warehouse: SFE_MARATHON_WH
      query_timeout: 60
```

- `semantic_view`: Must reference a `CREATE SEMANTIC VIEW` object
- `execution_environment`: Supports `query_timeout` plus `warehouse`
- Add additional keys (e.g., `sample_questions_file`, `semantic_model_file`) if using staged YAML models

---

## 4. Publishing Workflow

1. Edit YAML specification in `sql/05_agent_setup/01_create_agent.sql`
2. Run `sql/00_deploy_all.sql` (or the single agent file) in Snowsight
3. Verify agent via `DESCRIBE AGENT` or Snowsight UI
4. Update curated list (handled automatically by script)
5. Re-run demo walkthrough validation queries

---

## 5. Troubleshooting

| Issue | Resolution |
|-------|------------|
| `SQL access control error: Insufficient privileges to create agent` | Ensure role has `CREATE AGENT` on `SNOWFLAKE_EXAMPLE.ANALYTICS` |
| `Agent already exists in curated list` | Script drops before add; if manual, run `ALTER ... DROP AGENT ...` |
| Agent not visible in Snowsight | Confirm `SHOW SNOWFLAKE INTELLIGENCES` returns curated object and agent |
| Agent missing semantic view | Run `DESCRIBE AGENT ...` and ensure `tool_resources.AnalystMarathon.semantic_view` is populated |

---

## 6. Related Artifacts

- `sql/05_agent_setup/01_create_agent.sql`
- `sql/04_semantic_layer/01_create_semantic_view.sql`
- `docs/03-DEMO-WALKTHROUGH.md` (agent verification steps)
- `docs/04-SAMPLE-QUESTIONS.md` (queries referenced in sample Q&A)

