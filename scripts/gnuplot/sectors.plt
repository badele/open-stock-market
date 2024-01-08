set datafile separator ';'

industrylist='database/.export/duckdb_industrylist.txt'
allindustry='database/.export/duckdb_ALLINDUSTRY.txt'
prices='database/.export/duckdb_' . vfile . '.txt'
summary='database/.export/duckdb_' . vfile . '_summary.txt'
# sma5='database/.export/duckdb_' . vfile . '_sma5.txt'
# sma10='database/.export/duckdb_' . vfile . '_sma10.txt'
# sma20='database/.export/duckdb_' . vfile . '_sma20.txt'
# sma50='database/.export/duckdb_' . vfile . '_sma50.txt'
# sma100='database/.export/duckdb_' . vfile . '_sma100.txt'
#
# sma365='database/.export/duckdb_' . vfile . '_sma365.txt'
# sma90='database/.export/duckdb_' . vfile . '_sma90.txt'
# macd2050='database/.export/duckdb_' . vfile . '_macd2050.txt'
# macd90='database/.export/duckdb_' . vfile . '_macd90.txt'

getindustry(x) = system('sed -n '.x.'p '.industrylist . ' | cut -d";" -f1')
nbequities(x) = system('grep "'.vid.'" ' . industrylist . ' | cut -d";" -f2')
getfilename(x) = system('sed -n '.x.'p '.industrylist . ' | cut -d";" -f3')
nbindustry = system('wc -l ' . industrylist )
getsummary = system('cat ' . summary )

# mindate=system("head -n 1 " . prices . " | awk '{print $2}'")
# mindate="2022-01-01"

# Define plot size and output file
set terminal pngcairo size 1920,1080 enhanced background rgb cbackground
set output 'report/sector_' . vfile . '.png'

# Style
set style data lines
set border lc rgb ctext
set key top left textcolor rgb ctext font ",10"
set title vid . ' ( ' . nbequities(vid) . ' equities)' textcolor rgb ctext font ',20'

# Grid
set style line 102 lc rgb cgrid lt 0 lw 1
set grid back ls 102

set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y %m"

# unset key
#set tics scale 0.75
# set xtics 31536000 rotate # by year
#set ytics 25
#set yrange[-100:100]
# set xrange[mindate:*]
set xlabel getsummary textcolor rgb ctext font ',10'
set ylabel 'Indice 100' textcolor rgb ctext font ',15'

###############################################################################
# Commons values
###############################################################################

set lmargin 9
set rmargin 2

###############################################################################
# Price graph
###############################################################################

# set multiplot
# set size 1, 0.7
# set origin 0, 0.3
# set bmargin 0
# set format x ""


# plot \
#     prices using 2:3 with lines ls 1 title "Price", \
#     allindustry using 2:3 with lines ls 1 lc rgb '#A05694F2' title "All industry", \
#     sma20 using 2:4 with lines ls 16 title "SMA 20", \
#     sma50 using 2:4 with lines ls 17 title "SMA 50", \
#     sma100 using 2:4 with lines ls 18 title "SMA 100", \
#     sma90 using 2:4 with lines ls 15 title "SMA 90", \
#     sma365 using 2:4 with lines ls 11 title "SMA 365", \
#     macd using 2:($4>0 ? $3 : 1/0) with filledcurves y2=0 lc rgb '#ee77BE69' notitle, \
#     macd using 2:($4<0 ? $3 : 1/0) with filledcurves y2=0 lc rgb '#eeF24865' notitle, \
#   for [i=1:nbindustry] 'database/.export/duckdb_'.getindustry(i).'.txt'  using 2:3 with lines ls 1 lc rgb '#f0ffffff' notitle

# plot \
#     prices using 2:3 with lines ls 1 title "Price", \
#     allindustry using 2:3 with lines ls 1 lc rgb '#A05694F2' title "All industry", \
#     sma20 using 2:4 with lines ls 16 title "SMA 20", \
#     sma50 using 2:4 with lines ls 17 title "SMA 50", \
#     sma100 using 2:4 with lines ls 18 title "SMA 100", \
#     sma90 using 2:4 with lines ls 15 title "SMA 90", \
#     sma365 using 2:4 with lines ls 11 title "SMA 365", \
#     macd2050 using 2:($4>0 ? $3 : 1/0) with filledcurves y2=0 lc rgb '#ee77BE69' notitle, \
#     macd2050 using 2:($4<0 ? $3 : 1/0) with filledcurves y2=0 lc rgb '#eeF24865' notitle, \
#     macd90 using 2:($4>0 ? $3 : 1/0) with filledcurves y2=0 lc rgb '#ee77BE69' notitle, \
#     macd90 using 2:($4<0 ? $3 : 1/0) with filledcurves y2=0 lc rgb '#eeF24865' notitle, \
#   for [i=1:nbindustry] 'database/.export/duckdb_'.getindustry(i).'.txt'  using 2:3 with lines ls 1 lc rgb '#f0ffffff' notitle

plot \
    prices using 1:2 skip 1 with lines ls 1 title "Price", \
    allindustry using 1:2 skip 1 with lines ls 1 lc rgb '#A05694F2' title "All industry", \
  for [i=1:nbindustry] 'database/.export/duckdb_'.getfilename(i).'.txt'  using 1:2 skip 1 with lines ls 1 lc rgb '#f0ffffff' notitle




# macd using 2:($4>0 ? $3 : 1/0) with filledcurves y1=0 lc rgb '#ee77BE69' notitle, \
# macd using 2:($4<0 ? $3 : 1/0) with filledcurves y1=0 lc rgb '#eeF24865' notitle, \

# Force yrange to be the same for all graphs
# set yrange[GPVAL_Y_MIN:GPVAL_Y_MAX]

# Draw a rectangle to highlight the MACD state
# plot \
# macd using 2:($4>0 ? $3 : 1/0) with filledcurves y1=0 lc rgb '#ee77BE69' notitle, \
# macd using 2:($4<0 ? $3 : 1/0) with filledcurves y1=0 lc rgb '#eeF24865' notitle, \
# macd using 2:($4>0 ? $3 : 1/0) with filledcurves y2=GPVAL_Y_MAX lc rgb '#ee77BE69' notitle, \
# macd using 2:($4<0 ? $3 : 1/0) with filledcurves y2=GPVAL_Y_MAX lc rgb '#eeF24865' notitle

# set size 1.0, 0.3
# set origin 0.0, 0.0

###############################################################################
# MACD graph
###############################################################################
# unset title
# set bmargin
# set tmargin 0
# set xlabel 'Year' textcolor rgb ctext font ',15'
# set ylabel 'MACD' textcolor rgb ctext font ',15'
# set format x "%Y"

# unset yrange

# plot \
# macd using 2:4:($4>0 ? 0x5694F2: 0xF24865) with impulse lc rgb variable title "MACD"
#
# plot \
# macd using 2:($4>0 ? $4 : 1/0) with filledcurves y2=GPVAL_Y_MIN lc rgb '#ee77BE69' notitle, \
# macd using 2:($4<0 ? $4 : 1/0) with filledcurves y2=GPVAL_Y_MIN lc rgb '#eeF24865' notitle, \
# macd using 2:($4>0 ? $4 : 1/0) with filledcurves y2=GPVAL_Y_MAX lc rgb '#ee77BE69' notitle, \
# macd using 2:($4<0 ? $4 : 1/0) with filledcurves y2=GPVAL_Y_MAX lc rgb '#eeF24865' notitle

# unset multiplot

