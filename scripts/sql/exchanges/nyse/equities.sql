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

-- -- Remove previous values
-- CREATE TEMPORARY TABLE tmp_nyse_market AS SELECT DISTINCT market FROM nyse_equities;
-- DELETE FROM symbols WHERE type='equity' and market in (select market from tmp_nyse_market);
--
-- INSERT INTO symbols 
-- SELECT symbol, market, name, 'equity', '' FROM "nyse_equities";
-- DROP TABLE IF EXISTS tmp_nyse_market;
