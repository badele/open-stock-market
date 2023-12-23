#!/usr/bin/env bash

SRCNASDAQ="./database/.import/nasdaq_equities.json"
DSTNASDAQ="./database/.import/nasdaq_equities.csv"

source ./scripts/shell/tools.sh

if is_not_cached "$SRCNASDAQ"; then
  echo "Downloading nasdaq equities"
  curl -s -o "$SRCNASDAQ" 'https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=25&offset=0&download=true' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36'
fi

jq -r '.data.headers | keys | @csv' "$SRCNASDAQ" > "$DSTNASDAQ"
jq -r '.data.rows[] | [ .country,.industry,.ipoyear,.lastsale,.marketCap,.name,.netchange,.pctchange,.sector,.symbol,.url,.volume ] | @csv' "$SRCNASDAQ" >> "$DSTNASDAQ"
