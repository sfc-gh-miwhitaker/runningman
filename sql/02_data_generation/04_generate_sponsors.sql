/*******************************************************************************
 * DEMO: Generate Sponsor Data and Contracts
 ******************************************************************************/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SFE_MARATHON_WH;
USE DATABASE SNOWFLAKE_EXAMPLE;
USE SCHEMA RAW_INGESTION;

CREATE OR REPLACE TABLE SPONSORS (
    sponsor_id INTEGER PRIMARY KEY,
    sponsor_name VARCHAR(100),
    industry VARCHAR(50),
    sponsorship_tier VARCHAR(20)
) COMMENT = 'DEMO: Marathon sponsors';

INSERT INTO SPONSORS VALUES
  (1, 'Global Healthcare Co', 'Healthcare', 'Platinum'),
  (2, 'Gatorade', 'Sports Drinks', 'Gold'),
  (3, 'Asics', 'Athletic Apparel', 'Gold'),
  (4, 'Nike', 'Athletic Apparel', 'Platinum'),
  (5, 'Adidas', 'Athletic Apparel', 'Gold'),
  (6, 'Bank of America', 'Financial Services', 'Gold'),
  (7, 'Toyota', 'Automotive', 'Silver'),
  (8, 'Coca-Cola', 'Beverages', 'Silver'),
  (9, 'Rolex', 'Luxury Watches', 'Silver'),
  (10, 'Mizuno', 'Athletic Apparel', 'Silver');

CREATE OR REPLACE TABLE SPONSOR_CONTRACTS (
    contract_id INTEGER PRIMARY KEY,
    sponsor_id INTEGER,
    marathon_id INTEGER,
    contract_year INTEGER,
    contract_value DECIMAL(12,2),
    activation_spend DECIMAL(12,2),
    media_exposure_minutes INTEGER
) COMMENT = 'DEMO: Sponsor contracts and ROI data';

INSERT INTO SPONSOR_CONTRACTS
SELECT
    ROW_NUMBER() OVER (ORDER BY s.sponsor_id, m.marathon_id, y.year) AS contract_id,
    s.sponsor_id,
    m.marathon_id,
    y.year AS contract_year,
    CASE s.sponsorship_tier
        WHEN 'Platinum' THEN UNIFORM(2000000, 5000000, RANDOM(s.sponsor_id * 100))
        WHEN 'Gold' THEN UNIFORM(500000, 2000000, RANDOM(s.sponsor_id * 200))
        ELSE UNIFORM(100000, 500000, RANDOM(s.sponsor_id * 300))
    END AS contract_value,
    CASE s.sponsorship_tier
        WHEN 'Platinum' THEN UNIFORM(500000, 1500000, RANDOM(s.sponsor_id * 400))
        WHEN 'Gold' THEN UNIFORM(100000, 500000, RANDOM(s.sponsor_id * 500))
        ELSE UNIFORM(20000, 100000, RANDOM(s.sponsor_id * 600))
    END AS activation_spend,
    CASE s.sponsorship_tier
        WHEN 'Platinum' THEN UNIFORM(180, 300, RANDOM(s.sponsor_id * 700))
        WHEN 'Gold' THEN UNIFORM(60, 180, RANDOM(s.sponsor_id * 800))
        ELSE UNIFORM(15, 60, RANDOM(s.sponsor_id * 900))
    END AS media_exposure_minutes
FROM SPONSORS s
CROSS JOIN MARATHONS m
CROSS JOIN (SELECT 2023 AS year UNION ALL SELECT 2024 UNION ALL SELECT 2025) y
WHERE UNIFORM(1, 100, RANDOM(s.sponsor_id * m.marathon_id)) > 50; -- Not all sponsors at all marathons

/*******************************************************************************
 * END OF SCRIPT
 ******************************************************************************/

