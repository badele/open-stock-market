DROP TABLE IF EXISTS nasdaq_indices;
CREATE TABLE nasdaq_indices AS SELECT
*
FROM read_csv('./database/.import/nasdaq_indices_*.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
)
;

-- Complete empty value
UPDATE nasdaq_indices SET name = 'Nasdaq-100 Pre Market Indicator' WHERE symbol=='QMI';
UPDATE nasdaq_indices SET name = 'NASDAQ-100' WHERE symbol=='NDX';
UPDATE nasdaq_indices SET name = 'NASDAQ-100 AHI' WHERE symbol=='QIV';
UPDATE nasdaq_indices SET name = 'NASDAQ Financial-100' WHERE symbol=='IXF';


