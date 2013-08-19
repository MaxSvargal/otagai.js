class Otagai
	constructor: (args) ->
		console.log args
		###
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