scaffolt = require 'scaffolt'
@config = 
  generatorsPath: "scaffold"

exports.run = (type, name, options) ->
  @[type]?(name, options) ? console.log "\u001b[31m No generator type #{data.type} \u001b[0m"

exports.model = (name, options) ->
  scaffolt 'model', name, @config, (err) ->
    console.log 'Model generated!'
  return this

exports.controller = (name, options) ->
  scaffolt 'controller', name, @config, (err) ->
    console.log 'Controller generated!'
  return this

exports.scaffold = (name, options) ->
  scaffold 'scaffold', name, @config, (err) ->
    return