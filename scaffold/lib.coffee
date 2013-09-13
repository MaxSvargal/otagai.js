'use strict'

handlebars = require 'handlebars'
fs = require 'fs'

class Scaffold
  constructor: (options) ->
    require './helpers'
    @options = options
    @paths = @options.paths
    if typeof @[@options.type] is 'function'
      @[@options.type]()
    else
      console.log "\u001b[31m No generator type #{@options.type} \u001b[0m"

  scaffold: ->
    @model =>
      @controller()
      @views()

  model: (callback) ->
    getFieldsObj = (fields) ->
      outFields = []
      for field, i in fields
        splitted = field.split ':'
        outFields[i] = {}
        outFields[i].name = splitted[0]
        outFields[i].type = splitted[1]
        i++
      {fields: outFields}

    @getTemplateFn @paths.model.from, (templateFn) =>
      data = getFieldsObj @options.fields
      @writeTemplate(
        @paths.model.to,
        templateFn,
        data
        , =>
          @successMsg @paths.model.to
          callback()
      )

  controller: ->
    writeRouters = =>
      data =
        name: @options.name
        fields: @options.fields
      @getTemplateFn @paths.controller.routes_from, (templateFn) =>
        fs.appendFile(
          @paths.controller.routes_to,
          templateFn(data),
          (err) =>
            if err then throw err
            @successMsg @paths.controller.routes_to
        )

    @getTemplateFn @paths.controller.from, (templateFn) =>
      @writeTemplate(
        @paths.controller.to,
        templateFn,
        [], =>
          @successMsg @paths.controller.to
          writeRouters()
      )

  views: ->
    getSchema = (callback) =>
      fs.readFile @paths.views.model, 'utf8', (err, content) ->
        if err then throw err
        globalRegex = /@param \[([a-z]+)\] ([a-z]+)/g
        matchRegex = /\[([a-z]+)\] ([a-z]+)/
        matches = content.match globalRegex
        if matches is null
          return throw "\u001b[31m No documented items in model. Try to generate model with otagai gen or scaffold command. \u001b[0m"
        results = []
        for item, i in matches
          result = item.match matchRegex
          results[i] = {}
          results[i].type = result[1]
          results[i].field = result[2]
        callback {fields: results}

    genTemplate = (from, to, data) =>
      @getTemplateFn from, (templateFn) =>
        @writeTemplate(to, templateFn, data, =>
            @successMsg to
        )

    getSchema (fields) =>
      fs.mkdir @paths.views.to, =>
        fs.readdir @paths.views.from, (err, files) =>
          for file in files
            fileName = file.split '.'
            resultFileName = fileName[0] + '.' + fileName[1]
            genTemplate(
              @paths.views.from + "/#{file}",
              @paths.views.to + "/#{resultFileName}",
              fields
            )

  getTemplateFn: (templatePath, callback) ->
    fs.readFile templatePath, 'utf8', (err, contents) ->
      if err then throw err
      callback handlebars.compile(contents)
    
  writeTemplate: (destPath, templateFn, data, callback) ->
    if not data then data = []
    data.name = @options.name
    content = templateFn data
    fs.writeFile destPath, content, (err) ->
      if err then throw err
      callback()

  successMsg: (dest) ->
    console.log "\u001b[32m #{@options.type} #{dest} successfully generated. \u001b[0m"


module.exports = Scaffold