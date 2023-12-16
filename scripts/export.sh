#!/usr/bin/env bash

DUCKDB="duckdb duckdb"

rm -rf ./database/.export/symbols
mkdir -p ./database/.export/symbols

# Export symbols markets
MARKETS=$($DUCKDB -noheader -list "SELECT market FROM v_exchanges_marker_list")
for MARKET in ${MARKETS}; do
  $DUCKDB "COPY (SELECT symbol,name,type,isin FROM symbols WHERE MARKET='$MARKET' ORDER BY name ) TO './database/.export/symbols/$MARKET.csv' (HEADER, DELIMITER ',');"
done

# export exchanges
$DUCKDB "COPY (SELECT * FROM exchanges ORDER BY nb_indices+nb_equities DESC) TO './database/.export/exchanges.csv' (HEADER, DELIMITER ',');"

# # Convert to CFWF
deno run -A scripts/typescript/export.ts
