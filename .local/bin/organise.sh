#!/bin/bash

shopt -s nocaseglob
cd ~/Downloads || exit

mkdir -p images
fd -j1 -d1 -epng -esvg -ejpg -ejpeg -egif -epsd -x mv -n {} images

mkdir -p textes
fd -j1 -d1 -esql -ertf -eodt -ejson -eyml -eyaml -exml -exls -etxt -eopml -epo -epdf -eepub -emobi -ecrt -edoc -edocx -exlsx -ehtml -ecsv -emd -etorrent -earia2 -ekey -esh -epy -eovpn -elog -econf -eods -exmind -egpx -edb -edrawio -eazw -eencrypted -eAppImage -em3u-etextes -x mv -n {} textes

mkdir -p videos
fd -j1 -d1 -eavi -emkv -em4v -ewebm -emp4 -esrt -eogv -x mv -n {} videos

mkdir -p archives
fd -j1 -d1 -ezip -etar.gz -etgz -egz -ebundle -eapk -erar -e7z -eiso -eexe -ebz2 -etar -eimg -x mv -n {} archives

mkdir -p music
fd -j1 -d1 -ewav -emp3 -x mv {} music

mkdir -p dossiers
find . -maxdepth 1 -type d ! -name images ! -name archives ! -name textes ! -name music ! -name videos ! -name torrents -exec mv {} dossiers \; &>/dev/null

find . -maxdepth 1 -type d -empty -delete
find . -name "*.part" -delete
