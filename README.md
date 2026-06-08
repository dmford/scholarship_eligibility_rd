# Scholarship Eligibility RD

This project uses intentionally messy synthetic education data to demonstrate a complete SQL-based data cleaning workflow for a future regression discontinuity (RD) analysis of scholarship eligibility.

The repository simulates a realistic analyst workflow in which multiple raw datasets contain duplicate records, inconsistent formatting, missing values, invalid values, and conflicting information. SQL is used to clean, validate, standardize, and merge these datasets into a regression-ready analysis panel.

The eventual empirical question is:

> Does scholarship eligibility increase college enrollment?

Scholarship eligibility is determined by a test-score cutoff, creating a natural setting for regression discontinuity analysis.

The primary purpose of the current phase is to demonstrate practical SQL skills, including data cleaning, validation, joins, feature engineering, and construction of an analysis-ready dataset.

## Project Goal

The objective is to build a reproducible SQL pipeline that transforms intentionally messy educational records into a clean dataset suitable for causal inference.

Rather than beginning with a pre-cleaned analytical dataset, the project emphasizes the intermediate work commonly required in analyst and data-science roles:

* Data ingestion
* Data cleaning
* Deduplication
* Data validation
* Record linkage
* Feature engineering
* Construction of regression-ready datasets

The long-term goal is to extend the project into a full regression discontinuity analysis examining the effect of scholarship eligibility and scholarship receipt on college enrollment outcomes.

## Data Generating Process

The repository uses synthetic education data generated specifically for this project.

The synthetic datasets are intentionally constructed with realistic data-quality issues, including:

* Duplicate student records
* Missing values
* Invalid dates
* Impossible test scores
* Inconsistent capitalization
* Conflicting administrative records
* Formatting inconsistencies

The future RD design will use:

* Running variable: Test score
* Cutoff: Scholarship eligibility threshold
* Eligibility indicator: Whether a student scored at or above the cutoff
* Treatment: Scholarship receipt
* Outcome: College enrollment

The data-generating process is designed to support both sharp and fuzzy RD specifications.

## SQL Workflow

The SQL pipeline is designed to demonstrate common analyst workflows and interview-relevant SQL concepts.

Representative tasks include:

* Loading raw data into DuckDB
* Standardizing records
* Deduplicating observations
* Handling missing values
* Constructing analytical variables
* Joining multiple source tables
* Running validation checks
* Exporting a regression-ready panel

Representative SQL concepts include:

* `CASE WHEN`
* `COALESCE`
* `TRY_CAST`
* `TRIM`
* `UPPER`
* `LOWER`
* `GROUP BY`
* `HAVING`
* `LEFT JOIN`
* `ROW_NUMBER`
* `PARTITION BY`

## Repository Structure

```text
data/
├── raw/
└── processed/

sql/
├── 01_load_raw_data.sql
├── 02_clean_students.sql
├── 03_clean_scores.sql
├── 04_clean_scholarships.sql
├── 05_build_rd_panel.sql
├── 06_validation_checks.sql
└── 07_export_regression_ready.sql

src/
├── generate_synthetic_data.py
└── run_sql_pipeline.py

notebooks/

outputs/
├── figures/
├── logs/
└── tables/
```

## Outputs

The SQL pipeline will generate:

* Cleaned student records
* Cleaned test-score records
* Cleaned scholarship records
* Cleaned enrollment records
* Validation reports
* A regression-ready RD analysis panel

The final analytical dataset will contain the variables required for future sharp and fuzzy regression discontinuity estimation.

## Future Extensions

Potential future extensions include:

* Sharp RD estimation
* Fuzzy RD estimation
* RD diagnostic plots
* Density tests around the cutoff
* Covariate balance checks
* Bandwidth sensitivity analysis
* Robustness checks
* Visualization and reporting

## Author

David Ford

This project was developed by David Ford with AI-assisted coding support from ChatGPT for project planning, SQL workflow design, synthetic data generation concepts, debugging, documentation, implementation support, and code review. Project design, implementation decisions, validation procedures, interpretation, and final repository contents were reviewed and approved by the author.
