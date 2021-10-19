#!/bin/sh

git clone https://github.com/raspberrypi/tools tools
git clone --branch fake-block-device git@github.com:valeriosetti/rpi-4.19.git linux
docker build -t rpi-build --build-arg uid=$(id -u) --build-arg gid=$(id -u)  docker/.
