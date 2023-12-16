#!/usr/bin/env bash

SCRIPTS="indices"

for scripts in $SCRIPTS; do
  "./scripts/shell/download/exchanges/sse/${scripts}.sh"
done
