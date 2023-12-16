#!/usr/bin/env bash

IMPORT="./database/.import"
MARKET="XAMS XBRU XDUB XLIS XOSL XPAR"

function download_equities() {
  market=$1
  SRCEURONEXT="$IMPORT/src_euronext_equities_${market}.csv"
  DSTEURONEXT="$IMPORT/euronext_equities_${market}.csv"

  if [ ! -f "$SRCEURONEXT" ]; then
    echo "Downloading euronext $market equities"
    curl -s -o "$SRCEURONEXT" -X POST \
    "https://live.euronext.com/pd_es/data/stocks/download?mics=${market}" \
    -d 'iDisplayLength=100&iDisplayStart=0&args%5BinitialLetter%5D=&args%5Bfe_type%5D=csv&args%5Bfe_decimal_separator%5D=.&args%5Bfe_date_format%5D=d%2Fm%2FY'
  fi

  # Remove european comments
  sed -n '/;/p' "$SRCEURONEXT" > "$DSTEURONEXT"
}

for market in $MARKET; do
  download_equities "$market"
done

# echo "Importing euronext equities"
# duckdb duckdb < scripts/sql/exchanges/euronext/equities.sql
