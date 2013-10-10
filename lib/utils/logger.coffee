'use strict'

winston = require 'winston'

module.exports = (module) ->
  Logger module.filename

Logger = (path) ->
  transports = [
    new winston.transports.Console
        timestamp: true
        colorize: true
        level: 'info'
    new winston.transports.File
        filename: 'debug.log'
        level: 'debug'
  ]
  new winston.Logger {transports: transports}