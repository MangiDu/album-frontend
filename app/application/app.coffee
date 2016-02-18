Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

Router = require '../router'
LayoutView = require '../layout/layout-view'

AlbumApp = Marionette.Application.extend
  initialize: (opts)->
    console.log 'AlbumApp initialized'
    @on 'start', ->
      router = new Router()
      Backbone.history.start()
    layoutView = new LayoutView()
    @addRegions {app: '#app'}
    @getRegion('app').show layoutView

module.exports = AlbumApp
