#!/usr/bin/env bash

MINYEAR=5;

# Generate report for all industries
duckdb duckdb "CREATE OR REPLACE TABLE tocompute as SELECT 'ALLINDUSTRY' AS id,date,avg(indice100) AS value FROM f_table_indice100_symbols_history(5000) GROUP BY ALL ORDER BY id,date"
duckdb duckdb -csv -noheader -nullvalue "?" "select * from tocompute" > "database/.export/duckdb_ALLINDUSTRY.txt"
duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_sma(365)" > "database/.export/duckdb_ALLINDUSTRY_sma365.txt"
duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_sma(90)" > "database/.export/duckdb_ALLINDUSTRY_sma90.txt"
duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_macd(90,365)" > "database/.export/duckdb_ALLINDUSTRY_macd90.txt"
rm -f report/ALLINDUSTRY.png;  gnuplot -e "vid='ALLINDUSTRY'; vfile='ALLINDUSTRY'; vtitle='All industry'" scripts/gnuplot/color_grafana.plt scripts/gnuplot/sectors.plt

# Generate report for each industries
duckdb duckdb "CREATE OR REPLACE TABLE tocompute as SELECT industry AS id,date,avg(indice100) AS value FROM f_table_indice100_symbols_history(5000) GROUP BY ALL ORDER BY id,date"
INDUSTRIES=$(duckdb duckdb -list -noheader "select distinct id from tocompute")

IFS=$'\n' 
for industry in $INDUSTRIES; do
  SLUG="${industry// /_}"
  ID=$industry
  TITLE="$ID sectors"

  echo "Analyse $ID industry"
  # duckdb duckdb -csv -noheader -nullvalue "?" "select * from tocompute where id='${ID}'" > "database/.export/duckdb_${SLUG}.txt"
  # duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_sma(365) where id='${ID}'" > "database/.export/duckdb_${SLUG}_sma365.txt"
  # duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_sma(90) where id='${ID}'" > "database/.export/duckdb_${SLUG}_sma90.txt"
  # duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_macd(90,365) where id='${ID}'" > "database/.export/duckdb_${SLUG}_macd90.txt"

  duckdb duckdb -csv -noheader -nullvalue "?" "select * from tocompute where id='${ID}'" > "database/.export/duckdb_${SLUG}.txt"
  duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_sma(365) where id='${ID}'" > "database/.export/duckdb_${SLUG}_sma365.txt"
  duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_sma(90) where id='${ID}'" > "database/.export/duckdb_${SLUG}_sma90.txt"
  duckdb duckdb -csv -noheader -nullvalue "?" "select * from f_indicator_macd(90,365) where id='${ID}'" > "database/.export/duckdb_${SLUG}_macd90.txt"

  # Create chart
  rm -f report/${SLUG}.png;  gnuplot -e "vid='$ID'; vfile='${SLUG}'; vtitle='$TITLE'" scripts/gnuplot/color_grafana.plt scripts/gnuplot/sectors.plt
done

convert report/sector_* -append report/sectors_fullsize.png
convert  report/sectors_fullsize.png -scale 60%  report/sectors.png

# for industry in $INDUSTRIES; do
#   geeqie -t --fullscreen "report/sector_${SLUG}.png"
# done

exit 0

# Air liquide
ID=12436277544525145948
TITLE="Air liquide"
duckdb duckdb "CREATE OR REPLACE TABLE tocompute as select symbolid as id ,date,close from symbols_history"
duckdb duckdb -column -noheader -nullvalue "?" "select * from tocompute where id=${ID}" > database/.export/duckdb_${ID}.txt
duckdb duckdb -column -noheader -nullvalue "?" "select * from f_indicator_sma(365) where id=${ID}" > database/.export/duckdb_${ID}_sma365.txt
duckdb duckdb -column -noheader -nullvalue "?" "select * from f_indicator_sma(90) where id=${ID}" > database/.export/duckdb_${ID}_sma90.txt
duckdb duckdb -column -noheader -nullvalue "?" "select * from f_indicator_macd(90,365) where id=${ID}" > database/.export/duckdb_${ID}_macd90.txt

rm test.png;  gnuplot -e "vtitle='$TITLE'" scripts/gnuplot/color_grafana.plt equities.plt ; geeqie -t --fullscreen test.png
