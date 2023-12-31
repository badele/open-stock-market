-------------------------------------------------------------------------------
-- Init database
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS symbols;
CREATE TABLE IF NOT EXISTS symbols(
    SYMBOLID UINT64,
    EXCHANGE VARCHAR,
    MARKET VARCHAR,
    TYPE VARCHAR,
    INDUSTRY INTEGER,
    SYMBOL VARCHAR,
    name VARCHAR,
    firstdate DATE,
    lastdate DATE,
    nbhisto INTEGER,
    firstprice DOUBLE,
    lastprice DOUBLE,
    perf DOUBLE,
    ISIN VARCHAR
);

DROP TABLE IF EXISTS symbols_history;
CREATE TABLE IF NOT EXISTS symbols_history(
    SYMBOLID UINT64,
    DATE DATE,
    prevprice DOUBLE,
    price DOUBLE,
    prevvolume DOUBLE,
    volume DOUBLE,
    PRIMARY KEY (SYMBOLID,DATE)
);

DROP TABLE IF EXISTS symbols_summary;
CREATE TABLE IF NOT EXISTS symbols_summary(
    SYMBOLID UINT64,
    NAME VARCHAR,
    value UNION(int INT64,float DOUBLE, date DATE),
    PRIMARY KEY (SYMBOLID,NAME)
);


DROP TABLE IF EXISTS index_composition;
CREATE TABLE IF NOT EXISTS index_composition(
    IDXSYMBOL VARCHAR,
    EQTSYMBOL VARCHAR,
);

DROP TABLE IF EXISTS exchanges;
CREATE TABLE IF NOT EXISTS exchanges(
    EXCHANGE VARCHAR,
    MARKET VARCHAR,
    name VARCHAR,
    nb_indices INTEGER,
    nb_equities INTEGER,
    PRIMARY KEY (EXCHANGE,MARKET)
);
