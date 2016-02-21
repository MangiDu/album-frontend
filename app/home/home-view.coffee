Marionette = require 'backbone.marionette'

class HomeView extends Marionette.CompositeView.extend()
  template: swig.compile require './home'

module.exports = HomeView
