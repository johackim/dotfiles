#!/bin/bash
cache=~/.cache/dmenu_run
freq=~/.dmenu_history
source ~/.aliases
source ~/.private_aliases
source ~/.zshrc
echo > $freq # Disable history

case "$1" in 
    remove)
        # To remove a file from history: 
        # $ dmenu_recent_aliases remove <name> 
        grep -v "$2" $freq > temp && mv temp $freq
    ;;
    *)
    (compgen -a; compgen -c | grep -vxF "$(compgen -a)") | sort | tail -n +10 > $cache

    sorted=$(sort $freq | uniq -c | sort -hr | colrm 1 8)
    cmd=`(echo "$sorted"; cat $cache | grep -vxF "$sorted") | dmenu "$@"`
    if ! [ "$cmd" == "" ] && ! [ "$(grep ${cmd/;/} $cache)" == "" ]; then
        echo ${cmd/;/} >> $freq

        cmdexec=$(alias | grep "${cmd/;/}=" | cut -f2 -d "'" | tr -d "'")
        if [ -z "$cmdexec" ]; then
            cmdexec=${cmd/;/}
        fi

        case $cmd in
            *\;)    cmdexec="urxvt -e $cmdexec" ;;
        esac
        # Ugly workaround to run functions...
        echo "$cmdexec" | compgen -F "$cmdexec" | bash
        # ...and aliases
        echo "$cmdexec" | bash
    fi
    ;;
esac
