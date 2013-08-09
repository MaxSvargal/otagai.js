module.exports = (grunt) ->

  grunt.initConfig
    coffeelint:
      app: ['app/**/*.coffee', 'config/**/*.coffee']

    bgShell:
      dev_server:
        cmd: 'NODE_ENV=development ./node_modules/node-dev/bin/node-dev server'
        stdout: true
        stderr: true
        bg: true
      mongo:
        cmd: 'mongod --dbpath ./data/db'
        bg: true

    watch:
      files: [
        'assets/css/**/*.styl'
        'assets/js/**/*.coffee'
        'assets/img/**/*'
        'app/views/**/*.jade'
      ]
      options:
        livereload: true


  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-bg-shell'

  grunt.registerTask 'default', [
    'coffeelint'
    'bgShell:mongo'
    'bgShell:dev_server'
    'watch'
  ]