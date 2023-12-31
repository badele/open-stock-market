DROP TABLE IF EXISTS nasdaq_equities;
CREATE TABLE nasdaq_equities AS SELECT
*
FROM read_csv('./database/.import/nasdaq_equities.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
);

-- -- Insert equities
-- DELETE FROM symbols WHERE type='equity' AND market=='XNAS' ;
--
-- INSERT INTO symbols
-- SELECT DISTINCT symbol,'XNAS', name,'equity', '' FROM nasdaq_equities;
--
-- ALTER TABLE nasdaq_equities
-- ADD COLUMN market VARCHAR;
