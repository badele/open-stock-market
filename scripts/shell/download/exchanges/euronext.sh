#!/usr/bin/env bash

SCRIPTS="indices equities index_composition industry_composition equities_history"

for scripts in $SCRIPTS; do
  "./scripts/shell/download/exchanges/euronext/${scripts}.sh"
done
