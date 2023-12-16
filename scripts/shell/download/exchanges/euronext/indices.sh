#!/usr/bin/env bash

IMPORT="./database/.import"
# Euronext
MARKET="XAMS XBRU XDUB XLIS XOSL XPAR"
# # Euronext Growth
# MARKET="$MARKET ALXB ALXL XESM EXGM MERK ALXP"
# # Euronext Access 
# MARKET="$MARKET MLXB  ENXL XMLI"

function download_index() {
  market=$1
  SRCEURONEXT="$IMPORT/src_euronext_indices_${market}.csv"
  DSTEURONEXT="$IMPORT/euronext_indices_${market}.csv"

  if [ ! -f "$SRCEURONEXT" ]; then
    echo "Downloading euronext $market indices"
    curl -s -o "$SRCEURONEXT" -X POST \
    "https://live.euronext.com/pd/data/index/download?mics=${market}&display_datapoints=dp_index&display_filters=df_index2" \
    -d 'iDisplayLength=100&iDisplayStart=0&args%5BinitialLetter%5D=&args%5Bfe_type%5D=csv&args%5Bfe_layout%5D=ver&args%5Bfe_decimal_separator%5D=.&args%5Bfe_date_format%5D=d%2Fm%2FY'
  fi

  #Remove non unicode/UTF8 and ^M Carriage Return
  grep -ax '.*' "$SRCEURONEXT" > "$DSTEURONEXT"
  sed -i 's/^.*\r//' "$DSTEURONEXT"
}

for market in $MARKET; do
  download_index "$market"
done

# echo "Importing euronext indices"
# duckdb duckdb < scripts/sql/exchanges/euronext/indices.sql
