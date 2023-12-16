#! /usr/bin/env bash

IMPORT="./database/.import"

###############################################################################
# ISIN
###############################################################################

if [ ! -f "$IMPORT/lei-isin.zip" ]; then
  echo "Downloading ISIN"
  ISINRELATION=$(curl -s https://www.gleif.org/fr/lei-data/lei-mapping/download-isin-to-lei-relationship-files | pup 'table > tbody > tr:nth-child(2) > td:nth-child(2) > a' | grep -oE "http.*download")
  curl -s "$ISINRELATION" -o $IMPORT/lei-isin.zip
  unzip -o $IMPORT/lei-isin.zip -d $IMPORT
fi
###############################################################################
# BIC
###############################################################################

if [ ! -f "$IMPORT/lei-bic.zip" ]; then
  echo "Downloading BIC"
  BICRELATION=$(curl -s https://www.gleif.org/fr/lei-data/lei-mapping/download-bic-to-lei-relationship-files | pup 'table > tbody > tr:nth-child(2) > td:nth-child(2) > a' | grep -oE "http.*download")
  curl -s "$BICRELATION" -o $IMPORT/lei-bic.zip
  unzip -o $IMPORT/lei-bic.zip -d $IMPORT
fi

###############################################################################
# MIC
###############################################################################

if [ ! -f "$IMPORT/lei-mic.zip" ]; then
  echo "Downloading MIC"
  MICRELATION=$(curl -s https://www.gleif.org/fr/lei-data/lei-mapping/download-mic-to-lei-relationship-files | pup 'table > tbody > tr:nth-child(2) > td:nth-child(2) > a' | grep -oE "http.*download")
  curl -s "$MICRELATION" -o $IMPORT/lei-mic.zip
  unzip -o $IMPORT/lei-mic.zip -d $IMPORT
fi

###############################################################################
# OCo
###############################################################################

if [ ! -f "$IMPORT/lei-oc.zip" ]; then
  echo "Downloading OC"
  OCRELATION=$(curl -s https://www.gleif.org/fr/lei-data/lei-mapping/download-oc-to-lei-relationship-files | pup 'table > tbody > tr:nth-child(2) > td:nth-child(2) > a' | grep -oE "http.*download")
  curl -s "$OCRELATION" -o $IMPORT/lei-oc.zip
  unzip -o $IMPORT/lei-oc.zip -d $IMPORT
fi

###############################################################################
# LEI
###############################################################################

if [ ! -f "$IMPORT/lei.zip" ]; then
  echo "Downloading LEI"
  LEI=$(curl -s 'https://leidata-preview.gleif.org/api/v2/golden-copies/publishes?page=1&per_page=1' | jq -r ".data[0].lei2.full_file.csv.url")
  curl -s "$LEI" -o $IMPORT/lei.zip
  unzip -o $IMPORT/lei.zip -d $IMPORT
fi

# echo "Importing LEI"
# duckdb duckdb < scripts/sql/lei.sql
