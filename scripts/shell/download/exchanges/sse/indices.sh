#!/usr/bin/env bash

IMPORT="./database/.import"

SRCSSE="$IMPORT/src_sse_indices.json"
DSTSSE="$IMPORT/sse_indices.csv"

source ./scripts/shell/tools.sh

if is_not_cached "$SRCSSE"; then
  echo "Downloading sse indices"

  curl -s -o "$SRCSSE" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
  -H 'Accept: */*' -H 'Referer: http://english.sse.com.cn/' \
  'http://query.sse.com.cn/commonSoaQuery.do?jsonCallBack=jsonpCallback27245&isPagination=false&sqlId=DB_SZZSLB_ZSLB&_=1702330934505'

  sed -i "s/jsonpCallback27245(//" "$SRCSSE"
  sed -i 's/})/}/' "$SRCSSE"
fi

echo "symbol,name,fullname" > "$DSTSSE"
jq -r ''.pageHelp.data[]' | [ .indexCode, .indexNameEn, .indexFullNameEn ] | @csv' < "$SRCSSE" >> "$DSTSSE"  
