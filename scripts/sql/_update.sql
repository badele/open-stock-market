-------------------------------------------------------------------------------
-- Euronext
-------------------------------------------------------------------------------
-- Indices
DELETE FROM symbols where type='index' and exchange='EURONEXT';
INSERT INTO symbols
SELECT hash(concat_ws('-','EURONEXT',market,'index',symbol)) ,'EURONEXT', market, 'index', NULL, symbol, name, NULL, NULL, NULL,NULL, NULL, NULL,isin FROM euronext_indices;

-- Equities
DELETE FROM symbols where type='equity' and exchange='EURONEXT';
INSERT INTO symbols
SELECT hash(concat_ws('-','EURONEXT',market,'equity',symbol)) ,'EURONEXT', market, 'equity', NULL, symbol, name, NULL, NULL, NULL, NULL,NULL, NULL,isin FROM euronext_equities;

-------------------------------------------------------------------------------
-- NYSE
-------------------------------------------------------------------------------
-- Indices
DELETE FROM symbols where type='index' and exchange='NYSE';
INSERT INTO symbols
SELECT hash(concat_ws('-','NYSE',market,'index',symbol)) ,'NYSE', market, 'index', NULL, symbol, name, NULL, NULL,NULL, NULL, NULL, NULL,NULL FROM nyse_indices;

-- Equities
DELETE FROM symbols where type='equity' and exchange='NYSE';
INSERT INTO symbols
SELECT hash(concat_ws('-','NYSE',market,'equity',symbol)) ,'NYSE', market, 'equity', NULL, symbol, name, NULL, NULL,NULL,NULL, NULL, NULL,NULL FROM nyse_equities;

-------------------------------------------------------------------------------
-- Nasdaq
-------------------------------------------------------------------------------
-- Alter some columns and datas
ALTER TABLE nasdaq_equities
ADD COLUMN IF NOT EXISTS market VARCHAR;

UPDATE nasdaq_equities xnas SET market = (SELECT market FROM nyse_equities WHERE symbol=xnas.symbol AND market='XNYS');
UPDATE nasdaq_equities SET market = 'XNAS' WHERE market IS NULL;

-- Indices
DELETE FROM symbols where type='index' and exchange='NASDAQ';
INSERT INTO symbols 
SELECT hash(concat_ws('-','NASDAQ','XNAS','index',symbol)) ,'NASDAQ', 'XNAS', 'index', NULL, symbol, name, NULL, NULL,NULL,NULL, NULL, NULL,NULL FROM nasdaq_indices;

-- Equities
DELETE FROM symbols where type='index' and exchange='NASDAQ';
INSERT INTO symbols
SELECT hash(concat_ws('-','NASDAQ',market,'equity',symbol)) ,'NASDAQ', market, 'equity', NULL, symbol, name,NULL, NULL,NULL,NULL, NULL, NULL,NULL FROM nasdaq_equities WHERE market='XNAS';

-------------------------------------------------------------------------------
-- SSE
-------------------------------------------------------------------------------
DELETE FROM symbols where type='index' and exchange='SSE';
INSERT INTO symbols 
SELECT hash(concat_ws('-','SSE','XSHG','equity',symbol)) ,'SSE', 'XSHG', 'index', NULL, symbol, name, NULL, NULL,NULL,NULL, NULL, NULL,NULL FROM "sse_indices";

-------------------------------------------------------------------------------
-- SZSE
-------------------------------------------------------------------------------
DELETE FROM symbols where type='index' and exchange='SZSE';
INSERT INTO symbols 
SELECT hash(concat_ws('-','SZSE','XSHE','equity',code)) ,'SZSE', 'XSHE', 'index', NULL, code, name, NULL,NULL,NULL,NULL, NULL, NULL,NULL FROM "szse_indices";

-------------------------------------------------------------------------------
-- Exchanges
-------------------------------------------------------------------------------

-- Init exchange datas
DELETE FROM exchanges;
INSERT INTO exchanges
SELECT DISTINCT s.exchange, s.market,m.name,0,0 FROM markets m INNER JOIN symbols s ON m.market = s.market;

-- Rename some name symbols
UPDATE exchanges SET name = regexp_replace(name, ', INC\.$', '');
UPDATE exchanges SET name = regexp_replace(name, '^EURONEXT - ', '');
UPDATE exchanges SET name = regexp_replace(name, ' - ALL MARKETS?$', '');
UPDATE exchanges SET name = regexp_replace(name, '\(GLOBAL .*MARKET\)$', '');

