#!/bin/bash

# Add on crontab :
# @reboot sleep 20 && /home/USER/bin/vpnrules.sh
# * * * * * /home/USER/bin/vpnrules.sh

DOMAINS=$(cat << EOF 
monip.org
EOF
)


INTERFACE="${INTERFACE:-wlp1s0}"
ROUTER_IP="${ROUTER_IP:-192.168.1.1}"

for DOMAIN in $DOMAINS;do
	IPS=$(dig +short A "$DOMAIN")
    
    for IP in $IPS;do
	    /usr/bin/ip route add "$IP" via "$ROUTER_IP" dev "$INTERFACE"
    done
done
