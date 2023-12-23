#!/usr/bin/env bash

SRCSTOCK="./database/.import/equities-sec.json"
DSTSTOCK="./database/.import/equities-sec.csv"

echo "Downloading sec"

curl -s -o "$SRCSTOCK" 'https://www.sec.gov/files/company_tickers.json' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
  --compressed

echo "symbol,name" > "$DSTSTOCK"
jq -r '.[] | [ .ticker, .title ] | @csv' < "$SRCSTOCK" >> "$DSTSTOCK"  

echo "Importing sec"
duckdb duckdb < scripts/sql/equities-sec-importer.sql
