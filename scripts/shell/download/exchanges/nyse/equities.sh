#!/usr/bin/env bash

MAXPAGE=5
MAXRESULTSPERPAGE=500
IMPORT="./database/.import"

source ./scripts/shell/tools.sh

function download_index() {
  page=$1
  SRCNYSE="$IMPORT/src_nyse_equities_${page}.json"
  DSTNYSE="$IMPORT/nyse_equities_${page}.csv"

  if is_not_cached "$SRCNYSE"; then
    echo "Downloading nyse equities page($page)"

   curl -s -o "$SRCNYSE" \
   -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
   -H 'Content-Type: application/json' \
   -X POST https://www.nyse.com/api/quotes/filter \
   -d "{\"instrumentType\":\"EQUITY\",\"pageNumber\":$page,\"sortColumn\":\"NORMALIZED_TICKER\",\"sortOrder\":\"ASC\",\"maxResultsPerPage\":$MAXRESULTSPERPAGE,\"filterToken\":\"\"}"
  fi

  echo "symbol,name,market" > "$DSTNYSE"
  jq -r '.[] | [ .normalizedTicker, .instrumentName, .micCode ] | @csv' < "$SRCNYSE" >> "$DSTNYSE"  
}

for page in $(seq $MAXPAGE); do
  download_index "$page"
done
