#!/bin/bash

# check if the html file name is provided as an argument
if [ -z "$1" ]
then
    echo "Please provide the HTML file name as an argument."
    exit 1
fi

# determine the corresponding txt file name
txt_file="${1%.*}.txt"

# extract text from html file and save to txt file
cat "$1" | sed 's/<[^>]*>/\n/g' > "$txt_file"
