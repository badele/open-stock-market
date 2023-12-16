#!/usr/bin/env bash

SCRIPTS="indices equities index_composition"

for scripts in $SCRIPTS; do
  "./scripts/shell/download/exchanges/euronext/${scripts}.sh"
done
