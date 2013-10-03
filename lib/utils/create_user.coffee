'use strict'

mongoose = require 'mongoose'
bcrypt = require 'bcrypt'

class createUser
  constructor: (options) ->
    @options = options
    config = require("#{@options.appDir}/config/environment")['development']
    mongoose.connect config.db
    @getSchema()
    @create()

  getSchema: ->
    # Schema import doesn't work. Fix it!
    #userSchema = require "#{@options.appDir}/app/models/user"
    userSchema = @createSchema()
    @User = mongoose.model 'User', userSchema

  # Create user schema. Temporary(?) solution
  createSchema: ->
    Schema = mongoose.Schema
    UserSchema = new Schema
      name:
        type: String
        required: true
      email:
        type: String
        required: true
      username:
        type: String
        required: true
        unique: true
      password:
        type: String
        required: true
      created:
        type: Date
        default: Date.now

    # Hash password before saving
    UserSchema.pre 'save', (next) ->
      user = this
      SALT_WORK_FACTOR = 10
      if !user.isModified 'password'
        console.log 'Password not modified'
        return next()
      return next() unless user.isModified 'password'
      bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
        return next err if err
        bcrypt.hash user.password, salt, (err, hash) ->
          return next err if err
          user.password = hash
          next()
          return
        return
    return UserSchema

  create: ->
    user = new @User
      username: @options.username
      password: @options.password
      email: @options.email
      name: @options.username
    user.save (err) =>
      if err
        console.log err
      else
        console.log "User #{@options.username} successfully created."
        mongoose.connection.close()

module.exports = createUser