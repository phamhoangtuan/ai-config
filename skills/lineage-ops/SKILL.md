---
name: lineage-ops
description: Unified lineage operations for upstream/downstream impact analysis, task lineage annotation, and OpenLineage extractor guidance.
---

# Lineage Ops

Use this skill for impact analysis and lineage completeness work.

## Trigger

Use this skill when:
- You need to know what breaks if a table, model, or task changes
- You need to trace where a dataset, metric, or field originates
- You need to add or correct manual lineage metadata in orchestrated tasks
- You need to design custom OpenLineage extractors for unsupported operators

Do not use this skill when:
- The request is only warehouse querying without dependency analysis
- The request is only DAG code implementation without lineage requirements

## Workflow

1. Define lineage target
   - Identify starting object (table/model/task/column)
   - Confirm environment and source of truth for metadata
2. Trace upstream
   - Walk producers and transformations that feed the target
   - Identify quality, freshness, and ownership dependencies
3. Trace downstream
   - Enumerate dependent dashboards, models, jobs, and APIs
   - Classify break risk by severity and blast radius
4. Annotate or extract lineage
   - Add inlets/outlets metadata where manual lineage is required
   - Specify extractor behavior for custom operators when automation is missing
5. Produce change-safe plan
   - Recommend migration order, guardrails, and rollback points
   - Include validation checks for each impacted critical path

## Output Contract

Return results with:
- Upstream and downstream dependency maps
- High-risk impacts and owner-facing remediation steps
- Required lineage annotations or extractor updates
- Validation plan before change rollout

## Sources Merged

This skill consolidates scope from:
- tracing-upstream-lineage
- tracing-downstream-lineage
- annotating-task-lineage
- creating-openlineage-extractors