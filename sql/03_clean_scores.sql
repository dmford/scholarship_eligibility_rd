CREATE OR REPLACE TABLE scores_clean AS
WITH standardized AS (
    SELECT
        TRY_CAST(student_id AS INTEGER) AS student_id,
        TRY_CAST(test_date AS DATE) AS test_date,
        TRY_CAST(test_score AS DOUBLE) AS test_score
    FROM scores_raw
),

valid_scores AS (
    SELECT
        student_id,
        test_date,
        test_score
    FROM standardized
    WHERE student_id IS NOT NULL
      AND test_date IS NOT NULL
      AND test_score BETWEEN 0 AND 100
),

ranked_scores AS (
    SELECT
        student_id,
        test_date,
        test_score,
        ROW_NUMBER() OVER (
            PARTITION BY student_id
            ORDER BY test_score DESC, test_date DESC
        ) AS rn
    FROM valid_scores
)

SELECT
    student_id,
    test_date,
    test_score
FROM ranked_scores
WHERE rn = 1;