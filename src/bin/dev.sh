#!/bin/sh
echo "\033[32mStart otagai...\033[0m"
mongod --dbpath ./data/db --logpath ./data/db/mongo.log &
NODE_ENV=development ./node_modules/node-dev/bin/node-dev server &
node -e "require('grunt').cli();" 