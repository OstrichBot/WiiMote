#! /bin/bash

#Kill Wiimote processes
kill $(ps aux | grep '[w]minput' | awk '{print $2}')

ttl=30
alert="/home/pi/complete.oga"
fail="/home/pi/bark.oga"
begin_sound="/home/pi/robot-blip.wav"
end_sound="/home/pi/service-logout.oga"
mac="\([[:xdigit:]]\{2\}:\)\{5\}[[:xdigit:]]" # "00:" * 5 + "00"
device_file="/tmp/wiimote-scan"

function play {
    ogg123 $1 &> /dev/null &
}

function match {
    echo $1 | grep $2
}

function show {
    if [[ -n $DEBUG ]]
    then
        echo $1
    fi
}

# prevent scans from interfering with one another?
killall hcitool && sleep 5

if [[ `hcitool dev | grep hci` ]]
then
    play $begin_sound &> /dev/null &
    echo "Bluetooth detected, starting scan with ${ttl}s timeout..."
	echo

    timeout $ttl hcitool scan | while read device
    do
		if [ "$device" = "Scanning ..." ]
		then
			continue 1
		fi
		
		echo "Found Device: $device"
        id=`echo $device | cut -d" " -f1`
		
		if [ "$id" = "00:22:D7:AE:4D:24" ]
		then
			echo -n "Detected Wiimote with ID: ${id}"
			wminput -d -c  /home/pi/Wii/mywminputA 00:22:D7:AE:4D:24 > /dev/null 2>&1 &
			echo " registered.(#1)"
			echo
			
		elif [ "$id" = "00:21:BD:77:E8:98" ]
		then
			echo -n "Detected Wiimote with ID: ${id}"
			wminput -d -c  /home/pi/Wii/mywminputB 00:21:BD:77:E8:98 > /dev/null 2>&1 &
			echo " registered.(#2)"
			echo
		
		elif [ "$id" = "00:22:AA:63:62:AE" ]
		then
			echo -n "Detected Wiimote with ID: ${id}"
			wminput -d -c  /home/pi/Wii/mywminputC 00:22:AA:63:62:AE > /dev/null 2>&1 &
			echo " registered.(#3)"
			echo
			
		elif [ "$id" = "00:21:47:DA:1F:D8" ]
		then
			echo -n "Detected Wiimote with ID: ${id}"
			wminput -d -c  /home/pi/Wii/mywminputD 00:21:47:DA:1F:D8 > /dev/null 2>&1 &
			echo " registered.(#4)"
			echo
		fi
	done

    play $end_sound
    echo "Scan complete."

    if [[ "$rebootWithoutWiimotes" == "1" && -z `pidof wminput` ]]
    then
        echo "No Wiimotes detected!  Restarting..."
        sudo reboot
    fi
else
    echo "Blue-tooth adapter not present!"
    play $fail
fi