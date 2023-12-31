#!/usr/bin/env bash


###############################################################################
# Init
###############################################################################
echo "Init database"
rm -f duckdb && duckdb duckdb < scripts/sql/_init.sql

DATAS="init functions"
for file in $DATAS; do
  FILE="scripts/sql/_${file}.sql"
  echo "Execture $FILE"
  duckdb duckdb < "$FILE"
done

###############################################################################
# Import
###############################################################################
DATAS="commons exchanges"
for data in $DATAS; do
  FILES=$(find "scripts/sql/${data}" -maxdepth 1 -name "*.sql")
  for file in $FILES; do
    echo "Import ${file}"
    duckdb duckdb < "${file}"
  done
done

###############################################################################
# Update
###############################################################################
echo "Update tables"
duckdb duckdb < scripts/sql/_update.sql

###############################################################################
# Check
###############################################################################
echo "Check datas"
duckdb duckdb < scripts/sql/_check.sql

