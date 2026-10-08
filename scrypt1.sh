#!/bin/bash

LOG=/tmp/run.log
if [ -f "$LOG" ]; then
	prev=$(wc -l < "$LOG")
else
	prev=0
fi
date >> "$LOG"
echo "Hello, World!"
echo "Previous bashings: $prev" >&2
