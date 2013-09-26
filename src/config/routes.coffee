module.exports = (app, config, passport, auth) ->
  
  # Include controllers
  fs = require 'fs'
  controllers_path = config.root + '/app/controllers'
  fs.readdirSync(controllers_path).forEach (file) ->
    @[file.slice(0, -7)] = require "#{controllers_path}/#{file}"


  # User routes
  app.get '/login', users.login

  app.post '/login', passport.authenticate('local',
    failureRedirect: '/login'
    failureFlash: true),
    (req, res) ->
      res.redirect '/'
      return

  app.get '/logout', users.logout
  
  app.get '/users', auth.requiresLogin, users.index
  app.get '/users/new', auth.requiresLogin, users.new
  app.post '/users', auth.requiresLogin, users.create
  app.get '/users/:userId/edit', auth.requiresLogin, users.edit
  app.put '/users/:userId', auth.requiresLogin, users.update
  app.get '/users/:userId/destroy', auth.requiresLogin, users.destroy

  app.param 'userId', users.user

  # Article routes
  app.get '/', articles.index
  app.get '/articles', articles.manage
  app.get '/articles/new', auth.requiresLogin, articles.new
  app.get '/articles/:articleId', articles.show
  app.post '/articles', auth.requiresLogin, articles.create
  app.get '/articles/:articleId/edit', auth.requiresLogin, articles.edit
  app.put '/articles/:articleId', auth.requiresLogin, articles.update
  app.get '/articles/:articleId/destroy', auth.requiresLogin, articles.destroy

  app.param 'articleId', articles.article

  # Demo routes
  app.get '/', demos.index
  app.get '/demos', demos.manage
  app.get '/demos/new', auth.requiresLogin, demos.new
  app.get '/demos/:demoId', demos.show
  app.post '/demos', auth.requiresLogin, demos.create
  app.get '/demos/:demoId/edit', auth.requiresLogin, demos.edit
  app.put '/demos/:demoId', auth.requiresLogin, demos.update
  app.get '/demos/:demoId/destroy', auth.requiresLogin, demos.destroy

  app.param 'demoId', demos.demo