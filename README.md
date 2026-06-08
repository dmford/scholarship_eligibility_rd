# Scholarship Eligibility RD

## Overview

This project demonstrates a complete workflow for preparing and analyzing data for a regression discontinuity (RD) design.

The project uses intentionally messy synthetic education data to simulate a realistic analyst workflow. Multiple raw datasets contain duplicate records, inconsistent formatting, missing values, and other common data quality issues. SQL is used to clean, validate, and merge these sources into a regression-ready analysis dataset.

The eventual empirical question is:

> Does becoming eligible for a scholarship increase college enrollment?

Scholarship eligibility is determined by a test-score cutoff, creating a natural setting for a future regression discontinuity analysis.

## Current Status

The current phase focuses on data engineering and SQL.

Completed and planned tasks include:

* Generate realistic synthetic education datasets
* Load raw data into DuckDB
* Clean and standardize records using SQL
* Validate joins and identify data quality issues
* Construct an analysis-ready student panel
* Create RD running variables and treatment indicators

Future phases will add:

* Regression discontinuity estimation
* RD diagnostic plots
* Bandwidth sensitivity analysis
* Robustness checks
* Visualization and reporting

## Project Structure

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

outputs/
├── figures/
├── tables/
└── logs/
```

## Intended Analysis

The future RD design will use:

* Running Variable: Test score
* Cutoff: Scholarship eligibility threshold
* Treatment: Scholarship eligibility
* Outcome: College enrollment

The goal is to estimate the causal effect of scholarship eligibility on educational outcomes for students near the eligibility threshold.
