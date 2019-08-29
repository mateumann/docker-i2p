#!/bin/ash

/i2p/runplain.sh

# wait for router 
PID=`cat /var/tmp/router.pid`
while kill -0 "$PID"; do
    sleep 1
done
