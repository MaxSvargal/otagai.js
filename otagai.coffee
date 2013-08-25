fs = require 'fs'
celeri = require 'celeri'
ncp = require('ncp').ncp || ncp.limit = 16

exports.run = ->
    celeri.option
        command: 'new :app'
        description: 'Create new application in current folder'
    , (data) ->
      initNew data

    celeri.option
        command: 'gen :type :name'
        description: 'Generate scaffolded modules'
    , (data) ->
      if data.type is 'scaffold'
        celeri.prompt(
          'Enter collection schema defined [name:type]:', 
          (input) ->
            celeri.exec
        )
      else
        generate data

    celeri.parse process.argv
    celeri.open()

initNew = (data) ->
    appFolder = process.cwd() + "/" + data.app
    ncp "#{__dirname}/src", appFolder, (err) ->
      throw err if err
      console.log "Otagai application '#{data.app}' successfully created."
      installDependencies data.app 

installDependencies = (app) ->
    terminal = require('child_process').spawn('bash')

    terminal.stdout.on 'data', (data) ->
      console.log 'npm: ' + data

    terminal.on 'exit', (code) ->
      console.log 'child process exited with code ' + code

    setTimeout( ->
        console.log 'Install npm dependencies...'
        terminal.stdin.write "cd ./#{app} && npm install"
        terminal.stdin.end()
    , 1000)

generate = (data) ->
  console.log data
  scaffold = require "#{__dirname}/scaffold/generate"
  scaffold.run data