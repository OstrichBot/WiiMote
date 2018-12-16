#!/bin/bash
sleep 1 # Wait until Bluetooth services are fully initialized
hcitool dev | grep hci >/dev/null
if test $? -eq 0 ; then
	wminput -d -c  /home/pi/Wii/mywminputA 00:22:D7:AE:4D:24 > /dev/null 2>&1 &
	wminput -d -c  /home/pi/Wii/mywminputB 00:21:BD:77:E8:98 > /dev/null 2>&1 &
	wminput -d -c  /home/pi/Wii/mywminputC 00:22:AA:63:62:AE > /dev/null 2>&1 &
	wminput -d -c  /home/pi/Wii/mywminputD 00:21:47:DA:1F:D8 > /dev/null 2>&1 &
else
	echo "Blue-tooth adapter not present!"
	exit 1
fi
