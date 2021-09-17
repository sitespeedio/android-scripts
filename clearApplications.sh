#!/bin/bash
set -eu

# Clear application data
# Needs device id as argument

DEVICE_ID=${1:-''}
if [ -z "${DEVICE_ID}" ];
  then
  echo 'You need to supply the device id of the phone'
  exit 1
fi

apps=("org.mozilla.firefox" \
      "com.android.chrome")

for app in "${apps[@]}"; do
  echo adb -s "$DEVICE_ID" shell am force-stop "$app"
  adb -s "$DEVICE_ID" shell am force-stop "$app"
  echo adb -s "$DEVICE_ID" shell pm clear "$app"
  adb -s "$DEVICE_ID" shell pm clear "$app"
done
