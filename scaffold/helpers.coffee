'use strict'

handlebars = require 'handlebars'

handlebars.registerHelper 'camelize', (->
  camelize = (string) ->
    regexp = /[-_]([a-z])/g
    rest = string.replace(regexp, (match, char) ->
      char.toUpperCase()
    )
    rest[0].toUpperCase() + rest.slice 1

  (options) ->
    new handlebars.SafeString camelize(options.fn @)
)()

handlebars.registerHelper('equal', (value, type, options) ->
  if arguments.length < 3
    throw new Error "Need 2 parameners"
  if value isnt type
    options.inverse @
  else 
    options.fn @
)

handlebars.registerHelper('tovar', (options) ->
  '#{' + options.fn(@) + '}'
)