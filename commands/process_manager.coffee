forever = require 'forever'
spawn = require('child_process').spawn
fs = require 'fs'
clc = require 'cli-color'
error = clc.red.bold
notice = clc.cyanBright
success = clc.green

appDir = process.cwd()
grunt = require "#{appDir}/node_modules/grunt"
pkg = require "#{appDir}/package.json"

class processManager
  constructor: (name, env, options) ->
    @mongoPidPath = "#{appDir}/pids/mongo.pid"
    @nodePidPath = "#{appDir}/pids/node.pid"
    @name = name
    @env = env
    @options = options
    forever.load { max: 10 }

  start: ->
    startDevNode = ->
      node = spawn "node",
        ["#{appDir}/node_modules/node-dev/bin/node-dev", "server.js"] 
      # { env: {'NODE_ENV': 'development'} }
      if node.stdout
        node.stdout.on 'data', (data) ->
          process.stdout.write '[node] ' + data

      if node.stderr
        node.stderr.on 'data', (data) ->
          process.stdout.write error('[node error]') + data

      return node.pid

    startProdNode = ->
      node = forever.startDaemon("#{appDir}/server.js")
      return node.pid

    startMongo = ->
      mongod = spawn 'mongod', 
        [
          "--dbpath", "#{appDir}/data/db", 
          "--logpath", "#{appDir}/data/db/mongo.log"
        ],
        { detached: true }
      mongod.stderr.on 'data', (data) ->
        process.stdout.write error('[mongo error]') + data
      return mongod.pid

    startGrunt = ->
      grunt.tasks ['default']
      console.log '\r\n--------------------\r\n'

    console.log notice("Start app #{@name} with envionment #{@env}")
    mongopid = startMongo()
    console.log "Current MongoDB pid: #{mongopid}"
    thenDone = (nodepid) =>
      console.log "Current NodeJS pid: #{nodepid}"
      console.log success("Type 'otagai server stop' in current directory for stop processes")
      @writePids mongopid, nodepid

    if @env is 'prod'
      nodepid = startProdNode()
      thenDone nodepid
    if @env is 'dev'
      nodepid = startDevNode()
      thenDone nodepid
      startGrunt()

  stop: ->
    @readPids (pids) ->
    try
      process.kill pids.node, 'SIGHUP'
      process.kill pids.mongo, 'SIGHUP'
      process.stdout.write success("Application processes killed successfully")
    catch
      throw new Error error('One or more processes does not find.')

  restart: ->
    @stop()
    @start()

  writePids: (mongopid, nodepid) ->
    try
      fs.writeFile @mongoPidPath, mongopid, (err) ->
        throw err if err
      fs.writeFile @nodePidPath, nodepid, (err) ->
        throw err if err
    catch
      throw new Error error("Write pids not possible. Check pids folder or folder permissions.")
  
  readPids: (callback) ->
    pids = {}
    try
      fs.readFile @mongoPidPath, 'utf-8', (err, mongodata) =>
        pids.mongo = mongodata
        fs.readFile @nodePidPath, 'utf-8', (err, nodedata) =>
          pids.node = nodedata
          callback pids
    catch
      throw new Error error("Can't read pids files")
      callback null

  checkProcess: (uid) ->
    forever.findByUid uid


exports.register = (env, options) ->
  new processManager pkg.name, env, options
