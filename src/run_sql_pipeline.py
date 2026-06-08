from pathlib import Path

import duckdb


DB_PATH = "scholarship_rd.duckdb"
SQL_DIR = Path("sql")

SQL_FILES = [
    "01_load_raw_data.sql",
    "02_clean_students.sql",
    "03_clean_scores.sql",
    "04_clean_scholarships.sql",
    "05_clean_enrollment.sql",
    "06_build_rd_panel.sql",
    "07_validation_checks.sql",
    "08_export_regression_ready.sql",
]


def run_sql_file(con: duckdb.DuckDBPyConnection, filename: str) -> None:
    path = SQL_DIR / filename
    print(f"Running {path}...")
    sql = path.read_text(encoding="utf-8")
    con.execute(sql)


def main() -> None:
    con = duckdb.connect(DB_PATH)

    for filename in SQL_FILES:
        run_sql_file(con, filename)

    con.close()
    print("SQL pipeline completed.")


if __name__ == "__main__":
    main()