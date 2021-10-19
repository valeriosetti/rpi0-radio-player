FROM ubuntu:xenial

ARG uid
ARG gid

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y git build-essential bc bison flex libssl-dev \
                u-boot-tools lzop fakeroot gcc-multilib \
                zlib1g:i386 libncurses5-dev vim kmod

RUN groupadd -g $gid pi
RUN useradd -m -u $uid -g $gid pi
RUN echo pi:pi | chpasswd
USER pi

WORKDIR /home/pi

ENV PATH="${PATH}:/home/pi/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/"

RUN echo alias make-defconfig=\"make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcmrpi_defconfig\" >> /home/pi/.bashrc
RUN echo alias make-build-all=\"make -j$(grep -c ^processor /proc/cpuinfo) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs\" >> /home/pi/.bashrc

CMD ["/bin/bash"]
