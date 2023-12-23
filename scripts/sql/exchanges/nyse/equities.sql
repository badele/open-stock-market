-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS nyse_equities;
CREATE TABLE nyse_equities AS SELECT
*
FROM read_csv('./database/.import/nyse_equities_*.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
)
;

UPDATE nyse_equities SET market = 'XNYS' WHERE market='XXXX';
DELETE FROM nyse_equities WHERE market<>'XNYS';
