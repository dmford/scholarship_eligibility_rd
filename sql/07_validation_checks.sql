CREATE OR REPLACE TABLE validation_summary AS

SELECT
    'students_raw_rows' AS check_name,
    COUNT(*) AS check_value
FROM students_raw

UNION ALL

SELECT
    'students_clean_rows' AS check_name,
    COUNT(*) AS check_value
FROM students_clean

UNION ALL

SELECT
    'scores_raw_rows' AS check_name,
    COUNT(*) AS check_value
FROM scores_raw

UNION ALL

SELECT
    'scores_clean_rows' AS check_name,
    COUNT(*) AS check_value
FROM scores_clean

UNION ALL

SELECT
    'scholarships_raw_rows' AS check_name,
    COUNT(*) AS check_value
FROM scholarships_raw

UNION ALL

SELECT
    'scholarships_clean_rows' AS check_name,
    COUNT(*) AS check_value
FROM scholarships_clean

UNION ALL

SELECT
    'enrollment_raw_rows' AS check_name,
    COUNT(*) AS check_value
FROM enrollment_raw

UNION ALL

SELECT
    'enrollment_clean_rows' AS check_name,
    COUNT(*) AS check_value
FROM enrollment_clean

UNION ALL

SELECT
    'rd_analysis_panel_rows' AS check_name,
    COUNT(*) AS check_value
FROM rd_analysis_panel

UNION ALL

SELECT
    'duplicate_student_ids_in_panel' AS check_name,
    COUNT(*) AS check_value
FROM (
    SELECT student_id
    FROM rd_analysis_panel
    GROUP BY student_id
    HAVING COUNT(*) > 1
)

UNION ALL

SELECT
    'missing_scores_in_panel' AS check_name,
    COUNT(*) AS check_value
FROM rd_analysis_panel
WHERE test_score IS NULL

UNION ALL

SELECT
    'missing_outcomes_in_panel' AS check_name,
    COUNT(*) AS check_value
FROM rd_analysis_panel
WHERE enrolled_college IS NULL

UNION ALL

SELECT
    'invalid_gpa_values_in_panel' AS check_name,
    COUNT(*) AS check_value
FROM rd_analysis_panel
WHERE first_year_gpa < 0
   OR first_year_gpa > 4

UNION ALL

SELECT
    'students_within_10_points_cutoff' AS check_name,
    COUNT(*) AS check_value
FROM rd_analysis_panel
WHERE rd_sample_10pt = 1

UNION ALL

SELECT
    'students_within_5_points_cutoff' AS check_name,
    COUNT(*) AS check_value
FROM rd_analysis_panel
WHERE rd_sample_5pt = 1;