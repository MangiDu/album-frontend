Marionette = require 'backbone.marionette'
Util = require '../util/util'

HeaderView = require '../header/header-view'
HomeView = require '../home/home-view'

UserModel = require './user-model'

class LayoutView extends Marionette.LayoutView.extend()
  template: swig.compile require './layout'
  regions:
    header: '#header'
    content: '#content'
  initialize: (options)->
    unless @userModel
      userData = options.userData
      @userModel = new UserModel userData
      console.log @userModel

  render: ->
    super
    # 要传clone后的model还是同一个model？可能会有同步问题？再想想
    @getRegion('header').show new HeaderView({
      model: @userModel.clone()
    })
    @getRegion('content').show new HomeView({
      model: @userModel.clone()
    })

module.exports = LayoutView
