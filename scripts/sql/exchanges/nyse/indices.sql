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

-- -- Remove previous values
-- CREATE TEMPORARY TABLE tmp_nyse_market AS SELECT DISTINCT market FROM nyse_indices;
-- DELETE FROM symbols WHERE type='index' and market in (select market from tmp_nyse_market);
--
-- INSERT INTO symbols 
-- SELECT symbol, market, name, 'index', '' FROM "nyse_indices";
-- DROP TABLE IF EXISTS tmp_nyse_market;
