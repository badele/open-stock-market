-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS nyse_indices;
CREATE TABLE nyse_indices AS SELECT
*
FROM read_csv('./database/.import/nyse_indices_*.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
);

UPDATE nyse_indices SET market = 'XNYS' WHERE market='XXXX';
DELETE FROM nyse_indices WHERE market<>'XNYS';
