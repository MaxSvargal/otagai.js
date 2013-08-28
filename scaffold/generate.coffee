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
    console.log successMsg 'model', name


genController = (name) ->
  templatePath = "#{__dirname}/controller/controller.coffee.hbs"
  destPath = "#{basePath}/#{appPath}/controllers/#{name}.coffee"
  data =
    name: name

  writeTemplate templatePath, destPath, data, ->
    console.log successMsg 'controller', name

genScaffold = (name, fields) ->
  console.log basePath, name, fields

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

writeTemplate = (templatePath, destPath, data, callback) ->
  fs.readFile templatePath, 'utf8', (err, contents) ->
    compiled = handlebars.compile contents
    result = compiled data
    fs.writeFile destPath, result, (err) ->
      callback()

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
  "\u001b[32m #{type.toUpperCase()} #{name} successfully generated. \u001b[0m"
