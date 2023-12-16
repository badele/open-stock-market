-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS "sse_indices";
CREATE TABLE "sse_indices" AS SELECT
*
FROM read_csv('./database/.import/sse_indices.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
)
WHERE symbol<>'';
;

-- Remove previous values
DELETE FROM symbols WHERE type='index' AND market=='XSHG';

INSERT INTO symbols 
SELECT symbol, 'XSHG', name, 'index', '' FROM "sse_indices";
