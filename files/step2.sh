#!/tmp/sh
prepare_start () {
        # remount rootfs rw
        mount -o remount,rw /

        # stop services
        #
        echo "**** PL: stop services ****" > /dev/kmsg
        # stop doesn't seem to work at this boot state, we should check why
        /system/bin/stop secchan > /dev/kmsg
        /system/bin/stop ueventd > /dev/kmsg
        /system/bin/stop tad > /dev/kmsg
        /system/bin/stop adbd > /dev/kmsg
        /system/xbin/killall -9 ueventd 2> /dev/kmsg
        /system/xbin/killall -9 secchand 2> /dev/kmsg
        /system/xbin/killall -9 tad 2> /dev/kmsg
        echo "***** PL: ps after stop : ****" > /dev/kmsg
        ps > /dev/kmsg

        # unmounting and cleaning
        ## /system
        umount -l /dev/block/platform/msm_sdcc.1/by-name/System
        ## /data/idd
        umount -l /dev/block/platform/msm_sdcc.1/by-name/apps_log
        ## /data
        umount -l /dev/block/platform/msm_sdcc.1/by-name/Userdata
        ## /cache
        umount -l /dev/block/platform/msm_sdcc.1/by-name/Cache
        ## /sdcard
        umount -l /mnt/sdcard
        umount -l /sdcard
        umount -l /dev/fuse
        
        ## try hard way
        umount -f /data/idd
        umount -f /data
        umount -f /cache
        umount -f /system
        
        ## paranoid ?
        umount /data/idd
        umount /data
        umount /cache
        umount /system
        umount /storage/sdcard0
        
        echo "***** PL: umount result: *****" > /dev/kmsg
        mount > /dev/kmsg

        ## miscs
        umount /dev/cpuctl
        umount /acct
        umount /dev/pts
        umount /dev
        umount /mnt/asec
        umount /mnt/oob
        umount /proc

        # clean /
        cd /
        rm -r /sbin
        rmdir /sdcard
        rm -f etc init* uevent* default*
}
# ----- start the fun :) ------

export PATH=/tmp

echo "*** PL: starting recovery boot script ***" > /dev/kmsg

# Trigger short vibration
echo '200' > /sys/class/timed_output/vibrator/enable
# Show blue led
echo '255' > /sys/class/leds/LED1_B/brightness
echo '255' > /sys/class/leds/LED2_B/brightness
echo '255' > /sys/class/leds/LED3_B/brightness
echo '0' > /sys/class/leds/LED1_R/brightness
echo '0' > /sys/class/leds/LED2_R/brightness
echo '0' > /sys/class/leds/LED3_R/brightness
echo '0' > /sys/class/leds/LED1_G/brightness
echo '0' > /sys/class/leds/LED2_G/brightness
echo '0' > /sys/class/leds/LED3_G/brightness

# wait for vol+/vol- keys 
cat /dev/input/event8 > /dev/keycheck&
sleep 3
kill -9 $!

# vol+/-, boot recovery
if [ -s /dev/keycheck -o -e /cache/recovery/boot ]
then
    # trigger green LED
    echo '0' > /sys/class/leds/LED1_B/brightness
    echo '0' > /sys/class/leds/LED2_B/brightness
    echo '0' > /sys/class/leds/LED3_B/brightness
    echo '0' > /sys/class/leds/LED1_R/brightness
    echo '0' > /sys/class/leds/LED2_R/brightness
    echo '0' > /sys/class/leds/LED3_R/brightness
    echo '255' > /sys/class/leds/LED1_G/brightness
    echo '255' > /sys/class/leds/LED2_G/brightness
    echo '255' > /sys/class/leds/LED3_G/brightness
    sleep 1

    rm /cache/recovery/boot

    prepare_start
    if [ -f /tmp/recovery.tar ]
    then
        tar -xf /tmp/recovery.tar
        rm /tmp/recovery.tar
        rm /tmp/jelly.tar
    fi

    # trigger red LED
    echo '0' > /sys/class/leds/LED1_B/brightness
    echo '0' > /sys/class/leds/LED2_B/brightness
    echo '0' > /sys/class/leds/LED3_B/brightness
    echo '100' > /sys/class/leds/LED1_R/brightness
    echo '100' > /sys/class/leds/LED2_R/brightness
    echo '100' > /sys/class/leds/LED3_R/brightness
    echo '0' > /sys/class/leds/LED1_G/brightness
    echo '0' > /sys/class/leds/LED2_G/brightness
    echo '0' > /sys/class/leds/LED3_G/brightness
    sleep 1

    # chroot
    chroot / /init
    exec /system/bin/charger
fi


# show violet debug led
echo '255' > /sys/class/leds/LED1_B/brightness
echo '255' > /sys/class/leds/LED2_B/brightness
echo '255' > /sys/class/leds/LED3_B/brightness
echo '255' > /sys/class/leds/LED1_R/brightness
echo '255' > /sys/class/leds/LED2_R/brightness
echo '255' > /sys/class/leds/LED3_R/brightness
echo '0' > /sys/class/leds/LED1_G/brightness
echo '0' > /sys/class/leds/LED2_G/brightness
echo '0' > /sys/class/leds/LED3_G/brightness
sleep 1

prepare_start

# extract jb initramfs
if [ -f /tmp/jelly.tar ]
then
    tar -xf /tmp/jelly.tar
    rm /tmp/jelly.tar
    rm /tmp/recovery.tar
fi

# normal boot, clear led
echo '0' > /sys/class/leds/LED1_B/brightness
echo '0' > /sys/class/leds/LED2_B/brightness
echo '0' > /sys/class/leds/LED3_B/brightness
echo '0' > /sys/class/leds/LED1_R/brightness
echo '0' > /sys/class/leds/LED2_R/brightness
echo '0' > /sys/class/leds/LED3_R/brightness
echo '0' > /sys/class/leds/LED1_G/brightness
echo '0' > /sys/class/leds/LED2_G/brightness
echo '0' > /sys/class/leds/LED3_G/brightness

# chroot
chroot / /init

exec /system/bin/charger
