#!/usr/bin/env bash

mkdir -p ./database/.import ./database/.export/{indices,equities}

###############################################################################
# Commons
###############################################################################
COMMONS="markets lei"
for common in $COMMONS; do
  "./scripts/shell/download/${common}.sh"
done

###############################################################################
# Exchanges
###############################################################################
EXCHANGES="euronext nasdaq nyse sse szse"
for exchange in $EXCHANGES; do
  "./scripts/shell/download/exchanges/${exchange}.sh"
done
