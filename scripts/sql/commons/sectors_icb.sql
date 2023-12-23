DROP TABLE IF EXISTS sectors_icb;
CREATE TABLE sectors_icb AS 
SELECT *
FROM read_csv('./database/.import/sectors_icb.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
);

ALTER TABLE sectors_icb
DROP column0;

-- trim name
UPDATE sectors_icb SET industry=TRIM(industry);
UPDATE sectors_icb SET supersector=TRIM(supersector);
UPDATE sectors_icb SET sector=TRIM(sector);
UPDATE sectors_icb SET subsector=TRIM(subsector);

CREATE OR REPLACE VIEW "v_euronext_helper_sectors_icb" AS
SELECT "industry code", string_agg(distinct "supersector code",',') || ',' || string_agg(distinct "sector code",',') || ',' || string_agg("Subsector code",',') as arg from sectors_icb GROUP BY "industry code";
