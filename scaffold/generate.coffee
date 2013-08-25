scaffolt = require 'scaffolt'
@config = 
  generatorsPath: "scaffold"

exports.run = (data) ->
  console.log data
  @[data.type]?(data) ? console.log "\u001b[31m No generator type #{data.type} \u001b[0m"

exports.model = (data) ->
  scaffolt 'model', data.name, @config, (err) ->
    console.log 'Model generated!'
  return this

exports.controller = (data) ->
  scaffolt 'controller', data.name, @config, (err) ->
    console.log 'Controller generated!'
  return this

exports.scaffold = (data) ->
  scaffold 'scaffold', data.name, @config, (err) ->
    return