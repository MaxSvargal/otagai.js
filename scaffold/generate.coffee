scaffolt = require 'scaffolt'

exports.controller = (data) ->
  console.log data
  config = 
      generatorsPath: "scaffold"

  scaffolt 'controller', data.name, config, (err) ->
    console.log 'Reverted!'