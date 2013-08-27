#!/bin/sh

echo "\033[32m > Start MongoDB..."
echo "\033[0m"
mongod --dbpath ./data/db --logpath ./data/db/mongo.log &
echo "\033[32m > Start Node.js..."
echo "\033[0m"
NODE_ENV=development ./node_modules/node-dev/bin/node-dev server &
echo "\033[32m > Start Grunt..."
echo "\033[0m"
node -e "require('grunt').cli();" 