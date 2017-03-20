# Stockscraper.sh
This bash script, given a file containing a list of symbols and a date range, pulls historical adjusted closing price stock data and outputs it to output_prefix.csv.  
## usage: 
Stockscraper stocklist[symbols] start_date[month-day-year] end_date[month-day-year] output_prefix 
-In place of stocklist you can now simply designate 'NYSE', 'AMEX', or 'NASDAQ' to pull stocks from those markets.
## Example 
Stockscraper NYSE 09-15-15 09-15-16 Makememoney
