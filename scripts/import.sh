#!/usr/bin/env bash

DATAS="commons exchanges"

###############################################################################
# Init
###############################################################################
echo "Init database"
duckdb duckdb < scripts/sql/_init.sql

###############################################################################
# Import
###############################################################################
for data in $DATAS; do
  FILES=$(find "scripts/sql/${data}" -maxdepth 1 -name "*.sql")
  for file in $FILES; do
    echo "Import ${file}"
    duckdb duckdb < "${file}"
  done
done

###############################################################################
# Import
###############################################################################
echo "Update tables"
duckdb duckdb < scripts/sql/_update.sql

