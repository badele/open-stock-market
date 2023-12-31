#!/usr/bin/env bash

# Telecommunications sectors
echo ""
echo "Summary exchange"
duckdb duckdb "select * from exchanges;"

echo ""
echo "Summary all industry"
duckdb duckdb "pivot (select market,industry,\"count_star()\" as nb from v_sectors where industry is not null) ON industry USING sum(nb);"

echo ""
echo "Summary industry with history"
duckdb duckdb "PIVOT  (select industry,market from v_symbols where lastdate is not null) ON industry" 
