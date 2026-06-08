CREATE OR REPLACE TABLE rd_analysis_panel AS
SELECT
    s.student_id,
    s.first_name_clean,
    s.last_name_clean,
    s.school_id,
    s.cohort_year,

    sc.test_date,
    sc.test_score,

    sc.test_score - 85 AS running_variable,

    CASE
        WHEN sc.test_score >= 85 THEN 1
        ELSE 0
    END AS eligible,

    COALESCE(sh.received_scholarship, 0) AS received_scholarship,
    sh.award_date,

    e.enrolled_college,
    e.enrollment_date,
    e.first_year_gpa,

    CASE
        WHEN ABS(sc.test_score - 85) <= 10 THEN 1
        ELSE 0
    END AS rd_sample_10pt,

    CASE
        WHEN ABS(sc.test_score - 85) <= 5 THEN 1
        ELSE 0
    END AS rd_sample_5pt

FROM students_clean AS s
INNER JOIN scores_clean AS sc
    ON s.student_id = sc.student_id
LEFT JOIN scholarships_clean AS sh
    ON s.student_id = sh.student_id
LEFT JOIN enrollment_clean AS e
    ON s.student_id = e.student_id

WHERE sc.test_score IS NOT NULL
  AND e.enrolled_college IS NOT NULL;