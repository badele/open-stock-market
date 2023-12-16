-- International Securities Identification Numbers (ISIN)
DROP TABLE IF EXISTS lei_isin;
CREATE TABLE lei_isin AS FROM read_csv('./database/.import/lei-isin-*.csv',header=true,auto_detect=true);

-- Market Identifier Code (MIC)
DROP TABLE IF EXISTS lei_bic;
CREATE TABLE lei_bic AS FROM read_csv('./database/.import/lei-bic-*.csv',header=true,auto_detect=true);

DROP TABLE IF EXISTS lei_mic;
CREATE TABLE lei_mic AS FROM read_csv('./database/.import/lei-mic-*.csv',header=true,auto_detect=true);

DROP TABLE IF EXISTS lei_oc;
CREATE TABLE lei_oc AS FROM read_csv('./database/.import/lei-oc-*.csv',header=true,auto_detect=true);

DROP TABLE IF EXISTS lei;
CREATE TABLE lei AS SELECT
lei,
'' as ISIN,
"Entity.LegalName" as name,
"Entity.LegalAddress.Country" as country,
"Entity.LegalAddress.City" as city,
"Entity.LegalAddress.Region" as region,
"Entity.LegalAddress.PostalCode" as postalCode,
"Entity.LegalAddress.FirstAddressLine" as addressLine,
"Entity.HeadquartersAddress.Country" as hq_country,
"Entity.HeadquartersAddress.City" as hq_city,
"Entity.HeadquartersAddress.Region" as hq_region,
"Entity.HeadquartersAddress.PostalCode" as hq_postalCode,
"Entity.HeadquartersAddress.FirstAddressLine" as hq_addressLine,
"Entity.LegalJurisdiction" as legal_jurisdiction,
"Entity.EntityCategory" as category,
"Entity.EntitySubCategory" as subCategory,
"Entity.EntityCreationDate" as date_creation
FROM read_csv('./database/.import/*-golden-copy.csv'
  ,header=true
  ,auto_detect=true
  ,ignore_errors=true
) 
WHERE
LEI in (select LEI from lei_isin)
AND "Registration.RegistrationStatus" == 'ISSUED'
AND "Entity.EntityStatus" == 'ACTIVE'
;

-- UPDATE lei 
--     SET isin = lei_isin.isin 
--     FROM lei_isin
--     WHERE lei.lei = lei_isin.lei;
--
-- UPDATE lei 
--     SET bic = lei_bic.bic 
--     FROM lei_bic
--     WHERE lei.lei = lei_bic.lei;
--
-- UPDATE lei 
--     SET mic = lei_mic.mic 
--     FROM lei_mic
--     WHERE lei.lei = lei_mic.lei;
--
-- UPDATE lei 
--     SET oc = lei_oc.OpenCorporatesID 
--     FROM lei_oc
--     WHERE lei.lei = lei_oc.lei;


COPY (select * from lei) to './database/.export/entity.csv' (HEADER, DELIMITER ';');
