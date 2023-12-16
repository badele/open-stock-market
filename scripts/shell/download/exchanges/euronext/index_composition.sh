#!/usr/bin/env bash

TITLE="  Euronext"
IMPORT="./database/.import"
INDICES="PX1 PX4"

function download_composition() {
  indice=$1
  SRCEURONEXT="$IMPORT/src_euronext_index_composition_${indice}.html"
  DSTEURONEXT="$IMPORT/euronext_index_composition_${indice}.csv"

  if [ ! -f "$SRCEURONEXT" ]; then
    echo "$TITLE - Downloading index composition for ${indice}"
    URL=$(duckdb duckdb  "select url from \"v_euronext_helper_index_composition\" where symbol=='${indice}'" -csv -noheader)
    curl -s -o "$SRCEURONEXT" "$URL"
  fi

  # echo "$TITLE - Cleaning index composition for ${indice}"
  grep -oE "[A-Z]{2}[0-9]{10}" "$SRCEURONEXT" | sort | uniq > "$DSTEURONEXT"
}

for indice in $INDICES; do
  download_composition "$indice"
done

# echo "$TITLE - Importing index composition"
# duckdb duckdb < scripts/sql/exchanges/euronext/index_composition.sql
