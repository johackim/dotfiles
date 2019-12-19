#!/bin/bash
#
# Scans the given directory and all subdirectories for the file
# "metadata.opf". This file is created by Calibre. From this file data will be
# written into the PDFs, which are exactly in the same directory.
# 
# 
#  REQUIREMENTS: calibre by KOVID GOYAL (http://calibre-ebook.com/)
# 



shopt -s nullglob
shopt -s nocaseglob


write_metadata() {
  find "$1" -depth -type f -name "metadata.opf" | { while read -r metadata_path;
    do
      echo "metadata found: $metadata_path"
      dir_name=$(dirname "$metadata_path")

      pdfs=$(find "$dir_name" -maxdepth 1 -type f -name '*.pdf' | wc -l)

      echo "pdfs found: $pdfs"

      find "$dir_name" -maxdepth 1 -type f -name "*.pdf" | { while read -r pdf_path;
        do
          ebook-meta --from-opf="$metadata_path" "$pdf_path" 2>/dev/null
        done
        echo
      }
    done
  }
}

[[ -z "$1" ]] && logError "Please specify a start directory." && exit 1

if [ -f "$1" ]
then
  search_path=$(dirname "$1")
else
  search_path="$1"
fi

write_metadata "$search_path"

exit 0
