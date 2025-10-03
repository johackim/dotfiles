#!/bin/bash

file=$1

# Check if file exists
if [ ! -f "$file" ]; then
    echo "File not found!"
    exit 1
fi

# Remove frontmatter empty lines
sed -i '/^---$/,/^---$/{/^$/d}' $file

# Remove Kanban settings
sed -i '/^%% kanban:settings/,/^%%$/d' $file

# Remove empty lines
sed -i '/^$/N;/^\n$/D' $file

# Remove empty lines at the end of the file
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' $file
perl -i -pe "chomp if eof" $file
