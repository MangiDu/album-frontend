Marionette = require 'backbone.marionette'

class AlbumItemView extends Marionette.ItemView.extend()
  template: swig.compile require './album-item'

module.exports = AlbumItemView
