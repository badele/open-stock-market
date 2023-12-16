-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS "euronext_index_relation";
CREATE TABLE "euronext_index_relation" AS SELECT
*
FROM read_csv('./database/.import/euronext_index_composition_*.csv',
    header=false,
    columns = { "symbol": "VARCHAR" },
    auto_detect=true,
    ignore_errors=true,
    filename=True
)
;

-------------------------------------------------------------------------------
-- Cleaning table
-------------------------------------------------------------------------------
UPDATE euronext_index_relation SET filename = replace(filename, '.csv', '');
UPDATE euronext_index_relation SET filename = regexp_replace(filename, '.*_', '');
ALTER TABLE euronext_index_relation RENAME filename TO index;

-- DELETE FROM index_composition WHERE exchange='Euronext';
--
-- INSERT INTO indices 
-- SELECT symbol,name,isin,substring(filename,-4,-4) as market, 'Euronext' as exchange FROM "indices.euronext";
--
-- -- Get URL index composition
-- CREATE OR REPLACE VIEW "euronext.indicecomposition" AS SELECT *,'https://live.euronext.com/fr/ajax/getIndexCompositionFull/' || ISIN || '-' || market as url from indices WHERE exchange='Euronext';

