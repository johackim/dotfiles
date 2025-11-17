#!/bin/bash

CALIBRE_LIBRARY="$HOME/Calibre"
CALIBRE_DB="$CALIBRE_LIBRARY/metadata.db"

if pgrep -f calibre > /dev/null; then
    echo "Error: Calibre is currently running. Please close it before running this script."
    exit 1
fi

if [ ! -f "$CALIBRE_DB" ]; then
    echo "Error: Calibre database not found at $CALIBRE_DB"
    exit 1
fi

SQL_QUERY="SELECT b.id, b.title, (SELECT a.name FROM authors a JOIN books_authors_link bal ON a.id = bal.author WHERE bal.book = b.id LIMIT 1) FROM books b WHERE NOT EXISTS (SELECT 1 FROM identifiers i WHERE i.book = b.id AND i.type = 'goodreads')"

book_data=$(sqlite3 -separator '|' "$CALIBRE_DB" "$SQL_QUERY")

echo "$book_data" | while IFS='|' read -r book_id title author; do
    if [ "$author" == "Summaries.com" ]; then
        echo "Skipping Book ID $book_id: '$title' by '$author'"
        continue
    fi

    echo "Processing Book ID $book_id: '$title' by '$author'"

    echo "  Fetching Goodreads ID..."
    metadata=$(fetch-ebook-metadata -t "$title" -a "$author" -o 2> /dev/null)
    goodreads_id=$(echo $metadata | grep -oPi '<[^:>]+:identifier[^>]*\bopf:scheme\s*=\s*["\x27]\s*goodreads\s*["\x27][^>]*>\K[^<]+')

    if [ -z "$goodreads_id" ]; then
        # https://www.goodreads.com/book/isbn/$isbn
        isbn=$(echo $metadata | grep -oPi '<[^:>]+:identifier[^>]*\bopf:scheme\s*=\s*["\x27]\s*isbn\s*["\x27][^>]*>\K[^<]+')
        metadata=$(fetch-ebook-metadata -i "$isbn" -o 2> /dev/null)
        goodreads_id=$(echo $metadata | grep -oPi '<[^:>]+:identifier[^>]*\bopf:scheme\s*=\s*["\x27]\s*goodreads\s*["\x27][^>]*>\K[^<]+')

        if [ -z "$goodreads_id" ]; then
            echo "  Could not find Goodreads ID for '$title' by '$author'."
            continue
        fi
    fi

    echo "  Found Goodreads ID: $goodreads_id"

    echo "  Updating Calibre metadata..."
    calibredb set_metadata "$book_id" --with-library "$CALIBRE_LIBRARY" --field "identifiers:goodreads:$goodreads_id" > /dev/null

    echo "  Successfully set Goodreads ID for book $book_id."
done

echo "Script finished. Reopen Calibre to apply changes."
