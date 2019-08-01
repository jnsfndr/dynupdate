#!/bin/bash
HOSTNAME=""
CLIENTKEY=""
IPCACHE="/var/tmp/dynupdate/ipcache"
LOG_FILE="/var/tmp/dynupdate/log"
IP4ADDR=$(curl -s https://ip4.ddnss.de/meineip.php | grep -o "[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}")
IP6ADDR=$(curl -s https://ip6.ddnss.de/meineip.php | grep -o "[0-9a-f\:]\{8,\}")
if [ "$IP4ADDR" = "" -o "$IP6ADDR" = "" ]
then
        echo "Error: unable to determine IP address" 1>&2
        exit 1
fi
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
