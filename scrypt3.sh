#!/bin/bash

while IFS= read -r line; do
	if [[ "$line" =~ (^| [^[:alnum:]_])bin([^[:alnum:]_]|$) ]]; then
		echo "$line" >&2
	fi
done
