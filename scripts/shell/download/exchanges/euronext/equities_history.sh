#!/usr/bin/env bash

IMPORT="./database/.import"

SYMBOLS="XPAR:Telecommunications"

source ./scripts/shell/tools.sh

function download_equities_history() {
  URL=$1
  isin=$(echo "$URL" | cut -d',' -f1)
  market=$(echo "$URL" | cut -d',' -f2)
  url=$(echo "$URL" | cut -d',' -f3)
  SRCEURONEXT="$IMPORT/src_euronext_equities_history_${isin}.json"
  DSTEURONEXT="$IMPORT/euronext_equities_history_${isin}.csv"
  if is_not_cached "$SRCEURONEXT"; then
    echo "$TITLE - Downloading symbol history for ${isin}"
    curl -s -o "$SRCEURONEXT" "$url"
    sleep $((1 + $RANDOM % 12))
  fi

  jq -r "[\"market\", \"time\", \"price\",\"volume\"], (.[] | [ \"${market}\", .time, .price, .volume ]) | @csv" < "$SRCEURONEXT" > "$DSTEURONEXT"
}

function download_industry_composition() {
  market=$(echo "$1" | cut -d':' -f1)
  industry=$(echo "$1" | cut -d':' -f2)
  URLS=$(duckdb duckdb  "SELECT isin, market, url FROM v_euronext_helper_url_history WHERE market='${market}' AND industry='${industry}'" -csv -noheader)
  for URL in $URLS; do
    download_equities_history "$URL"
  done
}

for symbol in $SYMBOLS; do
  download_industry_composition "$symbol"
done
