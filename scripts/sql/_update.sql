-------------------------------------------------------------------------------
-- NYSE
-------------------------------------------------------------------------------

-- Insert indices
CREATE TEMPORARY TABLE tmp_nyse_market AS SELECT DISTINCT market FROM nyse_indices;
DELETE FROM symbols WHERE type='index' and market in (select market from tmp_nyse_market);

INSERT INTO symbols 
SELECT symbol, market, name, 'index', '' FROM "nyse_indices";
DROP TABLE IF EXISTS tmp_nyse_market;

-- Insert equities
CREATE TEMPORARY TABLE tmp_nyse_market AS SELECT DISTINCT market FROM nyse_equities;
DELETE FROM symbols WHERE type='equity' and market in (select market from tmp_nyse_market);

INSERT INTO symbols 
SELECT symbol, market, name, 'equity', '' FROM "nyse_equities";
DROP TABLE IF EXISTS tmp_nyse_market;


-------------------------------------------------------------------------------
-- Nasdaq
-------------------------------------------------------------------------------

ALTER TABLE nasdaq_equities
ADD COLUMN IF NOT EXISTS market VARCHAR;

UPDATE nasdaq_equities xnas SET market = (SELECT market FROM nyse_equities WHERE symbol=xnas.symbol AND market='XNYS');
UPDATE nasdaq_equities SET market = 'XNAS' WHERE market IS NULL;

-- Insert indices
DELETE FROM symbols WHERE type='index' AND market=='XNAS';
INSERT INTO symbols 
SELECT symbol, 'XNAS', name, 'index', '' FROM "nasdaq_indices";

-- Insert equities
DELETE FROM symbols WHERE type='equity' AND market=='XNAS' ;
INSERT INTO symbols
SELECT DISTINCT symbol,market, name,'equity', '' FROM nasdaq_equities WHERE market='XNAS';


-------------------------------------------------------------------------------
-- Exchanges
-------------------------------------------------------------------------------

-- Init exchange datas
DELETE FROM exchanges;
INSERT INTO exchanges
SELECT market,name,0,0 FROM market WHERE market IN (SELECT DISTINCT market from symbols);

-- Rename some name symbols
UPDATE exchanges SET name = regexp_replace(name, ', INC\.$', '');
UPDATE exchanges SET name = regexp_replace(name, '^EURONEXT - ', '');
UPDATE exchanges SET name = regexp_replace(name, ' - ALL MARKETS?$', '');
UPDATE exchanges SET name = regexp_replace(name, '\(GLOBAL .*MARKET\)$', '');

-- Clasify symbols
UPDATE exchanges SET nb_indices = (SELECT COUNT(*) FROM symbols WHERE market=exchanges.market and type='index');
UPDATE exchanges SET nb_equities = (SELECT COUNT(*) FROM symbols WHERE market=exchanges.market and type='equity');

