#!/bin/bash
set -eu

DEVICE_ID=${1:-''}
if [ -z "${DEVICE_ID}" ];
  then
  echo 'You need to supply the device id of the phone'
  exit 1
fi


tempFromPhone=$(adb -s "$DEVICE_ID" shell dumpsys battery | grep temperature | grep -Eo '[0-9]{1,3}')
tempInCelsius=$(echo "scale=1; $tempFromPhone/10" | bc -l )
echo "Phone battery temperature $tempInCelsius Celsius"