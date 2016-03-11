require './photo-style'

Marionette = require 'marionette'
PhotoView = require './photo/photo-view'

class AlbumDetailView extends Marionette.CompositeView.extend()
  template: swig.compile require './album-detail'
  childView: PhotoView
  childViewContainer: '.photo-list'

module.exports = AlbumDetailView
