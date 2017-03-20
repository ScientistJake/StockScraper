#!/bin/bash

if [ $# -ne 4 ]; then
    echo $0: ;
    printf 'usage: Stockscraper stocklist start[month-day-year] end[month-day-year] output_prefix' ;
    printf "\nYou can also designate NYSE or AMEX or NASDAQ in place of stocklist to pull all stocks from that exchange\n" ;
    exit 1
fi

# Pull the correct stock
if [[ $1 == 'NASDAQ' ]]; then
	x=$(curl -s 'http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nasdaq&render=download' |
	awk -F "," '{print $1}' |
	tr -d '"' |
	tr -d 'Symbol')
fi
if [[ $1 == 'NYSE' ]]; then
	x=$(curl -s 'http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nyse&render=download' |
	awk -F "," '{print $1}' |
	tr -d '"' |
	tr -d 'Symbol')
fi
if [[ $1 == 'AMEX' ]]; then
	x=$(curl -s 'http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=amex&render=download' |
	awk -F "," '{print $1}' |
	tr -d '"' |
	tr -d 'Symbol')
fi

if [[ "$1" != "NASDAQ" && "$1" != "NYSE" && "$1" != "AMEX" ]]; then
	x=$(cat "$1")
fi
	
#parse the input dates
m=`echo $2 | cut -d"-" -f1`
d=`echo $2 | cut -d"-" -f2`
y=`echo $2 | cut -d"-" -f3`

m2=`echo $3 | cut -d"-" -f1`
d2=`echo $3 | cut -d"-" -f2`
y2=`echo $3 | cut -d"-" -f3`

#This grabs data for YHOO and uses it to populate $4.csv table with the dates.
curl -s "http://chart.finance.yahoo.com/table.csv?s=YHOO&a=$m&b=$d&c=$y&d=$m2&e=$d2&f=$y2&g=d&ignore=.csv" |
#field one is the dates
awk -F "," '{print $1}' > "$4.csv"

#loop through the stock list, download the data, parse it, field 7 is the close price, rename the column as the stock and paste it to the table.
for stock in $x ;
	do
	echo "Grabbing $stock..."
	curl -s "http://chart.finance.yahoo.com/table.csv?s=$stock&a=$m&b=$d&c=$y&d=$m2&e=$d2&f=$y2&g=d&ignore=.csv" |
	awk -F "," '{print $7}' |
	sed "s/Adj Close/$stock/g" |
	paste -d , "$4.csv" - >temp;
	cp temp "$4.csv";
	done &&

#clean up	
rm temp

