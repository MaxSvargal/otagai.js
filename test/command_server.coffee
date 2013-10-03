processManager = require '../commands/process_manager.coffee'

describe 'Instance is initiated', ->
  it 'application shouid have a name and environment', ->
    manager = new processManager 'otagai', 'dev'
    manager.name.should.equal 'otagai'
    manager.command.should.equal 'dev'