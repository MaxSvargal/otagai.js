fs = require 'fs'
celeri = require 'celeri'
ncp = require('ncp').ncp || ncp.limit = 16

exports.run = ->
    celeri.option
        command: 'init'
        description: 'Initiated application in current folder'
    , (data) ->
      initNew()

    if process.argv.length <= 2
      console.log 'Type "otagai help" for information.\n'
      process.exit 1
    else
      celeri.parse process.argv

initNew = ->
    console.log "Initiated!"
    ncp "#{__dirname}/src", process.cwd() + "/temp", (err) ->
      throw err if err
      console.log 'Copy done!'

    ###
    # Set {{}} variables tags for underscore template function
    _.templateSettings =
      interpolate : /\{\{(.+?)\}\}/g
    fs.readFile '../src/app/controllers/articles.coffee', 'utf8', (err, data) ->
      throw err if err
      compiled = _.template data, {test: "HELLO, OTAGAI!"}
      console.log compiled
    console.log "WUT?"

    // run npm install in folder
    var terminal = require('child_process').spawn('bash');

    terminal.stdout.on('data', function (data) {
        console.log('stdout: ' + data);
    });

    terminal.on('exit', function (code) {
            console.log('child process exited with code ' + code);
    });

    setTimeout(function() {
        console.log('Sending stdin to terminal');
        terminal.stdin.write('echo "Hello $USER"');
        terminal.stdin.end();
    }, 1000);
    ###