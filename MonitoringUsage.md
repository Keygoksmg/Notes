
- The query to calculate storage for each dataset
```
SELECT
  -- COALESCE is used to display 'Total' for the grand total row
  -- Default: You are charged based on the logical bytes (uncompressed size) of your data
  COALESCE(table_schema, '--- Project Total ---') AS schema_name,
  SUM(active_logical_bytes) / POW(1024, 4) AS active_logical_tb,
  SUM(long_term_logical_bytes) / POW(1024, 4) AS long_term_logical_tb,
  SUM(active_logical_bytes + long_term_logical_bytes) / POW(1024, 4) AS total_logical_tb,

  -- Estimated Cost Calculation
  -- Define rates (example rates for US multi-region logical storage)
  -- Active: $20.00 per TB-month
  -- Long-Term: $10.00 per TB-month
  (SUM(active_logical_bytes) / POW(1024, 4) * 20.00) +
  (SUM(long_term_logical_bytes) / POW(1024, 4) * 10.00) AS estimated_monthly_cost_usd

FROM
  `science-of-science`.`region-us`.INFORMATION_SCHEMA.TABLE_STORAGE
GROUP BY
  ROLLUP(table_schema)
ORDER BY
  CASE WHEN table_schema IS NULL THEN 1 ELSE 0 END,
  total_logical_tb DESC;
```


- The query to calculate query usage per user for the last 30 days
```
SELECT
  user_email,
  SUM(total_bytes_processed) / POW(1024, 4)AS Total_TB_Processed,
  -- TB to Dollar
  SUM(total_bytes_processed) / POW(1024, 4) * 6.25 AS Charges_Dollar -- Using POW(1024, 4) for clarity
FROM
  `science-of-science`.`region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE
  DATE(creation_time) BETWEEN DATE_ADD(CURRENT_DATE('America/New_York'), INTERVAL -30 DAY ) AND CURRENT_DATE('America/New_York') -- Timezone changed to 'America/New_York'
GROUP BY 1
ORDER BY 2 DESC
```