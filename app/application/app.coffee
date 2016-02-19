Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

config = require '../config'
Router = require '../router'
LayoutView = require '../layout/layout-view'

class AlbumApp extends Marionette.Application.extend()
  initialize: (opts)->
    @on 'start', ->
      router = new Router()
      Backbone.history.start()
    layoutView = new LayoutView()
    @addRegions {app: '#app'}
    @getRegion('app').show layoutView
    config.layoutView = layoutView

module.exports = AlbumApp
