#!/system/bin/sh
mount -o remount, rw /system

dd if=/data/local/tmp/charger of=/system/bin/charger
chown root.shell /system/bin/charger
chmod 755 /system/bin/charger

dd if=/data/local/tmp/chargemon of=/system/bin/chargemon
chown root.shell /system/bin/chargemon
chmod 755 /system/bin/chargemon

dd if=/data/local/tmp/recovery.tar of=/system/bin/recovery.tar
chown root.shell /system/bin/recovery.tar
chmod 644 /system/bin/recovery.tar

dd if=/data/local/tmp/jelly.tar of=/system/bin/jelly.tar
chown root.shell /system/bin/jelly.tar
chmod 644 /system/bin/jelly.tar

dd if=/data/local/tmp/ric of=/system/bin/ric
chown root.shell /system/bin/ric
chmod 755 /system/bin/ric

dd if=/data/local/tmp/busybox of=/system/xbin/busybox
chown root.shell /system/xbin/busybox
chmod 755 /system/xbin/busybox

dd if=/data/local/tmp/step2.sh of=/system/bin/step2.sh
chown root.shell /system/bin/step2.sh
chmod 755 /system/bin/step2.sh

mount -o remount, ro /system
