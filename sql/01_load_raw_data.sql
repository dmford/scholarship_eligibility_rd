CREATE OR REPLACE TABLE students_raw AS
SELECT *
FROM read_csv_auto('data/raw/students_raw.csv', header = true);

CREATE OR REPLACE TABLE scores_raw AS
SELECT *
FROM read_csv_auto('data/raw/scores_raw.csv', header = true);

CREATE OR REPLACE TABLE scholarships_raw AS
SELECT *
FROM read_csv_auto('data/raw/scholarships_raw.csv', header = true);

CREATE OR REPLACE TABLE enrollment_raw AS
SELECT *
FROM read_csv_auto('data/raw/enrollment_raw.csv', header = true);