'use strict'

handlebars = require 'handlebars'
fs = require 'fs'
basePath = process.cwd()
appPath = 'app'

exports.run = (type, name, options) ->
  registerHelpers()
  switch type
    when 'model' then genModel name, options.fields
    when 'controller' then genController name
    when 'views' then genViews name
    when 'scaffold' then genScaffold name, options.fields
    else 
      console.log "\u001b[31m No generator type #{type} \u001b[0m"

genModel = (name, fields) ->
  templatePath = "#{__dirname}/model/model.coffee.hbs"
  destPath = "#{basePath}/#{appPath}/models/#{name}.coffee"
  data =
    name: name
    fields: getFieldsObj fields

  writeTemplate templatePath, destPath, data, ->
    console.log successMsg 'model', destPath

genController = (name) ->
  templatePath = "#{__dirname}/controller/controller.coffee.hbs"
  destPath = "#{basePath}/#{appPath}/controllers/#{name}.coffee"
  data =
    name: name
  writeTemplate templatePath, destPath, data, ->
    console.log successMsg 'controller', destPath

genViews = (model) ->
  # Get schema from model
  modelPath = "#{basePath}/#{appPath}/models/#{model}.coffee"
  fs.readFile modelPath, 'utf8', (err, content) ->
    if err then throw err
    globalRegex = /@param \[([a-z]+)\] ([a-z]+)/g
    matchRegex = /\[([a-z]+)\] ([a-z]+)/
    matches = content.match globalRegex
    results = []
    for item, i in matches
      result = item.match matchRegex
      results[i] = {}
      results[i].type = result[1]
      results[i].field = result[2]
    data =
      name: model
      fields: results

    # Write templates
    templatePath = "#{__dirname}/views"
    destPath = "#{basePath}/#{appPath}/views/#{model}"
    fs.mkdir destPath, ->
      fs.readdir templatePath, (err, files) ->
        for file in files
          fileName = file.split '.'
          resultFileName = fileName[0] + '.' + fileName[1]
          writeTemplate(
            "#{templatePath}/#{file}", 
            "#{destPath}/#{resultFileName}", 
            data, (destPath) ->
              console.log successMsg 'view', destPath
          )

genScaffold = (name, fields) ->
  console.log "wait... oh shi~"

writeTemplate = (templatePath, destPath, data, callback) ->
  fs.readFile templatePath, 'utf8', (err, contents) ->
    compiled = handlebars.compile contents
    result = compiled data
    fs.writeFile destPath, result, (err) ->
      callback(destPath)

getFieldsObj = (fields) ->
  outFields = []
  for field, i in fields
    splitted = field.split ':'
    outFields[i] = {}
    outFields[i].name = splitted[0]
    outFields[i].type = splitted[1]
    i++
  outFields

successMsg = (type, name) ->
  "\u001b[32m #{type} #{name} successfully generated. \u001b[0m"

registerHelpers = ->
  handlebars.registerHelper 'camelize', (->
    camelize = (string) ->
      regexp = /[-_]([a-z])/g
      rest = string.replace(regexp, (match, char) ->
        char.toUpperCase()
      )
      rest[0].toUpperCase() + rest.slice 1

    (options) ->
      new handlebars.SafeString camelize(options.fn(this))
  )()

  handlebars.registerHelper('equal', (value, type, options) ->
    if arguments.length < 3
      throw new Error "Need 2 parameners"
    if value isnt type
      options.inverse @
    else 
      options.fn @
  )