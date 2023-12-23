DROP TABLE IF EXISTS markets;
CREATE TABLE markets AS SELECT
MIC as MARKET,
"OPERATING MIC" as EXCHANGE,
"MARKET NAME-INSTITUTION DESCRIPTION" as name,
"LEGAL ENTITY NAME" as legal_name,
"ACRONYM" as acronym,
"ISO COUNTRY CODE (ISO 3166)" as country,
"CITY" as city,
"WEBSITE" as website,
"CREATION DATE" as date_creation,
LEI
FROM read_csv('./database/.import/markets.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
)
WHERE "STATUS" == 'ACTIVE';
