fs = require 'fs'
celeri = require 'celeri'
ncp = require('ncp').ncp || ncp.limit = 16

exports.run = ->
    celeri.option
        command: 'new :app'
        description: 'Create new application in current folder'
    , (data) ->
      initNew data

    celeri.parse process.argv

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

scaffold = ->
  # Set {{}} variables tags for underscore template function
  _.templateSettings =
    interpolate : /\{\{(.+?)\}\}/g
  fs.readFile '../src/app/controllers/articles.coffee', 'utf8', (err, data) ->
    throw err if err
    compiled = _.template data, {test: "HELLO, OTAGAI!"}