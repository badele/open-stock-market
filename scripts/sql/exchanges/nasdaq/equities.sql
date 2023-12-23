DROP TABLE IF EXISTS nasdaq_equities;
CREATE TABLE nasdaq_equities AS SELECT
*
FROM read_csv('./database/.import/nasdaq_equities.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
);
