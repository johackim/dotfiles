export LS_COLORS='di=36:ln=33:ex=1;30:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:tw=100:*~=01;32:*#=01;32:*,v=01;36:*.log=01;32'
ls_color() { for ext in ${@:2}; do LS_COLORS+=":*.$ext=$1"; done }
ls_color 32 0 1 2 3 4 5 6 7 8 9 txt org md mkd h c cc cpp cxx objc sh csh zsh el vim java pl pm py rb hs php htm html shtml erb haml xml rdf css sass scss less js coffee man l n p pod tex
ls_color 33 bmp cgm dl dvi emf eps gif jpeg jpg mng pbm pcx pdf pgm png ppm pps ppsx ps svg svgz tga tif tiff xbm xcf xpm xwd yuv aac au flac mid midi mka mp3 mpa mpeg mpg ogg ra wav anx asf avi axv flc fli flv gl m2v m4v mkv mov mp4 mp4v nuv ogm ogv ogx qt rm rmvb swf vob wmv doc docx rtf dot dotx xls xlsx ppt pptx fla psd
ls_color 37 7z apk arj bin bz bz2 cab deb dmg gem gz iso jar msi rar rpm tar tbz tbz2 tgz tx war xpi xz z zip
ls_color '01;31' cmd exe com bat reg app
ls_color '01;34' gpg pgp asc 3des aes enc
ls_color '01;36' bak old org_archive off dist orig swp swo
unfunction ls_color
