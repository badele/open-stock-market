-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS euronext_industry_relation;
CREATE TABLE euronext_industry_relation AS SELECT
*
FROM read_csv('./database/.import/euronext_industry_composition_*.csv',
    header=true,
    auto_detect=true,
    ignore_errors=true,
    filename=True
)
WHERE symbol<>'-';

-------------------------------------------------------------------------------
-- Cleaning table
-------------------------------------------------------------------------------
UPDATE euronext_industry_relation SET filename = replace(filename, '.csv', '');
UPDATE euronext_industry_relation SET filename = regexp_replace(filename, '.*_', '');
ALTER TABLE euronext_industry_relation RENAME filename TO industry;
