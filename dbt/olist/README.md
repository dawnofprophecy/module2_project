# Olist dbt Project (Complete)

This is a ready-to-run dbt project for Olist on BigQuery.

## Quickstart
1) Create `~/.dbt/profiles.yml` with a profile named `olist_bigquery`:
```yaml
olist_bigquery:
  target: prod
  outputs:
    prod:
      type: bigquery
      method: oauth
      project: olist-Project-470402
      dataset: olist_silver
      location: US
      threads: 4
      priority: interactive
```
2) From this folder:
```bash
dbt deps
dbt build
dbt docs generate && dbt docs serve
```
