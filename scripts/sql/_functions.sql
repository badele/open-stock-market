-- CREATE OR REPLACE MACRO f_begindate_by_period(fname,period) AS TABLE 
-- WITH begindate as (
--   SELECT 
--     symbolid,
--     max(date)-to_days(period) as value 
--   FROM 
--     symbols_history GROUP BY symbolid
-- )
-- SELECT 
--   h.symbolid,
--   round((last(close)-first(close))/first(close)*100,2) as value 
-- FROM 
--   symbols_history h 
--   INNER JOIN begindate b ON h.symbolid = b.symbolid AND h.date >= b.value
-- GROUP BY ALL;

-------------------------------------------------------------------------------
-- indice100 perf
-- period is the number of days to compute the indicator
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Get date range for all symbols in same date range
-- nbdays is the number of days to compute the date range
-------------------------------------------------------------------------------
CREATE OR REPLACE MACRO f_date_indices100_range(nbdays) AS TABLE
  WITH
    keep AS (
      select symbolid,name,firstdate,today()-nbdays,lastdate from v_symbols where industry IS NOT NULL AND lastdate IS NOT NULL AND firstdate<today()-nbdays
    ),
    lastselected AS (
      SELECT lastdate,count() as nbkeep FROM keep GROUP BY lastdate ORDER BY count() DESC LIMIT 1
    ),
    firstselected AS (
      SELECT max(firstdate) as firstdate FROM keep WHERE lastdate = (SELECT lastdate FROM lastselected)
    )
    SELECT 
      k.symbolid,
    (SELECT firstdate FROM firstselected) as firstindicedate,
    (SELECT lastdate FROM lastselected) as lastindicedate,
    price as firstindiceprice
    FROM
      keep k
    INNER JOIN symbols_history h ON
      h.symbolid = k.symbolid
      AND h.date = (SELECT firstdate FROM firstselected)
    GROUP BY ALL
;

-------------------------------------------------------------------------------
-- Get all history in the indice100 range
-- nbdays is the number of minimal days to return symbols history
-------------------------------------------------------------------------------
CREATE OR REPLACE MACRO f_table_indice100_symbols_history(nbdays) AS TABLE
    select 
      h.*,
      price/firstindiceprice*100 as indice100
    from f_date_incides100_range(nbdays) i INNER JOIN v_symbols_history h USING (symbolid)
    where date > firstindicedate AND date <= lastindicedate
;

-------------------------------------------------------------------------------
-- SMA indicator (Simple Moving Average)
-- period is the number of days to compute the indicator
-------------------------------------------------------------------------------
CREATE OR REPLACE MACRO f_indicator_sma(period) AS TABLE
WITH byday as (
  SELECT 
    id, 
    date, 
    value, 
    row_number() OVER tick as rownum
  FROM tocompute
  WINDOW tick AS (PARTITION BY id ORDER BY date)
  ORDER BY id,date
),
byperiod as (
  SELECT
    id,
    date,
    value,
    IF(rownum>=period,avg(value) OVER tickperiod,null) as sma,
    rownum
  FROM byday
  WINDOW tickperiod AS (ROWS BETWEEN period-1 PRECEDING AND CURRENT ROW)
)
SELECT id,date,value,sma FROM byperiod
ORDER BY id,date;

-------------------------------------------------------------------------------
-- Compute Moving Average Convergence Divergence (MACD)
-------------------------------------------------------------------------------
CREATE OR REPLACE MACRO f_indicator_macd(pshort,plong) AS TABLE 
SELECT mshort.id,mshort.date,mshort.value,mshort.sma- mlong.sma AS macd, FROM f_indicator_sma(pshort) mshort 
INNER JOIN f_indicator_sma(plong) mlong ON mshort.id=mlong.id AND mshort.date=mlong.date
ORDER BY mshort.id,mshort.date;


-- ADX (Average Directional movement index)
-- period is the number of days to compute the indicator
-- ADX = MA [((+DI) – (-DI)) / ((+DI) + (-DI))] x 100;
-- CREATE OR REPLACE MACRO f_indicator_adx(period,direction) AS TABLE 
-- WITH byday as (
--     select symbolid, date, close, 
--     close-lag(close) OVER tick AS delta,
--     abs(delta) as adelta,
--     IF(delta>0,adelta,0) as dip,
--     IF(delta<0,adelta,0) as dim,
--     row_number() OVER tick as rownum,
--     from symbols_history
--     WINDOW tick AS (PARTITION BY symbolid ORDER BY date)
-- ),
-- byperiod as (
--     SELECT symbolid, date, close,adelta,
--     IF(rownum>=period,avg((dip-dim)/(dip+dim)*100) OVER tickperiod,null) as adx,
--     rownum
--     from byday
--     WINDOW tickperiod AS (ROWS BETWEEN period PRECEDING AND CURRENT ROW)
-- )
-- select symbolid,date,adx,dip,dim from byperiod;

-------------------------------------------------------------------------------
-- EMA indicator (Exponential Moving Average)
-- period is the number of days to compute the indicator
-------------------------------------------------------------------------------
-- duckdb duckdb -csv "select symbolid,date,close from symbols_history where symbolid=12436277544525145948"
CREATE OR REPLACE MACRO f_indicator_ema(period) AS TABLE 
WITH RECURSIVE sma AS (
  SELECT
    symbolid,
    date,
    close,
    sma,
    sma as ema,
    2/(period+1) as alpha,
    row_number() OVER tick as rownum,
  FROM
   f_indicator_sma(period)
  WINDOW tick AS (PARTITION BY symbolid ORDER BY date)
),
newsma AS (
  SELECT 
    symbolid,
    date,
    close,
    sma,
    sma as ema,
    alpha
  FROM 
    sma
  WHERE
    rownum <= period

  UNION ALL

  SELECT
    t.symbolid,
    t.date,
    t.close,
    t.sma,
    (1 - t.alpha) * e.ema + t.alpha * t.sma AS ema,
    t.alpha
   FROM
    sma t
    JOIN sma e ON t.symbolid = e.symbolid AND t.rownum = e.rownum + 1
    WHERE t.rownum > period
)
select symbolid,date,close,ema FROM newsma
ORDER BY symbolid,date;

