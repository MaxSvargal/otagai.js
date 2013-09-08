#!/bin/bash
if [ $1 ]; then
	if [ $1 = "stop"  ]; then
		echo "Kill all node and mongo processes"
		killall node
		killall mongod

	elif [ $1 = "start"  ]; then
		echo "Kill all node and mongo processes"
		killall node
		killall mongod

		echo "Start mongo..."
		mongod --dbpath data/db --logpath ./data/db/mongo.log --port 27020 &

		echo "Start node..."
		nohup node server.js &

		echo "Server started"
	fi
else
		echo "Type stop or start"
fi