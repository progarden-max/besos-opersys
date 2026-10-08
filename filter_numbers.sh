#!/bin/bash

> even.txt
> odd.txt

count=0

for num in "$@"; do
	if ! [[ "$num" =~ ^-?[0-9]+$ ]]; then
		continue
	fi
	count=$((count+1))
	if (( num % 3 == 0 )); then
		continue
	fi
	if (( num % 2 == 0 )); then
		echo "$num" >> even.txt
	else
		echo "$num" >> odd.txt
	fi
done
echo "Analyzed numbers: $count"
