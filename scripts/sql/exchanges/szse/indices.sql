-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS "szse_indices";
CREATE TABLE "szse_indices" AS SELECT
*
FROM read_csv('./database/.import/szse_indices.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
)
;

-- Remove previous values
DELETE FROM symbols WHERE type='index' AND market=='XSHE';

INSERT INTO symbols 
SELECT code, 'XSHE', name, 'index', '' FROM "szse_indices";
