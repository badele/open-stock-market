#!/usr/bin/env bash

IMPORT="./database/.import"

SRCSZSE="$IMPORT/src_szse_indices.xlsx"
DSTSZSE="$IMPORT/szse_indices.csv"

if [ ! -f "$SRCSZSE" ]; then
  echo "Downloading szse indices"

curl -s -o "$SRCSZSE" "https://www.szse.cn/api/report/ShowReport?SHOWTYPE=xlsx&CATALOGID=1954"
fi

xlsx2csv "$SRCSZSE" > "$DSTSZSE"

# echo "Importing szse indices"
# duckdb duckdb < scripts/sql/exchanges/szse/indices.sql

