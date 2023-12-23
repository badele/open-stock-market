#!/usr/bin/env bash

SRCICB="./database/.import/sectors_icb.xlsx"
DSTICB="./database/.import/sectors_icb.csv"

if [ ! -f "$SRCICB" ]; then
  echo "Downloading ICB"
  curl -s -o "$SRCICB" 'https://www.lseg.com/content/dam/ftse-russell/en_us/documents/other/icb-structure-and-definitions.xlsx'
fi

xlsx2csv "$SRCICB" > "$DSTICB"
