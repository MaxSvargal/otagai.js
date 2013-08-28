/**
 * Otagai.js
 * Based on https://github.com/olafurnielsen/form5-node-express-mongoose-coffeescript
 */

var express = require('express'),
    http = require('http'),
    fs = require('fs'),
    passport = require('passport'),
    mongoose = require('mongoose'),
    coffee = require('coffee-script')

var env = process.env.NODE_ENV || 'development',
    config = require('./config/environment')[env],
    auth = require('./config/middlewares/authorization')
    
// Bootstrap database
console.log('Connecting to database at ' + config.db)
mongoose.connect(config.db)

// Bootstrap models
var modelsPath = __dirname + '/app/models'
fs.readdirSync(modelsPath).forEach(function (file) {
  require(modelsPath+'/'+file)
});

// bootstrap passport config
require('./config/passport')(passport, config)

var app = express()
// express settings
require('./config/express')(app, config, passport)

// Bootstrap routes
require('./config/routes')(app, config, passport, auth)

// Helper funtions
require('./app/helpers/general')(app)

// Start the app by listening on <port>
var host = process.argv[2] || '0.0.0.0'
var port = process.argv[3] || process.env.PORT || 3000
http.createServer(app).listen(port, host, function(){
  console.log("\u001b[36mApp running on port " + port + "\u001b[0m")
});