-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS euronext_index_compositions;
CREATE TABLE euronext_index_compositions AS SELECT
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
UPDATE euronext_index_compositions SET filename = replace(filename, '.csv', '');
UPDATE euronext_index_compositions SET filename = regexp_replace(filename, '.*_', '');
ALTER TABLE euronext_index_compositions RENAME filename TO index;
ALTER TABLE euronext_index_compositions RENAME symbol TO isin;

