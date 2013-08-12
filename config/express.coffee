express = require('express')
mongoStore = require('connect-mongo')(express)
flash = require('connect-flash')
helpers = require('view-helpers')
path = require('path')
stylus = require('stylus')
fluidity = require('fluidity')

module.exports = (app, config, passport) ->
  assets = config.root + '/assets'
  
  app.set('showStackError', true)

  app.use(express.compress({
    filter: (req, res) ->
      return /json|text|javascript|css/.test(res.getHeader('Content-Type'))
    level: 9
  }))
  
  app.set('views', config.root + '/app/views')
  app.set('view engine', 'jade')

  app.configure ->
    app.use(helpers(config.app.name))
    app.use(express.cookieParser())
    app.use(express.bodyParser())
    
    # Support for using PUT, DEL etc. in forms using hidden _method field
    app.use(express.methodOverride())

    app.use(express.session({
      secret: 'p8zztgch48rehu79jskhm6aj3',
      store: new mongoStore({
        url: config.db,
        collection : 'sessions'
      })
    }))

    app.use(stylus.middleware(
      src: assets
      compile: (str, path) ->
        stylus(str)
          .set('filename', path)
          .set('compress', true)
          .use(fluidity())
    ))

    app.use(express.favicon(path.join(assets, 'img/favicon.ico')))

    app.use(flash())

    app.use(passport.initialize())
    app.use(passport.session())

    app.use(express.static(assets))
    app.use(express.static(__dirname + "/data/uploads"))
    app.use(require('connect-assets')())

    app.use(app.router)
    return

  app.configure 'development', ->
    console.log 'Configuring development environment'
    app.use express.errorHandler({ dumpExceptions: true, showStack: true })
    app.locals.pretty = true
    return

  app.configure 'production', ->
    console.log 'Configuring production environment'
    app.use express.errorHandler()
    return
    
  return