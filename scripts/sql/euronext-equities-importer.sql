-- DROP TABLE IF EXISTS "equities.euronext";
-- CREATE TABLE "equities.euronext" AS SELECT
-- *
-- FROM read_csv('./database/.import/equities-euronext.csv'
--     ,header=true
--     ,auto_detect=true
--     ,ignore_errors=true
-- )
-- ;
--
-- COPY (
--     SELECT 
--     ISIN,symbol, name,'EURONEXT' as source
--     FROM "equities.euronext"
--     WHERE (
--         market not in (
--             'Euronext Global Equity Market'
--             , 'EuroTLX'
--             ,'Trading After Hours'
--         )
--         AND symbol <> '-' 
--         AND volume <> '-' 
--         AND "Closing Price" <> '-'
--     )
-- ) TO './database/.export/equities-euronext.csv' (HEADER, DELIMITER ',');