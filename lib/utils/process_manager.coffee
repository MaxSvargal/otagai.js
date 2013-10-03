forever = require 'forever'
child = require 'child_process'
fs = require 'fs'
clc = require 'cli-color'
error = clc.red.bold
notice = clc.cyanBright
success = clc.green

appDir = process.cwd()
pidsPath = "#{appDir}/data/pids"
grunt = require "#{appDir}/node_modules/grunt"
pkg = require "#{appDir}/package.json"
mongoPidPath = "#{appDir}/pids/mongo.pid"
nodePidPath = "#{appDir}/pids/node.pid"

#
# Start server task
#
exports.start = (env) ->
  startDevNode = ->
    node = child.spawn "node",
      ["#{appDir}/node_modules/node-dev/bin/node-dev", "server.js"] 
    # { env: {'NODE_ENV': 'development'} }
    if node.stdout
      node.stdout.on 'data', (data) ->
        process.stdout.write '[node] ' + data

    if node.stderr
      node.stderr.on 'data', (data) ->
        process.stdout.write error('[node error]') + data
    node.on 'exit', (data) ->
      console.log "TERMINATED", data
    return node.pid

  startProdNode = ->
    forever.load { max: 10 }
    node = forever.startDaemon("#{appDir}/server.js")
    return node.pid

  startMongo = ->
    mongod = child.spawn 'mongod', 
      [
        "--dbpath", "#{appDir}/data/db", 
        "--logpath", "#{appDir}/data/db/mongo.log"
      ],
      { detached: true }
    mongod.stderr.on 'data', (data) ->
      process.stdout.write error('[mongo error] ') + data
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

  if env is 'prod'
    nodepid = startProdNode()
    thenDone nodepid
    process.exit 0
  else
    nodepid = startDevNode()
    thenDone nodepid
    startGrunt()


#
# Stop server task
#
exports.stop = ->
  try
    @readPids (pids) ->
      process.kill pids.node, 'SIGHUP'
      process.kill pids.mongo, 'SIGHUP'
      console.log success("Application processes killed successfully")
  catch error
    throw new Error error('One or more processes does not found.')


#
# Restart server task
#
exports.restart = (force) ->
    if force is true then @forceKill()
    else @stop()
    @start()

    forceKill: ->
      child.exec 'killall node & killall mongod', 
        (error, stdout, stderr) ->
          console.log 'stdout: ' + stdout
          console.log 'stderr: ' + stderr
          console.log 'error: ' + error if error

    writePids: (mongopid, nodepid) ->
      try
        fs.writeFile @mongoPidPath, mongopid, (err) ->
          throw err if err
        fs.writeFile @nodePidPath, nodepid, (err) ->
          throw err if err
        return true
      catch error
        throw new Error error("Write pids not possible. Check pids folder or folder permissions.")
    
    readPids: (callback) ->
      pids = {}
      try
        fs.readFile @mongoPidPath, 'utf-8', (err, mongodata) =>
          pids.mongo = mongodata
          fs.readFile @nodePidPath, 'utf-8', (err, nodedata) =>
            pids.node = nodedata
            callback pids
      catch error
        throw new Error error("Can't read pids files")
        callback null

    checkProcess: (pid) ->
      forever.findByUid uid

    # TODO: test it with mocha now!
    clearPids: ->
      clearPid = (name) ->
        fs.writeFile "#{pidsPath}/#{name}.pid", "", (err) ->
          throw err if err
      clearPid 'node'
      clearPid 'mongo'

    # TODO: test it with mocha now!
    startedCheck: (callback) ->
      started = false
      @checkPidFile 'node', (pid) ->
        if pid not null
          started = true

        @checkPidFile 'mongo', (pid) ->
          if pid not null
            started = true
          else
            started = false
          callback started
      
    # TODO: test it with mocha now!
    checkPidFile: (name, callback) ->
      path = "#{pidsPath}/#{name}.pid"
      readPid = (pidback) ->
        try
          fs.readFile path, 'uif-8', (err, content) ->
            if content isnt ""
              pidback content
        finally
          pidback null

      fs.exists path, (exists) ->
        if exists
          readPid (pid) ->
            callback pid
        else
          callback null
