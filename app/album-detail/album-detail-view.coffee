require './photo-style'

Marionette = require 'marionette'
PhotoView = require './photo-view'

class AlbumDetailView extends Marionette.CollectionView.extend()
  childView: PhotoView
  className: 'photo-list'

module.exports = AlbumDetailView
