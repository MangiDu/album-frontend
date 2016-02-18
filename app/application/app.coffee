Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

AlbumApp = Marionette.Application.extend
  initialize: (opts)->
    console.log 'AlbumApp initialized'
    console.log opts
    @on 'start', ->
      console.log 'Backbone.history.start'
      Backbone.history.start()

module.exports = AlbumApp
