#! /bin/bash
#Kill Wiimote processes
kill $(ps aux | grep '[w]minput' | awk '{print $2}')
