#!/bin/sh

echo "\033[32m > Start MongoDB process..."
echo "\033[0m"
mongod --dbpath ./data/db &
echo "\033[32m > Start Node.js process..."
echo "\033[0m"
grunt