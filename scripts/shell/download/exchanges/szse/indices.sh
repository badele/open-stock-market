#!/usr/bin/env bash

IMPORT="./database/.import"

SRCSZSE="$IMPORT/src_szse_indices.xlsx"
DSTSZSE="$IMPORT/szse_indices.csv"

source ./scripts/shell/tools.sh

if is_not_cached "$SRCSZSE"; then
  echo "Downloading szse indices"

  curl -s -o "$SRCSZSE" "https://www.szse.cn/api/report/ShowReport?SHOWTYPE=xlsx&CATALOGID=1954"
fi

xlsx2csv "$SRCSZSE" > "$DSTSZSE"
