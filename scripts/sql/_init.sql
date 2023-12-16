-------------------------------------------------------------------------------
-- Init database
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS symbols;
CREATE TABLE IF NOT EXISTS symbols(
    SYMBOL VARCHAR,
    MARKET VARCHAR,
    name VARCHAR,
    type VARCHAR,
    ISIN VARCHAR,
);


DROP TABLE IF EXISTS indices;
CREATE TABLE IF NOT EXISTS indices(
    INDEX VARCHAR,
    MARKET VARCHAR,
    name VARCHAR,
    ISIN VARCHAR,
);

DROP TABLE IF EXISTS equities;
CREATE TABLE IF NOT EXISTS equities(
SYMBOL VARCHAR,
name VARCHAR,
ISIN VARCHAR,
MARKET VARCHAR,
);

DROP TABLE IF EXISTS index_composition;
CREATE TABLE IF NOT EXISTS index_composition(
    IDXSYMBOL VARCHAR,
    EQTSYMBOL VARCHAR,
);

DROP TABLE IF EXISTS exchanges;
CREATE TABLE IF NOT EXISTS exchanges(
    MARKET VARCHAR PRIMARY KEY,
    name VARCHAR,
    nb_indices INTEGER,
    nb_equities INTEGER,
);
CREATE OR REPLACE VIEW "v_exchanges_marker_list" AS SELECT DISTINCT market FROM exchanges;

