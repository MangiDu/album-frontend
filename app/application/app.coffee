Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

Router = require '../router'

AlbumApp = Marionette.Application.extend
  initialize: (opts)->
    console.log 'AlbumApp initialized'
    @on 'start', ->
      router = new Router()
      Backbone.history.start()

module.exports = AlbumApp
