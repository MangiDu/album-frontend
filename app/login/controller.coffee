config = require '../config'
LoginView = require './login-view'

module.exports = ->
  console.log 'login controller'
  layoutView = config.layoutView
  layoutView.getRegion('content').show new LoginView()
