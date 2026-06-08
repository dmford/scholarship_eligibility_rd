CREATE OR REPLACE TABLE students_clean AS
WITH standardized AS (
    SELECT
        TRY_CAST(student_id AS INTEGER) AS student_id,
        CONCAT(
            UPPER(SUBSTR(TRIM(first_name), 1, 1)),
            LOWER(SUBSTR(TRIM(first_name), 2))
        ) AS first_name_clean,
        CONCAT(
            UPPER(SUBSTR(TRIM(last_name), 1, 1)),
            LOWER(SUBSTR(TRIM(last_name), 2))
        ) AS last_name_clean,
        UPPER(TRIM(school_id)) AS school_id_clean,
        TRY_CAST(cohort_year AS INTEGER) AS cohort_year
    FROM students_raw
),

valid_students AS (
    SELECT
        student_id,
        first_name_clean,
        last_name_clean,
        school_id_clean,
        cohort_year,
        ROW_NUMBER() OVER (
            PARTITION BY student_id
            ORDER BY
                CASE WHEN school_id_clean IS NOT NULL THEN 0 ELSE 1 END,
                cohort_year
        ) AS rn
    FROM standardized
    WHERE student_id IS NOT NULL
      AND cohort_year BETWEEN 2021 AND 2023
)

SELECT
    student_id,
    first_name_clean,
    last_name_clean,
    COALESCE(school_id_clean, 'UNKNOWN') AS school_id,
    cohort_year
FROM valid_students
WHERE rn = 1;