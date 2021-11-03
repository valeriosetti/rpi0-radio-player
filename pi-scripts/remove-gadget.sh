#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

BASE_PATH="/sys/kernel/config/usb_gadget"

echo "" | sudo tee $BASE_PATH/g1/UDC

rm $BASE_PATH/g1/configs/c.1/mass_storage.usb0
rmdir $BASE_PATH/g1/configs/c.1

rmdir $BASE_PATH/g1/functions/mass_storage.usb0

rmdir $BASE_PATH/g1/strings/0x409

rmdir $BASE_PATH/g1