-- Count indices
CREATE TABLE nb_indices AS
SELECT exchange, market,count(*) AS count FROM symbols WHERE type='index' GROUP BY exchange, market;
UPDATE exchanges SET nb_indices = (SELECT count FROM nb_indices WHERE exchange=exchanges.exchange AND market=exchanges.market);
DROP TABLE nb_indices;

-- Count equities
CREATE TABLE nb_equities AS
SELECT exchange, market,count(*) AS count FROM symbols WHERE type='equity' GROUP BY exchange, market;
UPDATE exchanges SET nb_equities = (SELECT count FROM nb_equities WHERE exchange=exchanges.exchange AND market=exchanges.market);
DROP TABLE nb_equities;

-------------------------------------------------------------------------------
-- Symbols
-------------------------------------------------------------------------------
UPDATE euronext_equities_history SET isin = replace(isin, '.csv', '');
UPDATE euronext_equities_history SET isin = regexp_replace(isin, '.*_', '');
UPDATE euronext_equities_history SET time = substr(time,1,10);
UPDATE euronext_equities_history h SET symbol = (SELECT symbol FROM symbols WHERE exchange='EURONEXT' AND market=h.market AND isin=h.isin);
UPDATE euronext_equities_history SET symbolid = hash(concat_ws('-','EURONEXT',market,'equity',symbol));

INSERT INTO symbols_history (symbolid,date,prevprice,price,prevvolume,volume) 
SELECT 
  symbolid,
  time,
  lag(price) OVER (PARTITION BY symbolid ORDER BY time) as prevprice,
  price,
  lag(volume) OVER (PARTITION BY symbolid ORDER BY time) as prevvolume,
  volume
FROM 
  euronext_equities_history
ORDER BY 
  symbolid,time
ON CONFLICT (symbolid,date)
DO UPDATE SET
  prevprice=EXCLUDED.prevprice,
  price=EXCLUDED.price,
  prevvolume=EXCLUDED.prevvolume,
  volume=EXCLUDED.volume;


-- indices
-- UPDATE symbols set lastdate = (SELECT strptime("last date/time", '%d/%m/%Y %H:%M') FROM euronext_indices WHERE symbol=symbols.symbol AND "last date/time" <> '-') where exchange='EURONEXT' AND type='index';
-- UPDATE symbols set open = (SELECT "open" FROM euronext_indices WHERE symbol=symbols.symbol AND open IS NOT NULL) where exchange='EURONEXT' and type='index';
-- UPDATE symbols set close = (SELECT "last" FROM euronext_indices WHERE symbol=symbols.symbol AND last IS NOT NULL) where exchange='EURONEXT' and type='index';
-- equities sector
UPDATE symbols SET industry = (SELECT industry FROM euronext_industry_relation WHERE symbol=symbols.symbol) where exchange='EURONEXT' and type='equity';

-- nb histo
UPDATE symbols s
SET 
  nbhisto=(
    SELECT 
      count() as nbhisto 
    FROM 
      symbols_history 
    WHERE 
      symbolid=s.symbolid 
    GROUP BY symbolid
  );

-------------------------------------------------------------------------------
-- begin price
-------------------------------------------------------------------------------
WITH begin_price AS (
  SELECT 
      symbolid,
      first(date) as date,
      first(price) as firstprice,
    FROM 
      symbols_history
    GROUP BY symbolid
)
UPDATE symbols s
SET 
  firstdate=l.date,
  firstprice=l.firstprice
FROM 
  begin_price l
WHERE 
  s.symbolid=l.symbolid;


-------------------------------------------------------------------------------
-- Last price
-------------------------------------------------------------------------------
WITH last_price AS (
  SELECT 
    symbolid,
    last(date) as date,
    last(price) as lastprice,
  FROM 
    symbols_history
  GROUP BY symbolid
)
UPDATE symbols s
SET 
  lastdate=l.date,
  lastprice=l.lastprice,
FROM last_price l
WHERE s.symbolid=l.symbolid;

-- price performance
UPDATE 
  symbols 
SET 
  perf=round((lastprice-firstprice)/firstprice*100,2) 
WHERE lastprice IS NOT NULL AND firstprice IS NOT NULL;


