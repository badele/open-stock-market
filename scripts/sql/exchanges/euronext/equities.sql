-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS euronext_equities;
CREATE TABLE euronext_equities AS SELECT
*
FROM read_csv('./database/.import/euronext_equities_*.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
    ,filename=True
)
;

-------------------------------------------------------------------------------
-- Cleaning table
-------------------------------------------------------------------------------
-- Get market name from filename
ALTER TABLE euronext_equities RENAME market TO markets;
UPDATE euronext_equities SET filename = replace(filename, '.csv', '');
UPDATE euronext_equities SET filename = regexp_replace(filename, '.*_', '');
ALTER TABLE euronext_equities RENAME filename TO market;

-- get equities markets relation
DROP TABLE IF EXISTS euronext_equities_market_relation;
CREATE TABLE euronext_equities_market_relation AS 
SELECT symbol,market FROM euronext_equities;

-- -- Insert equities
CREATE TEMPORARY TABLE tmp_euronext_market AS SELECT DISTINCT market FROM euronext_equities;
DELETE FROM symbols WHERE type='equity' AND market IN (select market from tmp_euronext_market);
INSERT INTO symbols
SELECT symbol, market, name, 'equity', isin FROM "euronext_equities";
DROP TABLE IF EXISTS tmp_euronext_market;
