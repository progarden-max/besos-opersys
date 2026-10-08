#!/bin/bash

cd ~
echo "List of txt files"
ls *.txt 2>/dev/null
echo "Size of bytes"
du -cb *.txt 2>/dev/null | tail -1
echo "Quantity of lines"
wc -l *.txt 2>/dev/null | tail -1
