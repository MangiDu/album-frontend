Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

config = require '../config'
Router = require '../router'
LayoutView = require '../layout/layout-view'

class AlbumApp extends Marionette.Application.extend()
  initialize: (opts)->
    @on 'start', ->
      router = new Router()
      config.router = router

      layoutView = new LayoutView()
      config.layoutView = layoutView

      @addRegions {app: '#app'}
      @getRegion('app').show layoutView

      Backbone.history.start()

module.exports = AlbumApp
