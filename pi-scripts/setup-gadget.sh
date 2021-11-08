#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

modprobe libcomposite
 
cd /sys/kernel/config/usb_gadget/
mkdir g1
cd g1
 
echo 0x1d6b > idVendor  # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB    # USB 2.0
 
mkdir -p strings/0x409
echo "123456789" > strings/0x409/serialnumber
echo "vale"        > strings/0x409/manufacturer
echo "Pi Zero Gadget"   > strings/0x409/product
 
mkdir -p functions/mass_storage.usb0
mkdir -p functions/rndis.usb0

dd if=/dev/zero of=/tmp/test.img bs=1M count=100

cd functions/mass_storage.usb0
echo 0 > stall
echo 1 > lun.0/removable
echo 0 > lun.0/ro
echo /tmp/test.img > lun.0/file
cd ../../
 
mkdir -p configs/c.1
echo 250 > configs/c.1/MaxPower
ln -s functions/mass_storage.usb0   configs/c.1/
ln -s functions/rndis.usb0   configs/c.1/
 
udevadm settle -t 5 || :
ls /sys/class/udc/ > UDC
