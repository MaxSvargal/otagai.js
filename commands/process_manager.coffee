forever = require 'forever'
spawn = require('child_process').spawn
execFile = require('child_process').execFile
fs = require 'fs'

appDir = process.cwd()
pkg = require "#{appDir}/package.json"

class processManager
  constructor: (name, env, options) ->
    @mongoPidPath = "#{appDir}/pids/mongo.pid"
    @nodePidPath = "#{appDir}/pids/node.pid"
    @name = name
    @env = env
    @options = options
    forever.load {
      root: "#{__dirname}/../pids"
      pidPath: "#{__dirname}/../pids"
      max: 10
    }

  start: ->
    devNode = (callback) ->
      node = execFile "#{appDir}/node_modules/node-dev/bin/node-dev",
        ['server'], 
        { env: {'NODE_ENV': 'development'} },
        (error, stdout, stderr) ->
          console.log stdout
          console.log stderr
          console.log error if error
          callback node.pid

    prodNode = ->
      node = forever.startDaemon("#{appDir}/server.js")
      return node.pid

    startMongo = ->
      mongod = spawn 'mongod', 
        [
          "--dbpath", "#{appDir}/data/db", 
          "--logpath", "#{appDir}/data/db/mongo.log"
        ],
        {
          detached: true
        }
      mongod.stderr.on 'data', (data) ->
        console.log 'mongo error: ' + data
      return mongod.pid

    startGrunt = ->
      grunt = require("#{appDir}/node_modules/grunt")
      grunt.tasks ['default'], {}, ->
        grunt.log.ok "Grunt task done"

    console.log "Start app #{@name} with envionment #{@env}"
    mongopid = startMongo()
    console.log "Current MongoDB pid: #{mongopid}"
    thenDone = (nodepid) =>
      console.log "Current NodeJS pid: #{nodepid}"
      console.log "Type 'otagai server stop' in current directory for stop processes"
      @writePids mongopid, nodepid

    if @env is 'prod'
      nodepid = prodNode()
      thenDone nodepid
    if @env is 'dev'
      devNode (pid) ->
        thenDone pid
        startGrunt()


  stop: ->
    @readPids (pids) ->
      process.kill pids.node, 'SIGHUP'
      process.kill pids.mongo, 'SIGHUP'
      console.log "Application processes killed successfully"

  restart: ->
    @stop()
    @start()

  writePids: (mongopid, nodepid) ->
    fs.writeFile @mongoPidPath, mongopid, (err) ->
      throw err if err
    fs.writeFile @nodePidPath, nodepid, (err) ->
      throw err if err
  
  readPids: (callback) ->
    pids = {}
    fs.readFile @mongoPidPath, 'utf-8', (err, mongodata) =>
      pids.mongo = mongodata
      fs.readFile @nodePidPath, 'utf-8', (err, nodedata) =>
        pids.node = nodedata
        callback pids



exports.register = (env, options) ->
  new processManager pkg.name, env, options

exports.list = (options) ->
  forever.list true, (processes) ->
    console.log "PROCESSES: ", processes
