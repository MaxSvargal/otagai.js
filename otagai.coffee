fs = require 'fs'
program = require 'commander'
ncp = require('ncp').ncp || ncp.limit = 16

exports.run = ->
  list = (val) ->
    val.split ','

  # Main command for init new application
  program
    .command('new <name>')
    .description('Create now application with <name>')
    .action (name, options) ->
      createNew name

  ###
    CLI command: 
      otagai gen model test -f name:string,count:number
    Types list:
      string, number, date, buffer, boolean, mixed, objectid, array
      More documentation: http://mongoosejs.com/docs/schematypes.html
  ### 
  program
    .command('gen <type> <name>')
    .description('Generate scaffold modules')
    .option('-f, --fields <items>', 'Collection fields list', list)
    .action (type, name, options) ->
      scaffold = require "#{__dirname}/scaffold/generate"
      scaffold.run type, name, options

  program.parse process.argv


# Create copy of application to current folder
createNew = (name) ->
    appFolder = process.cwd() + "/" + name
    ncp "#{__dirname}/src", appFolder, (err) ->
      throw err if err
      console.log "Otagai application '#{name}' successfully created."
      installDependencies name 

installDependencies = (app) ->
    terminal = require('child_process').spawn('bash')

    terminal.stdout.on 'data', (data) ->
      console.log 'npm: ' + data

    terminal.on 'exit', (code) ->
      if code is 0
        console.log "Application ready. Switch to folder and run /bin/dev.sh"
      else
        console.log 'child process exited with code ' + code

    setTimeout( ->
        console.log 'Install npm dependencies...'
        terminal.stdin.write "cd ./#{app} && npm install"
        terminal.stdin.end()
    , 1000)