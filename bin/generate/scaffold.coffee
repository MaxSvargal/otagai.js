_ = require 'underscore'
fs = require 'fs'

_.templateSettings = 
	interpolate : /\{\{(.+?)\}\}/g

class ScaffoldGenerator
	genController: (name, params) ->
		templatePath = "#{__dirname}/templates/controllerTemplate.coffee"
		outputPath = "#{__dirname}/output/controllers/#{name}.coffee"
		@generate templatePath, outputPath, params

	genModel: (name, params) ->
		templatePath = "#{__dirname}/templates/modelTemplate.coffee"
		outputPath = "#{__dirname}/output/model/#{name}.coffee"
		@generate templatePath, outputPath, params

	generate: (templatePath, outputPath, params) ->
		fs.readFile templatePath, (err, data) ->
			if err throw err
			compilied = _.template data, params
			fs.writeFile outputPath, compilied, (err) ->
				if err throw err
				console.log 'success write controller template'


scaffold = new ScaffoldGenerator
scaffold.genController 'demo', ->
	name: 'Demo'
	test: 'test string'
	test2: 'second test'