CREATE OR REPLACE TABLE enrollment_clean AS
WITH standardized AS (
    SELECT
        TRY_CAST(student_id AS INTEGER) AS student_id,
        CASE
            WHEN UPPER(TRIM(enrolled_college)) IN ('YES', 'Y', '1', 'TRUE') THEN 1
            WHEN UPPER(TRIM(enrolled_college)) IN ('NO', 'N', '0', 'FALSE') THEN 0
            ELSE NULL
        END AS enrolled_college,
        TRY_CAST(enrollment_date AS DATE) AS enrollment_date,
        TRY_CAST(first_year_gpa AS DOUBLE) AS first_year_gpa
    FROM enrollment_raw
),

valid_enrollment AS (
    SELECT
        student_id,
        enrolled_college,
        enrollment_date,
        CASE
            WHEN first_year_gpa BETWEEN 0 AND 4 THEN first_year_gpa
            ELSE NULL
        END AS first_year_gpa
    FROM standardized
    WHERE student_id IS NOT NULL
      AND enrolled_college IS NOT NULL
),

ranked_enrollment AS (
    SELECT
        student_id,
        enrolled_college,
        enrollment_date,
        first_year_gpa,
        ROW_NUMBER() OVER (
            PARTITION BY student_id
            ORDER BY
                enrolled_college DESC,
                enrollment_date DESC NULLS LAST
        ) AS rn
    FROM valid_enrollment
)

SELECT
    student_id,
    enrolled_college,
    enrollment_date,
    first_year_gpa
FROM ranked_enrollment
WHERE rn = 1;