Marionette = require 'backbone.marionette'
Swig = swig

class LayoutView extends Marionette.LayoutView.extend()
  template: Swig.compile require './layout'
  regions:
    header: '#header'
    content: '#content'
  render: ->
    super
    console.log 'layoutView is rendered'
    # @getRegion('header').show new HeaderView()

module.exports = LayoutView
