#!/bin/bash

if [ $# -ne 3 ]; then
    echo $0: 'usage: StockScraper stocklist.txt start[month-day-year] end[month-day-year]'
    exit 1
fi

m=`echo $2 | cut -d"-" -f1`
d=`echo $2 | cut -d"-" -f2`
y=`echo $2 | cut -d"-" -f3`

m2=`echo $3 | cut -d"-" -f1`
d2=`echo $3 | cut -d"-" -f2`
y2=`echo $3 | cut -d"-" -f3`

read -r x<"$1"

curl -s "http://chart.finance.yahoo.com/table.csv?s=$x&a=$m&b=$d&c=$y&d=$m2&e=$d2&f=$y2&g=d&ignore=.csv" |
awk -F "," '{print $1}' > 1.temp

for stock in `cat $1` ;
	do
	curl -s "http://chart.finance.yahoo.com/table.csv?s=$stock&a=$m&b=$d&c=$y&d=$m2&e=$d2&f=$y2&g=d&ignore=.csv" |
	awk -F "," '{print $7}' |
	sed "s/Adj Close/$stock/g" > "$stock.temp" ;
	done &&
paste *.temp >> out.txt &&
rm *.temp
