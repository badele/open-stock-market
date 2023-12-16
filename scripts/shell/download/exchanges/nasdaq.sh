#!/usr/bin/env bash

SCRIPTS="indices equities"

for scripts in $SCRIPTS; do
  "./scripts/shell/download/exchanges/nasdaq/${scripts}.sh"
done
