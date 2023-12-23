#!/usr/bin/env bash

IMPORT="./database/.import"

source ./scripts/shell/tools.sh

SRCEURONEXT="$IMPORT/src_euronext_equities.csv"
DSTEURONEXT="$IMPORT/euronext_equities.csv"

if is_not_cached "$SRCEURONEXT"; then
echo "Downloading euronext equities"
    curl -s -o "${SRCEURONEXT}" -X POST \
    'https://live.euronext.com/pd_es/data/stocks/download?mics=dm_all_stock' \
    -d 'iDisplayLength=100&iDisplayStart=0&args%5BinitialLetter%5D=&args%5Bfe_type%5D=csv&args%5Bfe_decimal_separator%5D=.&args%5Bfe_date_format%5D=d%2Fm%2FY'
fi

# Remove euronext comments
sed '/;/!d' "$SRCEURONEXT" > "$DSTEURONEXT"
