Marionette = require 'backbone.marionette'

class LoginView extends Marionette.ItemView.extend()
  template: swig.compile require './login'

module.exports = LoginView
