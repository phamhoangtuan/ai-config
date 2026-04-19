---
name: warehouse-analysis
description: End-to-end warehouse exploration workflow combining schema discovery, SQL analysis, table profiling, and freshness checks for data engineering tasks.
---

# Warehouse Analysis

Use this skill for warehouse-first investigation work and data quality checks.

## Trigger

Use this skill when:
- You need to discover tables, schemas, or columns before writing SQL
- You are answering business questions from warehouse data
- You need profile metrics (null rates, distributions, cardinality)
- You need to verify data freshness before trusting downstream outputs

Do not use this skill when:
- The request is about DAG authoring or Airflow runtime behavior
- The request is about dbt model authoring, tests, or dbt execution
- The request is primarily lineage impact analysis (use lineage-ops)

## Workflow

1. Initialize warehouse context
   - Confirm connection and accessible databases/schemas
   - Build or refresh a compact schema inventory for fast lookup
2. Analyze with SQL
   - Translate the question into explicit SQL with stated assumptions
   - Run scoped queries first, then expand when needed
3. Profile target tables
   - Check row counts, null rates, distinct counts, outliers, and key uniqueness
   - Compare profile results against expected business behavior
4. Check freshness
   - Inspect ingestion/update timestamps and freshness windows
   - Flag stale datasets before presenting conclusions
5. Report and next actions
   - Summarize findings, confidence level, and identified data risks
   - Recommend follow-up checks or owner handoff if quality issues appear

## Output Contract

Return results with:
- Tables queried and filters used
- SQL assumptions and limitations
- Profile and freshness findings
- Confidence statement and recommended next steps

## Sources Merged

This skill consolidates scope from:
- warehouse-init
- analyzing-data
- profiling-tables
- checking-freshness