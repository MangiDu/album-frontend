Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

config = require '../config'
Router = require '../router'
LayoutView = require '../layout/layout-view'

class AlbumApp extends Marionette.Application.extend()
  initialize: (opts)->
    @on 'start', ->
      me = @
      $.ajax
        url: '/api/user'
        method: 'GET'
        success: (data)->
          console.log data

          router = new Router()
          config.router = router

          layoutView = new LayoutView
            userData: data
          config.layoutView = layoutView

          me.addRegions {app: '#app'}
          me.getRegion('app').show layoutView

          Backbone.history.start()
        error: (data)->
          console.log data
          # TODO:FIX...
          # 不使用express而单独用browserysync会死循环额...
          # window.location.href = '/'

module.exports = AlbumApp
