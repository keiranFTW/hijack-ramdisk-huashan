#!/bin/bash
echo "Custom Recovery For Xperia SP(huashan)"
echo " ------------------------------------------------------------------"
adb wait-for-device
adb push files/charger /data/local/tmp/
adb push files/chargemon /data/local/tmp/
adb push files/recovery.tar /data/local/tmp/
adb push files/jelly.tar /data/local/tmp/
adb push files/busybox /data/local/tmp/
adb push files/step2.sh /data/local/tmp/
adb push files/installer.sh /data/local/tmp/
adb push files/ric /data/local/tmp/
adb shell chmod 755 /data/local/tmp/installer.sh
adb shell /data/local/tmp/installer.sh
adb shell rm /data/local/tmp/installer.sh
echo "Done!"
read
