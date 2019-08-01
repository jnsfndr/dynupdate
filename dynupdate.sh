#!/bin/bash
HOSTNAME=""
CLIENTKEY=""

IP4ADDR=$(curl -s http://checkip.dyndns.com | grep -o "[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}")
IP6ADDR=$(curl -s http://checkipv6.dyndns.com | grep -o "[0-9a-f\:]\{8,\}")
if [ "$IP4ADDR" = "" -o "$IP6ADDR" = "" ]
then
        echo "Error: unable to determine IP address" 1>&2
        exit 1
fi
IPCACHE="/var/tmp/dynupdate/ipcache"
if [ -f "$IPCACHE" ]
then
        source "$IPCACHE"
else
        OLDIP4ADDR="1.2.3.4"
        OLDIP6ADDR="::1"
fi
if [ "$IP4ADDR" != "$OLDIP4ADDR" -o "$IP6ADDR" != "$OLDIP6ADDR" ]
then
        curl -X POST "https://www.ddnss.de/upd.php?key=$CLIENTKEY&host=$HOSTNAME&ip=$IP4ADDR&ip6=$IP6ADDR"
        mkdir -p $(dirname "$IPCACHE")
        echo "OLDIP4ADDR=\"$IP4ADDR\"" > "$IPCACHE"
        echo "OLDIP6ADDR=\"$IP6ADDR\"" >> "$IPCACHE"

fi
