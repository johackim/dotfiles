#!/bin/bash

cd ~/.dotfiles || exit

git ls-files '.*' ':!.gitattributes' ':!.gitignore' ':!.github' ':!.config/ublock' | while read -r file; do
    [ ~/"$file" -ef "$file" ] && continue
    mkdir -p ~/"$(dirname "$file")"
    ln -sf "$PWD/$file" ~/"$file"
done

find ~ -maxdepth 4 -xtype l -lname "$PWD/*" -delete || true