-- Summary
INSERT OR IGNORE INTO symbols_summary BY NAME
SELECT symbolid,'7d' as name,max(date)-INTERVAL 7 DAY as value FROM symbols_history GROUP BY symbolid;
-------------------------------------------------------------------------------
-- Create view
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW "v_symbols" AS
  SELECT DISTINCT
    s.SYMBOLID, s.EXCHANGE, s.MARKET,s.SYMBOL,s.TYPE,i.INDUSTRY,name,firstdate,lastdate,nbhisto,firstprice,lastprice,ISIN
  FROM 
    symbols s LEFT JOIN sectors_icb i ON s.industry = i."industry code"
  ORDER BY exchange,market,symbol;

CREATE OR REPLACE VIEW "v_sectors" AS
  SELECT 
    exchange,market, industry, count() 
  from 
    v_symbols 
  GROUP by exchange,market,industry 
  ORDER by exchange,market,count();


-- CREATE OR REPLACE VIEW "v_symbols_history" AS
-- SELECT 
--   symbolid,
--   exchange, 
--   market, 
--   symbol,
--   h.date,
--   h.prevprice,
--   h.price,
--   round((h.price-h.prevprice)/h.price*100,2) AS perf,
--   h.prevvolume,
--   h.volume,
--   round((h.volume-h.prevvolume)/h.volume*100,2) AS perfvolume
-- FROM 
--   symbols_history h 
--   INNER JOIN symbols s USING (symbolid) 
-- ORDER BY 
--   exchange,market,symbol,date;

-------------------------------------------------------------------------------
-- List only symbol with industry field
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW "v_symbols_with_industry" AS
  SELECT DISTINCT * FROM v_symbols WHERE industry IS NOT NULL AND firstdate is not null;

CREATE OR REPLACE VIEW "v_symbols_history" AS
  SELECT 
    DISTINCT ON (h.symbolid,h.date)
    s.symbolid,
    exchange, 
    market, 
    symbol,
    name,
    industry,
    date,
    price
  FROM 
    symbols_history h
    INNER JOIN v_symbols s ON s.symbolid=h.symbolid

-- CREATE OR REPLACE VIEW "v_industry_history" AS
--   SELECT
--     s.exchange,
--     s.market,
--     s.symbol,
--     h.date,
--     industry,
--     sum(h.price) as price,
--     avg(h.perf) as perf
--   FROM v_symbols s
--     INNER JOIN v_symbols_history h ON s.symbolid=h.symbolid
--   WHERE lastdate is not NULL
--   GROUP BY ALL;
--

-- CREATE OR REPLACE VIEW "v_sectors_summary" AS
-- SELECT exchange,market, industry, count() from v_symbols GROUP by exchange,market,industry ORDER by exchange,market,count();

-- CREATE OR REPLACE VIEW "v_euronext_helper_index_composition_history" AS
-- SELECT market,index,isin, 'https://live.euronext.com/intraday_chart/getChartData/' || ISIN || '-' || MARKET || '/max' as url from v_symbols s inner join euronext_index_compositions c using(isin) ;
--
CREATE OR REPLACE VIEW "v_euronext_helper_url_history" AS
SELECT market,industry, isin, 'https://live.euronext.com/intraday_chart/getChartData/' || ISIN || '-' || MARKET || '/max' as url from v_symbols;


CREATE OR REPLACE VIEW "v_exchanges_marker_list" AS SELECT DISTINCT market FROM exchanges;

CREATE OR REPLACE MACRO f_equities_by_sector(sector) AS TABLE select * from v_symbols where exchange='EURONEXT' AND market='XPAR' AND industry=sector AND lastdate is not null;


-------------------------------------------------------------------------------
-- Drop tables
-------------------------------------------------------------------------------
-- DROP TABLE IF EXISTS euronext_equities;
-- DROP TABLE IF EXISTS euronext_index_compositions;
-- DROP TABLE IF EXISTS euronext_indices;
-- DROP TABLE IF EXISTS euronext_industry_relation;
-- DROP TABLE IF EXISTS index_composition;
-- DROP TABLE IF EXISTS lei_bic;
-- DROP TABLE IF EXISTS lei_isin;
-- DROP TABLE IF EXISTS lei_mic;
-- DROP TABLE IF EXISTS lei_oc;
-- DROP TABLE IF EXISTS nasdaq_equities;
-- DROP TABLE IF EXISTS nasdaq_indices;
-- DROP TABLE IF EXISTS nyse_equities;
-- DROP TABLE IF EXISTS nyse_indices;
-- DROP TABLE IF EXISTS sectors_icb;
-- DROP TABLE IF EXISTS sse_indices;
-- DROP TABLE IF EXISTS szse_indices;

