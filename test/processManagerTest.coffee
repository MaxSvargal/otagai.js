path = require 'path'
util = require 'util'
processManager = require '../lib/utils/process_manager.coffee'

describe 'Process Manager', ->
  pm = new processManager path.join(__dirname, '/../src'), 'dev'

  it 'should be an instance of process manager', ->
    pm.should.be.an.instanceof processManager

  it 'should be have #start', ->
    pm.start.should.be.a 'function'

  describe '#start', ->
    it '#startMongo should return number pid', ->
      mongo = pm.startMongo()
      mongo.pid.should.be.a 'number'

    it '#startNode should return number pid', ->
      node = pm.startNode()
      node.pid.should.be.a 'number'

  describe '#stop', ->
    it 'should be a function', ->
      pm.stop.should.be.a 'function'
    ###
    it 'should return true', ->
      pm.stop (callback) ->
        callback.should.be.true

    it 'should not return error', ->
      pm.stop.should.not.throw()
    ###

  describe '#writePid', ->
    it 'should be a function', ->
      pm.writePid.should.be.a 'function'

    it 'should return true', ->
      pm.writePid 'node', '101010', (callback) ->
        callback.should.be.true

  describe '#readPid', ->
    it 'should be a Function', ->
      pm.readPid.should.be.a 'function'

    it 'should return number pid', ->
      pm.readPid 'node', (callback) ->
        callback.should.eql '101010'

###
    describe '#checkPidFile', ->
      it 'should return string', (done) ->
        pm.checkPidFile 'node', (pid) ->
          pid.should.be.a 'string'
###