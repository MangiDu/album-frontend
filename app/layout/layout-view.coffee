Marionette = require 'backbone.marionette'

HeaderView = require '../header/header-view'
LoginView = require '../login/login-view'

class LayoutView extends Marionette.LayoutView.extend()
  template: swig.compile require './layout'
  regions:
    header: '#header'
    content: '#content'
  # initialize: (options)->
  #   unless @userModel
  #
  render: ->
    super
    @getRegion('header').show new HeaderView()
    unless @userModel
      @getRegion('content').show new LoginView()

module.exports = LayoutView
