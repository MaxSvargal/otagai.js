forever = require 'forever-monitor'

appDir = process.cwd()
pkg = require "#{appDir}/package.json"

class processManager
  constructor: (name, env, options) ->
    @name = name
    @env = env
    @options = options

  start: ->
    console.log "Started app #{@name} with envionment #{@env}"
    @startMongo()
    @startNode()

  startNode: ->
    @nodeChild = new (forever.Monitor) "#{appDir}/server.js", {
      silent: true
      pidPath: "#{__dirname}/processes.pid"
      env:
        'NODE_ENV': 'development'
    }
    @nodeChild.on 'exit', ->
      console.log "Node precess exited"
    @nodeChild.start()
    console.log @nodeChild

  startMongo: ->
    @mongoChild = forever.start ["mongod --dbpath #{appDir}/data/db --logpath #{appDir}/data/db/mongo.log"], {
      #silent: true
      max: 1
    }

  stop: ->
    console.log forever
    forever.kill @nodeChild
    #@mongoChild.stop()
    #@nodeChild.stop()

exports.register = (env, options) ->
  new processManager pkg.name, env, options

exports.list = (options) ->
  forever.list true, (processes) ->
    console.log "PROCESSES: ", processes

###
module.exports = processManager
###