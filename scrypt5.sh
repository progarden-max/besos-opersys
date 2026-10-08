#!/bin/bash

cd ~
find . -type f -exec md5sum {} + 2>/dev/null \
|sort \
| awk '
{
	hash = $1
	file = $2
	if (hash == prev_hash) {
		if (!counted[hash]++) print " " prev_file
		print " " file
		count[hash]++
	}
	prev_hash = hash
	prev_file = file
}
END {
	total = 0
	for (h in count) total += count[h]
	print "At all: " total
}'
