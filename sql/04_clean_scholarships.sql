CREATE OR REPLACE TABLE scholarships_clean AS
WITH standardized AS (
    SELECT
        TRY_CAST(student_id AS INTEGER) AS student_id,
        scholarship_awarded AS scholarship_awarded_raw,
        CASE
            WHEN UPPER(TRIM(scholarship_awarded)) IN ('YES', 'Y', '1', 'TRUE') THEN 1
            WHEN UPPER(TRIM(scholarship_awarded)) IN ('NO', 'N', '0', 'FALSE') THEN 0
            ELSE NULL
        END AS received_scholarship,
        TRY_CAST(award_date AS DATE) AS award_date
    FROM scholarships_raw
),

valid_scholarships AS (
    SELECT
        student_id,
        scholarship_awarded_raw,
        received_scholarship,
        award_date
    FROM standardized
    WHERE student_id IS NOT NULL
      AND received_scholarship IS NOT NULL
),

ranked_scholarships AS (
    SELECT
        student_id,
        scholarship_awarded_raw,
        received_scholarship,
        award_date,
        ROW_NUMBER() OVER (
            PARTITION BY student_id
            ORDER BY
                received_scholarship DESC,
                award_date DESC NULLS LAST
        ) AS rn
    FROM valid_scholarships
)

SELECT
    student_id,
    scholarship_awarded_raw,
    received_scholarship,
    award_date
FROM ranked_scholarships
WHERE rn = 1;