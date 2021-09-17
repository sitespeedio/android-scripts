#!/bin/bash
set -eu

# Script that goes through all connected phones and print the 
# connected wifi and the battery temperatue

for DEVICE in $(adb devices | grep -v "List" | awk '{print $1}')
do
    STATE=$(adb -s "$DEVICE" get-state)
    if [ "$STATE" = "device" ]; then
        MODEL=$(adb -s "$DEVICE" shell getprop ro.product.model)
        TEMP=$(adb -s "$DEVICE" shell dumpsys battery | grep temperature | grep -Eo '[0-9]{1,3}')
        if adb -s "$DEVICE" shell ping -c 1 8.8.8.8 | grep -q rtt; then
            WIFI=$(adb -s "$DEVICE" shell dumpsys netstats | grep -E 'iface=wlan.*networkId'  | awk '{print $4}' | head -1 | cut -d'"' -f 2)
            echo "$DEVICE" "$MODEL" has a connection to the internet wifi "$WIFI" and the battery temperature is $((TEMP / 10)) degrees Celsius
        else
            echo "$DEVICE" "$MODEL" has no connection to the internet and the battery temperature is $((TEMP / 10)) degrees Celsius
        fi
    else
        echo "$DEVICE" state is "$STATE"
    fi
done
