ip link set usb0 up
ip addr add dev usb0 10.42.0.2/8 broadcast 10.42.0.255
ip route add default via 10.42.0.1
