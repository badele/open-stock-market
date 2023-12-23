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
    previous DOUBLE,
    close DOUBLE,
    delta DOUBLE,
    lastupdate DATE,
    ISIN VARCHAR,
);

DROP TABLE IF EXISTS symbols_history;
CREATE TABLE IF NOT EXISTS symbols_history(
    SYMBOLID UINT64,
    -- EXCHANGE VARCHAR,
    -- MARKET VARCHAR,
    -- TYPE VARCHAR,
    -- SYMBOL VARCHAR,
    DATE DATE,
    previous DOUBLE,
    close DOUBLE,
    volume DOUBLE,
    -- PRIMARY KEY (EXCHANGE, MARKET, TYPE, SYMBOL,DATE)
    PRIMARY KEY (SYMBOLID,DATE)
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
