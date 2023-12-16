#!/usr/bin/env bash

SCRIPTS="indices"

for scripts in $SCRIPTS; do
  "./scripts/shell/download/exchanges/szse/${scripts}.sh"
done

# duckdb duckdb < scripts/sql/exchanges/szse/_import.sql

