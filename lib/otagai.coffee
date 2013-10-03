'use strict'

fs = require 'fs'
program = require 'commander'
exec = require 'child_process'
mongoose = require 'mongoose'
clc = require 'cli-color'
ncp = require('ncp').ncp || ncp.limit = 16
processManager = require "#{__dirname}/utils/process_manager"
scaffold = require "#{__dirname}/utils/scaffold/generate"
createUser = require "#{__dirname}/utils/create_user"
appDir = process.cwd()
processes = {}
error = clc.red.bold
notice = clc.cyanBright
success = clc.green

exports.init = ->
  # Main command for init new application
  program
    .command('new <name>')
    .description('Create now application with <name>')
    .action (name, options) ->
      createNewApp name

  # Alias for start shell scripts
  # TODO: write separated realization
  program
    .command('server <command>')
    .description('Manage server processes [dev, prod, stop, restart, start <environment>]')
    ##TODO: -dle flags
    .option('-e, --environment', 'Start server with custom environment')
    .option('-d, --database', 'Path to database on filesystem')
    .option('-l, --logs', 'Path to logs of mongo and forever')
    .option('-f, --force', 'Force restart with kill all node and mongo processes')
    .action (command, options) ->
      switch command
        when 'stop' then processManager.stop options
        when 'restart' then processManager.restart options
        else processManager.start command

  # Create user
  # otagai createuser -u admin -e admin@otag.ai -p admin
  program
    .command('createuser')
    .option('-u, --username <username>')
    .option('-e, --email <email>')
    .option('-p, --password <password>')
    .description('Create new user with all privileges.')
    .action (options) ->
      options.appDir = appDir
      new createUser options

  ###
  # CLI command: 
  #  otagai gen model test -f name:string,count:number
  # Types list:
  #  string, number, date, buffer, boolean, mixed, objectid, array
  #  More documentation: http://mongoosejs.com/docs/schematypes.html
  ### 
  program
    .command('gen <type> <name>')
    .description('Generate scaffold modules')
    .option('-f, --fields <items>', 'Collection fields list', (val) -> val.split ',')
    .action (type, name, options) ->
      scaffold.run type, name, options

  program.parse process.argv

# Create copy of application to current folder
createNewApp = (name) ->
  appFolder = appDir + "/" + name
  ncp "#{__dirname}/src", appFolder, (err) ->
    throw err if err
    console.log success("Otagai application #{name} successfully created.")
    installAppDependencies name

# Install npm packages for new application
installAppDependencies = (name) ->
  terminal = exec.spawn('bash')

  terminal.stdout.on 'data', (data) ->
    console.log notice('npm: ') + data

  terminal.on 'exit', (code) ->
    if code is 0
      console.log success("Application ready. Switch to folder and type 'otagai server dev'")
    else
      console.log error('child process exited with code ' + code)

  setTimeout( ->
      console.log notice('Install npm dependencies...')
      terminal.stdin.write "cd ./#{name} && npm install"
      terminal.stdin.end()
  , 1000)