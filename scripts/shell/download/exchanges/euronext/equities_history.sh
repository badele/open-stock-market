#!/usr/bin/env bash

IMPORT="./database/.import"

INDICES="XPAR:PX1 XPAR:PX4 XPAR:CACT"

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

function download_index_composition() {
  market=$(echo "$1" | cut -d':' -f1)
  index=$(echo "$1" | cut -d':' -f2)
  URLS=$(duckdb duckdb  "select isin, market, url from v_euronext_helper_url_history INNER JOIN euronext_index_compositions USING(ISIN) where market='${market}' AND index='${index}' ORDER BY random()" -csv -noheader)
  for URL in $URLS; do
    download_equities_history "$URL"
  done
}

for symbol in $INDICES; do
  download_index_composition "$symbol"
done
