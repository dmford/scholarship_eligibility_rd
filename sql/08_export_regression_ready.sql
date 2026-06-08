COPY rd_analysis_panel
TO 'data/processed/rd_analysis_panel.csv'
WITH (HEADER, DELIMITER ',');

COPY validation_summary
TO 'outputs/tables/validation_summary.csv'
WITH (HEADER, DELIMITER ',');