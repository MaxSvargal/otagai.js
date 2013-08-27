module.exports = (grunt) ->

  grunt.initConfig
    coffeelint:
      app: ['app/**/*.coffee', 'config/**/*.coffee']

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

  grunt.registerTask 'default', [
    'coffeelint'
    'watch'
  ]