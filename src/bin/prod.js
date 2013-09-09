#!/usr/bin/env node

var forever = require('forever-monitor');
var clc = require('cli-color'),
    error = clc.red.bold,
    warn = clc.yellow,
    notice = clc.blue;
console.log(process.cwd() + "/config/mongodb.conf");
var mongo = forever.start(['mongod', "-f " + process.cwd() + "/config/mongodb.conf"], {
    silent : false,
    max: 1,
    options: [
      "--dbpath " + process.cwd() + "/data/db",
      "--logpath " + process.cwd() + "/data/db/mongo.log",
      "--port 27020"
    ]
});


var node = new (forever.Monitor)('server.js', {
  killTree: true,
  silent : false,
  max: 1,
  env: { 'NODE_ENV': 'production' }
});


node.on('exit', function () {
  console.log(warn('Node process exit.'));
});

mongo.on('exit', function () {
  console.log(warn('MongoDB process exit.'));
});

node.start();
//mongo.start();