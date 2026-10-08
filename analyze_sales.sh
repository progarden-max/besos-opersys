#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 sales.csv" >&2
	exit 1
fi
CSV="$1"
if [ ! -f "$CSV" ]; then
	echo "Not found: $CSV" >&2
	exit 1
fi
awk -F, 'NR>1 {
	sum += $2
	if ($2 > max) max = $2
	count++
}
END {
	print "At all sales: " sum
	print "Average cost: " sum/count
	print "The most powerful sale: " max
}' "$CSV" | tee sales_report.txt
