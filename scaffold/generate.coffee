'use strict'

Scaffold = require './lib'
basePath = process.cwd()
srcPath = __dirname
appPath = 'app'

exports.run = (type, name, options) ->
  new Scaffold {
    type: type
    name: name
    fields: options.fields
    paths:
      model: 
        from: "#{srcPath}/model/model.coffee.hbs"
        to: "#{basePath}/#{appPath}/models/#{name}.coffee"
      controller:
        from: "#{srcPath}/controller/controller.coffee.hbs"
        to: "#{basePath}/#{appPath}/controllers/#{name}.coffee"
        routes_from: "#{srcPath}/controller/routes.coffee.hbs"
        routes_to: "#{basePath}/config/routes.coffee"
      views:
        from: "#{srcPath}/views"
        to: "#{basePath}/#{appPath}/views/#{name}s"
        model: "#{basePath}/#{appPath}/models/#{name}.coffee"
  }