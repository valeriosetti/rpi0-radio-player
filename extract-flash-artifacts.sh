OUTPUT_PATH=$(pwd)/build_output
LINUX_PATH=$(pwd)/linux
TOOLS_PATH=$(pwd)/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin

if [ ! -b "/dev/mmcblk0p1" ] ; then
	echo "Error: no SD card detected. Exit"
	exit 1
fi

mkdir -p $OUTPUT_PATH

# EXTRACT ARTIFACTS
cd $OUTPUT_PATH
mkdir -p boot/overlays
mkdir -p rootfs

cd $LINUX_PATH
make ARCH=arm CROSS_COMPILE=$TOOLS_PATH/arm-linux-gnueabihf- INSTALL_MOD_PATH=$OUTPUT_PATH/rootfs modules_install

cp arch/arm/boot/zImage    $OUTPUT_PATH/boot/kernel.img
cp arch/arm/boot/dts/*.dtb    $OUTPUT_PATH/boot/
cp arch/arm/boot/dts/overlays/*.dtb*    $OUTPUT_PATH/boot/overlays/
cp arch/arm/boot/dts/overlays/README    $OUTPUT_PATH/boot/overlays/

# FLASH ARTIFACTS
mkdir -p $OUTPUT_PATH/boot_mnt
mkdir -p $OUTPUT_PATH/rootfs_mnt

sudo mount -t vfat /dev/mmcblk0p1 $OUTPUT_PATH/boot_mnt
sudo mount -t ext4 /dev/mmcblk0p2 $OUTPUT_PATH/rootfs_mnt

sudo cp -R $OUTPUT_PATH/boot/* $OUTPUT_PATH/boot_mnt/ 
sudo cp -R $OUTPUT_PATH/rootfs/* $OUTPUT_PATH/rootfs_mnt/ 

sudo umount $OUTPUT_PATH/boot_mnt
sudo umount $OUTPUT_PATH/rootfs_mnt

rm -rf $OUTPUT_PATH/boot_mnt
rm -rf $OUTPUT_PATH/rootfs_mnt
