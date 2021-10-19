#!/bin/sh

git clone https://github.com/raspberrypi/tools tools
git clone --depth=1 --branch rpi-4.19.y https://github.com/raspberrypi/linux
docker build -t rpi-build --build-arg uid=$(id -u) --build-arg gid=$(id -u)  docker/.
