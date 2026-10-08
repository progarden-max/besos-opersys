#!/bin/bash

verbose=0
outfile=""

while getopts "hvo:" opt; do
	case $opt in
		h)
			cat <<EOF
Usage: $0 [-h] [-v] [-o file] operator num1 num2 ...
Operations: add, sub, mul, div, pow
EOF
			exit 0
			;;
		v) verbose=1 ;;
		o) outfile="$OPTARG" ;;
		\?)
			echo "Option -$OPTARG need argument" >&2
			exit 1
			;;
		esac
done

shift $((OPTIND - 1))
op="${1:-add}"
shift
if [ -n "$outfile" ]; then
	exec > "$outfile"
fi
result=0
first=1
for num in "$@"; do
	if ! [[ "$num" =~ ^-?[0-9]+$ ]]; then
		echo "No number: $num" >&2
		continue
	fi
	if [ $first -eq 1 ]; then
		result=$num
		first=0
		[ $verbose -eq 1 ] && echo "First encounter: $result" >&2
		continue
	fi
	case $op in
		add) result=$((result + num)) ;;
		sub) result=$((result - num)) ;;
		mul) result=$((result * num)) ;;
		div)
			if [ "$num" -eq 0 ]; then
				echo "Impossible" >&2
				continue
			fi
			result=$((result / num))
			;;
		pow) result=$((result ** num)) ;;
		*) 
			echo "Unknown operation: $op" >&2
			exit 1
			;;
	esac
	[ $verbose -eq 1 ] && echo "-> $result" >&2
done
echo "Result: $result"
