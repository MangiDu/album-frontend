Marionette = require 'backbone.marionette'
Util = require '../util/util'

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
      options.userData.id = options.userData._id
      @userModel = new UserModel options.userData
      console.log @userModel

  render: ->
    super
    # 要传clone后的model还是同一个model？可能会有同步问题？再想想
    @getRegion('header').show new HeaderView({
      model: @userModel.clone()
    })

    # Util.redirectTo('login')
    # unless @userModel
    #   # @getRegion('content').show new LoginView()
    #   Util.redirectTo('login')
    # else
    #   Util.redirectTo('home')

module.exports = LayoutView
