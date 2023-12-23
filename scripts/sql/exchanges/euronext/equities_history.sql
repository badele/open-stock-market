-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS euronext_equities_history;
CREATE TABLE euronext_equities_history AS SELECT
*
FROM read_csv('./database/.import/euronext_equities_history_*.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
    ,filename=True
);

ALTER TABLE euronext_equities_history RENAME filename TO isin;
ALTER TABLE euronext_equities_history ADD COLUMN symbolid UINT64;
ALTER TABLE euronext_equities_history ADD COLUMN symbol VARCHAR;

