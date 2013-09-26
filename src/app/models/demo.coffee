mongoose = require 'mongoose'

#
# Demo Schema
#
Schema = mongoose.Schema

###
# Mongoose model schema
# Parameters for views generator
# @param [string] name
# @param [number] count
###

DemoSchema = new Schema
  name:
    type: String
  count:
    type: Number
 
#
# Schema statics
#
DemoSchema.statics =
  list: (cb) ->
    this.find().sort
      createdAt: -1
    .exec(cb)
    return

Demo = mongoose.model 'Demo', DemoSchema