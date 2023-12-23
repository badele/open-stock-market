-------------------------------------------------------------------------------
-- Import files
-------------------------------------------------------------------------------
DROP TABLE IF EXISTS euronext_equities;
CREATE TABLE euronext_equities AS SELECT
*
FROM read_csv('./database/.import/euronext_equities.csv'
    ,header=true
    ,auto_detect=true
    ,ignore_errors=true
)
WHERE symbol <> '-';

ALTER TABLE euronext_equities ADD COLUMN multi_markets BOOLEAN;
-------------------------------------------------------------------------------
-- Cleaning table
-------------------------------------------------------------------------------
-- some market
UPDATE euronext_equities SET market  = regexp_replace(market,'EuroTLX','ETLX');
UPDATE euronext_equities SET market  = regexp_replace(market,'Euronext Expert Market','VPXB');
UPDATE euronext_equities SET market  = regexp_replace(market,'Euronext Global Equity Market','BGEM');
UPDATE euronext_equities SET market  = regexp_replace(market,'Oslo Børs','XOSL');
UPDATE euronext_equities SET market  = regexp_replace(market,'Trading After Hours','MTAH');

-- Euronext Growth
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Brussels','ALXB') WHERE market like 'Euronext Growth%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Dublin','XESM') WHERE market like 'Euronext Growth%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Lisbon','ALXL') WHERE market like 'Euronext Growth%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Milan','EXGM') WHERE market like 'Euronext Growth%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Oslo','MERK') WHERE market like 'Euronext Growth%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Paris','ALXP') WHERE market like 'Euronext Growth%';
UPDATE euronext_equities SET market  = regexp_replace(market,'Euronext Growth','') WHERE market like 'Euronext Growth%';

-- Euronext Access
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Brussels','MLXB') WHERE market like 'Euronext Access%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Lisbon','ENXL') WHERE market like 'Euronext Access%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Milan','XMOT') WHERE market like 'Euronext Access%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Paris','XMLI') WHERE market like 'Euronext Access%';
UPDATE euronext_equities SET market  = regexp_replace(market,'Euronext Access','') WHERE market like 'Euronext Access%';

-- -- XOAS
UPDATE euronext_equities SET market  = regexp_replace(market,'Euronext Expand Oslo','XOAS') WHERE market like 'Euronext Expand%';
UPDATE euronext_equities SET market  = regexp_replace(market,'Euronext Expand','') WHERE market like 'Euronext Expand%';

-- Euronext
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Amsterdam','XAMS') WHERE market like 'Euronext%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Brussels','XBRU') WHERE market like 'Euronext%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Dublin','XDUB') WHERE market like 'Euronext%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Lisbon','XLIS') WHERE market like 'Euronext%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Milan','XMIL') WHERE market like 'Euronext%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Oslo','XOSL') WHERE market like 'Euronext%';
UPDATE euronext_equities SET market  = regexp_replace(market,' ?Paris','XPAR') WHERE market like 'Euronext%';
UPDATE euronext_equities SET market  = regexp_replace(market,'Euronext','') WHERE market like 'Euronext%';

UPDATE euronext_equities SET multi_markets = contains(market,',');
UPDATE euronext_equities SET market = 'XAMS' WHERE multi_markets AND substring(isin,1,2)='NL';
UPDATE euronext_equities SET market = 'XAMS' WHERE multi_markets AND substring(isin,1,2)='LU';
UPDATE euronext_equities SET market = 'XBRU' WHERE multi_markets AND substring(isin,1,2)='BE';
UPDATE euronext_equities SET market = 'XPAR' WHERE multi_markets AND substring(isin,1,2)='FR';
