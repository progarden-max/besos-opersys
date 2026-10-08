#!/bin/bash

format="txt"
gen_sql=0
while getopts "f:g" opt; do
	case $opt in
		f) format="$OPTARG" ;;
		g) gen_sql=1 ;;
		\?) echo "Wrong option: -$OPTARG" >&2; exit 1 ;;
		:) echo "Option -$OPTARG need argument" >&2; exit 1 ;;
	esac
done
shift $((OPTIND - 1))

CSV="$1"
[ -z "$CSV" ] && { echo "Usage: $0 [-f csv] [-g] sales.csv" >&2; exit 1; }
[ ! -f "$CSV" ] && { echo "File not found: $CSV" >&2; exit 1; }

output=$(awk -F, 'NR>1
{
	sum += $2
	if ($2 > max) max = $2
	count++
}
END {
	printf "%s %s %.2f %s", sum, count, sum/count, max
}' "$CSV")

read total count avg max <<< "$output"

if [ "$format" = "csv" ]; then
	{
		echo "metric,value"
		echo "total,$total"
		echo "average,$avg"
		echo "max,$max"
	} | tee absolute_sales_report.csv
else
	{
		echo "Total sum: $total"
		echo "AVerage cost: $avg"
		echo "The most maximum sale: $max"
	} | tee absolute_sales_report.txt
fi

if [ $gen_sql -eq 1 ]; then
	{
		echo "CREATE TABLE IF NOT EXISTS sales ("
		echo "	product TEXT,"
		echo "	price NUMERIC"
		echo ");"
		echo ""
		echo "\\copy sales FROM 'absolute_sales_report.csv' WITH (FORMAT csv, HEADER true);"
	} > absolute_sales_report.sql
	echo "SQL completed"
fi

