mongoose = require 'mongoose'
_ = require 'underscore'

Demo = mongoose.model 'Demo'

#
# New demo form
#
exports.new = (req, res) ->
  res.render 'demos/new',
    demo: new Demo({})
  return

#
# Create new demo
#
exports.create = (req, res) ->
  demo = new Demo req.body
  demo.save (err) ->
    if err
      res.render 'demos/new',
        errors: err.errors
        demo: demo
    res.redirect '/demos'
    return
  return

exports.show = (req, res) ->
  undefined

#
# Demo edit form
#
exports.edit = (req, res) ->
  demo = req.demo
  res.render 'demos/edit',
    demo:demo
  return

#
# Update demo
#
exports.update = (req, res) ->
  demo = req.demo
  
  demo = _.extend demo, req.body
  demo.save (err) ->
    if err
      res.render 'demos/edit',
        demo:demo
        errors: err.errors
    else
      req.flash 'notice', demo.title + ' was successfully updated.'
      res.redirect '/demos'
    return
  return

#
# Delete demo
#
exports.destroy = (req, res) ->
  demo = req.demo
  demo.remove (err) ->
    req.flash 'notice', demo.title + ' was successfully deleted.'
    res.redirect '/demos'

#
# Manage demos
#
exports.manage = (req, res) ->
  Demo.list (err, demos_list) ->
    res.render 'demos/manage',
      all_demos: demos_list
      message: req.flash 'notice'
    return

#
# Demos index
#
exports.index = (req, res) ->
  Demo.list (err, demos_list) ->
    res.render 'demos/index',
      all_demos: demos_list
  return

#
# Find demo by ID
#
exports.demo = (req, res, next, id) ->
  Demo.findById(id).exec (err, demo) ->
    return next err if err
    return next new Error 'Failed to load demo' if not demo
      
    req.demo = demo
    next()
    return
  return
