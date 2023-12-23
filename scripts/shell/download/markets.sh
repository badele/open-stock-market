#! /usr/bin/env bash

IMPORT="./database/.import"

if [ ! -f "$IMPORT/markets_tmp.csv" ]; then
  curl -s https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC.csv -o $IMPORT/markets_tmp.csv

  # remove non unicode/UTF
  grep -ax '.*' $IMPORT/markets_tmp.csv > $IMPORT/markets.csv
fi
