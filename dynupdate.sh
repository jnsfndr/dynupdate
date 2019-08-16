#!/bin/bash
HOSTNAME=""
CLIENTKEY=""
UPDATEv4=true # Set this value to false if you only want to update IPv6
UPDATEv6=true # Set this value to false if you only want to update IPv4
IPCACHE="/var/tmp/dynupdate/ipcache"
LOG_FILE="/var/tmp/dynupdate/log"
if [[ "$UPDATEv4" = true && "$UPDATEv6" = true ]]
then
    IP4ADDR=$(curl -s https://ip4.ddnss.de/meineip.php | grep -o "[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}")
    IP6ADDR=$(curl -s https://ip6.ddnss.de/meineip.php | grep -o "[0-9a-f\:]\{8,\}")
    if [[ "$IP4ADDR" = "" || "$IP6ADDR" = "" ]]
    then
            echo "Error: unable to determine IP address - \"$timestamp\"" >> "$LOG_FILE"
            exit 1
    fi

    if [ -f "$IPCACHE" ]
    then
            source "$IPCACHE"
    else
            OLDIP4ADDR="192.0.2.0"
            OLDIP6ADDR="::1"
    fi
    if [[ "$IP4ADDR" != "$OLDIP4ADDR" || "$IP6ADDR" != "$OLDIP6ADDR" ]]
    then
            curl -X POST "https://www.ddnss.de/upd.php?key=$CLIENTKEY&host=$HOSTNAME&ip=$IP4ADDR&ip6=$IP6ADDR"
            mkdir -p $(dirname "$IPCACHE")
            echo "OLDIP4ADDR=\"$IP4ADDR\"" > "$IPCACHE"
            echo "OLDIP6ADDR=\"$IP6ADDR\"" >> "$IPCACHE"
            mkdir -p $(dirname "$LOG_FILE")
            timestamp=$( date +%Y-%m-%d_%H-%M-%S )
            echo "Update IP - \"$IP4ADDR\" + \"$IP6ADDR\" + \"$timestamp\"" >> "$LOG_FILE"

    fi
elif [[ "$UPDATEv4" = 'true' && "$UPDATEv6" = 'false' ]]
then
    IP4ADDR=$(curl -s https://ip4.ddnss.de/meineip.php | grep -o "[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}")
    if [[ "$IP4ADDR" = "" ]]
    then
            echo "Error: unable to determine IP address - \"$timestamp\"" >> "$LOG_FILE"
            exit 1
    fi

    if [ -f "$IPCACHE" ]
    then
            source "$IPCACHE"
    else
            OLDIP4ADDR="192.0.2.0"
    fi
    if [[ "$IP4ADDR" != "$OLDIP4ADDR" ]]
    then
            curl -X POST "https://www.ddnss.de/upd.php?key=$CLIENTKEY&host=$HOSTNAME&ip=$IP4ADDR"
            mkdir -p $(dirname "$IPCACHE")
            echo "OLDIP4ADDR=\"$IP4ADDR\"" > "$IPCACHE"
            mkdir -p $(dirname "$LOG_FILE")
            timestamp=$( date +%Y-%m-%d_%H-%M-%S )
            echo "Update IP - \"$IP4ADDR\" + \"$timestamp\"" >> "$LOG_FILE"

    fi
elif [[ "$UPDATEv4" = 'false' && "$UPDATEv6" = 'true' ]]
then
    IP6ADDR=$(curl -s https://ip6.ddnss.de/meineip.php | grep -o "[0-9a-f\:]\{8,\}")
    if [[ "$IP6ADDR" = "" ]]
    then
            echo "Error: unable to determine IP address - \"$timestamp\"" >> "$LOG_FILE"
            exit 1
    fi

    if [ -f "$IPCACHE" ]
    then
            source "$IPCACHE"
    else
            OLDIP6ADDR="::1"
    fi
    if [[ "$IP6ADDR" != "$OLDIP6ADDR" ]]
    then
            curl -X POST "https://www.ddnss.de/upd.php?key=$CLIENTKEY&host=$HOSTNAME&ip6=$IP6ADDR"
            mkdir -p $(dirname "$IPCACHE")
            echo "OLDIP6ADDR=\"$IP6ADDR\"" >> "$IPCACHE"
            mkdir -p $(dirname "$LOG_FILE")
            timestamp=$( date +%Y-%m-%d_%H-%M-%S )
            echo "Update IP - \"$IP6ADDR\" + \"$timestamp\"" >> "$LOG_FILE"

    fi
fi
