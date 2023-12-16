-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS "euronext_indices";
CREATE TABLE "euronext_indices" AS SELECT
*
FROM read_csv('./database/.import/euronext_indices_*.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
    ,filename=True
);

-- Market
UPDATE euronext_indices SET filename = replace(filename, '.csv', '');
UPDATE euronext_indices SET filename = regexp_replace(filename, '.*_', '');
ALTER TABLE euronext_indices RENAME filename TO market;

-- Remove previous values
CREATE TEMPORARY TABLE tmp_euronext_market AS SELECT DISTINCT market FROM euronext_indices;
DELETE FROM symbols WHERE type='index' AND market IN (select market from tmp_euronext_market);

INSERT INTO symbols
SELECT symbol, market, name, 'index', isin FROM "euronext_indices";
DROP TABLE IF EXISTS tmp_euronext_market;

-- Create helpers
CREATE OR REPLACE VIEW "v_euronext_helper_index_composition" AS SELECT INDEX,'https://live.euronext.com/fr/ajax/getIndexCompositionFull/' || ISIN || '-' || MARKET as url from indices;
CREATE OR REPLACE VIEW "v_euronext_helper_index_history" AS SELECT INDEX,'https://live.euronext.com/intraday_chart/getChartData/' || ISIN || '-' || MARKET || '/max' as url from indices;
