fs = require 'fs'
program = require 'commander'
exec = require 'child_process'
mongoose = require 'mongoose'
clc = require 'cli-color'
ncp = require('ncp').ncp || ncp.limit = 16
processManager = require "#{__dirname}/commands/process_manager"
scaffold = require "#{__dirname}/commands/scaffold/generate"
appDir = process.cwd()
processes = {}
error = clc.red.bold
notice = clc.cyanBright
success = clc.green

exports.run = ->
  # Main command for init new application
  program
    .command('new <name>')
    .description('Create now application with <name>')
    .action (name, options) ->
      createNew name

  # Alias for start shell scripts
  # TODO: write separated realization
  program
    .command('server <env>')
    .description('Start server with <environment>')
    .option('-s, --stop', 'Stop server')
    .option('-rs, --restart', 'Restart server')
    .option('-f, --force', 'Force restart with kill all node and mongo processes')
    .action (env, options) ->
      if !processes[env]
        processes[env] = processManager.register env, options
      pm = processes[env]
      if options.stop or env is 'stop'
        pm.stop()
      else if options.restart or env is 'restart'
        if options.force then force = true
        else forse = false
        pm.restart(force)
      else
        pm.start()
  
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
      createUser = require "#{__dirname}/commands/create_user"
      new createUser options

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
    .option('-f, --fields <items>', 'Collection fields list', (val) ->
      val.split ','
    )
    .action (type, name, options) ->
      scaffold.run type, name, options

  program.parse process.argv

# Create copy of application to current folder
createNew = (name) ->
    appFolder = appDir + "/" + name
    ncp "#{__dirname}/src", appFolder, (err) ->
      throw err if err
      console.log success("Otagai application '#{name}' successfully created.")
      installDependencies name 

installDependencies = (app) ->
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
        terminal.stdin.write "cd ./#{app} && npm install"
        terminal.stdin.end()
    , 1000)