'use strict'

forever = require 'forever'
child = require 'child_process'
fs = require 'fs'
async = require 'async'
log = require('./logger')(module)

module.exports = class ProcessManager

  constructor: (dir = process.cwd(), command = 'dev', options = {}) ->
    @dir = dir
    @command = command
    @options = options
    @pkg = require "#{dir}/package.json"
    @pidsPath = "#{dir}/data/pids"
    @pids = {}

  start: ->
    log.info "Start app #{@pkg.name} with envionment #{@command}"
    async.series [
      (callback) =>
        @child_mongo = @startMongo()
        @writePid 'mongo', @child_mongo.pid, ->
          callback()

      (callback) =>
        @child_node = @startNode()
        if @command is "dev"
          @startGrunt()
        @writePid 'node', @child_node.pid, ->
          callback()

      (callback) =>
        log.info "Current MongoDB pid: #{@pids.mongo}"
        log.info "Current NodeJS pid: #{@pids.node}"
        log.info "Type 'otagai server stop' in current directory for stop processes"
        callback()
    ],
    (err, results) ->
      throw err if err
      return results

  stop: ->
    processes = ['node', 'mongo']
    async.each(
      processes
      , (item, callback) =>
        @readPid item, (pid) =>
          try
            process.kill pid, 'SIGHUP'
            @writePid item, "0", (status) ->
              callback status
          catch err 
            throw err if err
            log.error "Not found process with pid #{pid}"
            callback null

      , (status) ->
        log.info "Application processes killed successfully"
        return true
    )

  restart: (callback) ->
    @stop (status) =>
      console.log status
      @start ->
        callback() 


  # Private class methods
  startNode: ->
    startDevNode = =>
      node = child.spawn(
        "node"
        , ["#{@dir}/node_modules/node-dev/bin/node-dev", "#{@dir}/server.js"]
        , { "env": {'NODE_ENV': 'development'} }
      )
      if node.stdout
        node.stdout.on 'data', (data) ->
          log.info '[node]' + data

      if node.stderr
        node.stderr.on 'data', (data) ->
          log.error '[node error]' + data

      node.on 'close', (data) ->
        log.info '[node]' + data

      @pids.node = node.pid
      return node

    startProdNode = =>
      forever.load { max: 10 }
      node = forever.startDaemon "#{@dir}/server.js"
      @pids.node = node.pid
      return node

    if @command is 'prod'
      node = startProdNode()
    else 
      node = startDevNode()
    return node


  startMongo: ->
    mongod = child.spawn 'mongod', 
      [
        "--dbpath", "#{@dir}/data/db", 
        "--logpath", "#{@dir}/data/db/mongo.log"
      ],
      { detached: true }
    mongod.stderr.on 'data', (data) ->
      process.stdout.write error('[mongo error] ') + data
    @pids.mongo = mongod.pid
    return mongod

  startGrunt: ->
    grunt = require "#{@dir}/node_modules/grunt"
    grunt.tasks ['default']

  readPid: (name, callback) =>
    fs.readFile "#{@pidsPath}/#{name}.pid", 'utf-8', (err, data) ->
      if err then callback null
      callback data
 
  writePid: (pidName, pidNum, callback) =>
    if not pidName
      throw new Error "No name of process"
    if not pidNum
      throw new Error "No pid of process"

    fs.writeFile "#{@pidsPath}/#{pidName}.pid", pidNum, (err) ->
      if err
        callback throw new Error "Write pids not possible. Check pids folder or folder permissions."
      else
        callback true

  startedCheck = (callback) ->
    return

  checkPidFile = (name, callback) ->
    path = "#{@options.dir}/data/pids/#{name}.pid"
    readPid = (callback) ->
      try
        fs.readFile path, 'uif-8', (err, content) ->
          if content isnt ""
            callback content
      finally
        callback null

    fs.exists path, (exists) ->
      if exists
        readPid (pid) ->
          callback pid
      else
        callback null