fs = require 'fs'
program = require 'commander'
exec = require 'child_process'
mongoose = require 'mongoose'
ncp = require('ncp').ncp || ncp.limit = 16

appDir = process.cwd()

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
    .action (name, options) ->
      if options.stop is true
        exec.exec 'killall node'
      else
        exec.spawn 'sh', ['-c', 'chmod +x ./bin/dev.sh && ./bin/dev.sh'], {stdio: 'inherit'}
  
  # Create superuser
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
      scaffold = require "#{__dirname}/scaffold/generate"
      scaffold.run type, name, options

  program.parse process.argv

# Create copy of application to current folder
createNew = (name) ->
    appFolder = appDir + "/" + name
    ncp "#{__dirname}/src", appFolder, (err) ->
      throw err if err
      console.log "Otagai application '#{name}' successfully created."
      installDependencies name 

installDependencies = (app) ->
    terminal = exec.spawn('bash')

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