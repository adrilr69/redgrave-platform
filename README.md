# redgrave-platform

AFC Redgrave data platform (Albert School · Data Engineering & Cloud Infrastructure).

| Folder / file | Lab | Content |
| --- | --- | --- |
| `redgrave_dbt/` | RED-201 · dbt | Medallion pipeline on Snowflake: `BRONZE` (sources) → `SILVER` (views) → `GOLD` (tables) |
| `submit_answers_dbt.sql` | RED-201 · dbt | Answers to the 5 lab questions |

Next labs (Docker, Airflow, Terraform) will be added as new folders here.

## Run the dbt project

```powershell
cd redgrave_dbt
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install dbt-core==1.11.16 dbt-snowflake==1.11.6

$env:SNOWFLAKE_ACCOUNT="ORGNAME-ACCOUNTNAME"
$env:SNOWFLAKE_USER="YOUR_USER"
$env:SNOWFLAKE_PRIVATE_KEY_FILE="C:\full\path\to\rsa_key.p8"
$env:DBT_PROFILES_DIR="."

dbt debug               # All checks passed!
dbt build               # PASS=24 (6 models + 17 tests + results hook)
dbt source freshness    # WARN if bronze was loaded more than 24 h ago
dbt docs generate; dbt docs serve
```

No secret is stored in this repository: `profiles.yml` only reads environment variables and `*.p8` keys are git-ignored.

## Models

```
bronze.products ─────► silver_products ─┐
bronze.orders ───────► silver_orders ───┼─► silver_order_lines ─► gold_revenue_by_channel
bronze.order_items ─────────────────────┘                      ├─► gold_daily_sales
                                                               └─► gold_top_products
```

Expected results: `gold_revenue_by_channel` = 21,436 GBP over 3 channels (76 paid orders each), `gold_daily_sales` = 30 days.
