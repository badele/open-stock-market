#! /usr/bin/env bash

IMPORT="./database/.import"

if [ ! -f "$IMPORT/market_tmp.csv" ]; then
  curl -s https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC.csv -o $IMPORT/market_tmp.csv
  
  # remove non unicode/UTF
  grep -ax '.*' $IMPORT/market_tmp.csv > $IMPORT/market.csv
fi

# echo "Importing market"
# duckdb duckdb < scripts/sql/markets.sql
