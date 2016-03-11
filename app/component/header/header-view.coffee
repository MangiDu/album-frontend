Marionette = require 'backbone.marionette'

class HeaderView extends Marionette.ItemView.extend()
  template: swig.compile require './header'

module.exports = HeaderView
