#!/usr/bin/env bash

INDICES="PX1 PX4"

function download_history() {
  indice=$1
  SRCEURONEXT="$IMPORT/src_euronext_index_history_${indice}.json"
  DSTEURONEXT="$IMPORT/euronext_index_history_${indice}.csv"

  if [ ! -f "$SRCEURONEXT" ]; then
    echo "$TITLE - Downloading index history for ${indice}"
    URL=$(duckdb duckdb  "select url from \"v_euronext_helper_index_history\" where symbol=='${indice}'" -csv -noheader)
    echo curl -s -o "$SRCEURONEXT" "$URL"
  fi

  echo "$TITLE - Cleaning index history for ${indice}"
  grep -oE "[A-Z]{2}[0-9]{10}" "$SRCEURONEXT" | sort | uniq > "$DSTEURONEXT"
}

for indice in $INDICES; do
  download_history "$indice"
done

# echo "$TITLE - Importing index history"
# duckdb duckdb < scripts/sql/euronext/index_history.sql

