#!/usr/bin/env bash

TITLE="  Euronext"
IMPORT="./database/.import"
INDUSTRIES="10 15 20 30 35 40 45 50 55 60 65"

source ./scripts/shell/tools.sh

function download_composition() {
  industry=$1
  SRCEURONEXT="$IMPORT/src_euronext_industry_composition_${industry}.csv"
  DSTEURONEXT="$IMPORT/euronext_industry_composition_${industry}.csv"
 
  if is_not_cached "$SRCEURONEXT"; then
    echo "$TITLE - Downloading industry composition for ${industry}"
    ARGS=$(duckdb duckdb  "select * from \"v_euronext_helper_sectors_icb\" where \"industry code\"=${industry}" -list -noheader | cut -d'|' -f2)
    curl -s -o "${SRCEURONEXT}" -X POST \
    'https://live.euronext.com/pd_es/data/stocks/download?mics=dm_all_stock' \
    -d "iDisplayLength=100&iDisplayStart=0&args%5Bindustry%5D=${industry}&args%5Bsector%5D=${ARGS}&args%5BinitialLetter%5D=&args%5Bfe_type%5D=csv&args%5Bfe_decimal_separator%5D=.&args%5Bfe_date_format%5D=d%2Fm%2FY"
  fi
  sed '/;/!d' "$SRCEURONEXT" > "$DSTEURONEXT"

}

for industry in $INDUSTRIES; do
  download_composition "$industry"
done
