Marionette = require 'backbone.marionette'

HeaderView = require '../header/header-view'
LoginView = require '../login/login-view'

UserModel = require '../model/user-model'

class LayoutView extends Marionette.LayoutView.extend()
  template: swig.compile require './layout'
  regions:
    header: '#header'
    content: '#content'
  initialize: (options)->
    # fake data , wait for backend
    unless @userModel
      @userModel = new UserModel
        username: 'Danny'
      console.log @userModel

  render: ->
    super
    @getRegion('header').show new HeaderView({
      model: @userModel.clone()
    })
    unless @userModel
      @getRegion('content').show new LoginView()

module.exports = LayoutView
