from pathlib import Path

import numpy as np
import pandas as pd


RAW_DIR = Path("data/raw")
RAW_DIR.mkdir(parents=True, exist_ok=True)

SEED = 20260608
N_STUDENTS = 2000
CUTOFF = 85


def main() -> None:
    rng = np.random.default_rng(SEED)

    student_id = np.arange(100001, 100001 + N_STUDENTS)
    cohort_year = rng.choice([2021, 2022, 2023], size=N_STUDENTS, p=[0.30, 0.35, 0.35])
    school_id = rng.choice(["SCH001", "SCH002", "SCH003", "SCH004", "SCH005"], size=N_STUDENTS)

    first_names = rng.choice(
        ["James", "Maria", "David", "Ashley", "Michael", "Sarah", "Daniel", "Emily", "Chris", "Taylor"],
        size=N_STUDENTS,
    )
    last_names = rng.choice(
        ["Smith", "Johnson", "Brown", "Garcia", "Miller", "Davis", "Wilson", "Moore", "Taylor", "Anderson"],
        size=N_STUDENTS,
    )

    ability = rng.normal(0, 1, size=N_STUDENTS)
    score = np.clip(np.round(78 + 9 * ability + rng.normal(0, 5, size=N_STUDENTS), 1), 40, 100)
    eligible = score >= CUTOFF

    # Fuzzy RD: eligibility strongly increases scholarship receipt, but not perfectly.
    scholarship_prob = np.where(eligible, 0.82, 0.10)
    received_scholarship = rng.binomial(1, scholarship_prob)

    # Smooth baseline relationship plus a scholarship treatment effect.
    enrollment_latent = -0.8 + 0.035 * (score - 75) + 0.55 * received_scholarship + rng.normal(0, 0.5, size=N_STUDENTS)
    enrollment_prob = 1 / (1 + np.exp(-enrollment_latent))
    enrolled_college = rng.binomial(1, enrollment_prob)

    first_year_gpa = np.where(
        enrolled_college == 1,
        np.clip(2.3 + 0.025 * (score - 75) + 0.15 * received_scholarship + rng.normal(0, 0.45, size=N_STUDENTS), 0, 4),
        np.nan,
    )

    # -------------------------
    # students_raw.csv
    # -------------------------
    students = pd.DataFrame(
        {
            "student_id": student_id,
            "first_name": first_names,
            "last_name": last_names,
            "school_id": school_id,
            "cohort_year": cohort_year,
        }
    )

    # Messiness: whitespace, casing, missing school IDs, impossible cohort year.
    messy_students = students.copy()
    messy_students.loc[rng.choice(N_STUDENTS, 80, replace=False), "first_name"] = (
        "  " + messy_students["first_name"].str.upper() + " "
    )
    messy_students.loc[rng.choice(N_STUDENTS, 80, replace=False), "last_name"] = (
        messy_students["last_name"].str.lower() + "  "
    )
    messy_students.loc[rng.choice(N_STUDENTS, 50, replace=False), "school_id"] = np.nan
    messy_students.loc[rng.choice(N_STUDENTS, 10, replace=False), "cohort_year"] = 2099

    duplicate_students = messy_students.sample(35, random_state=SEED).copy()
    messy_students = pd.concat([messy_students, duplicate_students], ignore_index=True)

    messy_students.to_csv(RAW_DIR / "students_raw.csv", index=False)

    # -------------------------
    # scores_raw.csv
    # -------------------------
    scores = pd.DataFrame(
        {
            "student_id": student_id,
            "test_date": pd.to_datetime(
                rng.choice(pd.date_range("2020-09-01", "2023-05-31"), size=N_STUDENTS)
            ),
            "test_score": score,
        }
    )

    # Messiness: duplicate attempts, missing scores, impossible scores, bad date strings.
    duplicate_scores = scores.sample(250, random_state=SEED + 1).copy()
    duplicate_scores["test_date"] = duplicate_scores["test_date"] + pd.to_timedelta(
        rng.integers(1, 90, size=len(duplicate_scores)), unit="D"
    )
    duplicate_scores["test_score"] = np.clip(
        duplicate_scores["test_score"] + rng.normal(0, 3, size=len(duplicate_scores)), 0, 105
    )

    messy_scores = pd.concat([scores, duplicate_scores], ignore_index=True)
    messy_scores.loc[rng.choice(len(messy_scores), 30, replace=False), "test_score"] = np.nan
    messy_scores.loc[rng.choice(len(messy_scores), 12, replace=False), "test_score"] = 140
    messy_scores.loc[rng.choice(len(messy_scores), 12, replace=False), "test_score"] = -5

    messy_scores["test_date"] = messy_scores["test_date"].dt.strftime("%Y-%m-%d")
    messy_scores.loc[rng.choice(len(messy_scores), 15, replace=False), "test_date"] = "not_a_date"

    messy_scores.to_csv(RAW_DIR / "scores_raw.csv", index=False)

    # -------------------------
    # scholarships_raw.csv
    # -------------------------
    scholarship_values = np.where(received_scholarship == 1, "Yes", "No")
    scholarships = pd.DataFrame(
        {
            "student_id": student_id,
            "scholarship_awarded": scholarship_values,
            "award_date": pd.to_datetime(
                rng.choice(pd.date_range("2021-01-01", "2023-08-31"), size=N_STUDENTS)
            ),
        }
    )

    # Messiness: inconsistent yes/no values, missing award dates, duplicates.
    messy_scholarships = scholarships.copy()
    yes_no_variants = {
        "Yes": ["YES", "yes", "Y", "1", "True"],
        "No": ["NO", "no", "N", "0", "False"],
    }

    for idx in rng.choice(N_STUDENTS, 300, replace=False):
        current = messy_scholarships.loc[idx, "scholarship_awarded"]
        messy_scholarships.loc[idx, "scholarship_awarded"] = rng.choice(yes_no_variants[current])

    messy_scholarships.loc[rng.choice(N_STUDENTS, 50, replace=False), "award_date"] = pd.NaT

    duplicate_scholarships = messy_scholarships.sample(60, random_state=SEED + 2).copy()
    messy_scholarships = pd.concat([messy_scholarships, duplicate_scholarships], ignore_index=True)

    messy_scholarships["award_date"] = pd.to_datetime(messy_scholarships["award_date"]).dt.strftime("%Y-%m-%d")
    messy_scholarships.to_csv(RAW_DIR / "scholarships_raw.csv", index=False)

    # -------------------------
    # enrollment_raw.csv
    # -------------------------
    enrollment = pd.DataFrame(
        {
            "student_id": student_id,
            "enrolled_college": np.where(enrolled_college == 1, "Yes", "No"),
            "enrollment_date": pd.to_datetime(
                rng.choice(pd.date_range("2021-08-01", "2024-09-01"), size=N_STUDENTS)
            ),
            "first_year_gpa": np.round(first_year_gpa, 2),
        }
    )

    # Messiness: inconsistent yes/no values, impossible GPAs, duplicate rows, missing dates.
    messy_enrollment = enrollment.copy()
    for idx in rng.choice(N_STUDENTS, 250, replace=False):
        current = messy_enrollment.loc[idx, "enrolled_college"]
        messy_enrollment.loc[idx, "enrolled_college"] = rng.choice(yes_no_variants[current])

    messy_enrollment.loc[rng.choice(N_STUDENTS, 20, replace=False), "first_year_gpa"] = 7.5
    messy_enrollment.loc[rng.choice(N_STUDENTS, 20, replace=False), "first_year_gpa"] = -1.0
    messy_enrollment.loc[rng.choice(N_STUDENTS, 40, replace=False), "enrollment_date"] = pd.NaT

    duplicate_enrollment = messy_enrollment.sample(75, random_state=SEED + 3).copy()
    messy_enrollment = pd.concat([messy_enrollment, duplicate_enrollment], ignore_index=True)

    messy_enrollment["enrollment_date"] = pd.to_datetime(messy_enrollment["enrollment_date"]).dt.strftime("%Y-%m-%d")
    messy_enrollment.to_csv(RAW_DIR / "enrollment_raw.csv", index=False)

    print("Synthetic raw datasets generated:")
    for file in sorted(RAW_DIR.glob("*.csv")):
        print(f" - {file}")


if __name__ == "__main__":
    main()