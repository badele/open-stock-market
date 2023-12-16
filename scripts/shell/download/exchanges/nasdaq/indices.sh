#!/usr/bin/env bash

MAXLINES=200
IMPORT="./database/.import"

function download_index() {
  page=$1
  SRCNASDAQ="$IMPORT/src_nasdaq_indices_${page}.json"
  DSTNASDAQ="$IMPORT/nasdaq_indices_${page}.csv"

  if [ ! -f "$SRCNASDAQ" ]; then
    echo "Downloading nasdaq indices page($page)"

   curl -s -o "$SRCNASDAQ" \
   -H 'accept: application/json, text/plain, */*' \
   -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/116.0.0.0 Safari/537.36' \
   "https://api.nasdaq.com/api/screener/index?offset=$page" 
  fi

  echo "symbol,name" > "$DSTNASDAQ"
  grep rows "$SRCNASDAQ" > /dev/null && jq -r '.data.records.data.rows[] | [ .symbol, .companyName ] | @csv' < "$SRCNASDAQ" >> "$DSTNASDAQ" 
}

for page in $(seq 0 50 $MAXLINES); do
  download_index "$page"
done

# echo "Importing nasdaq indices"
# duckdb duckdb < scripts/sql/exchanges/nasdaq/indices.sql

