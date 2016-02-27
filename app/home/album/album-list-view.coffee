Marionette = require 'backbone.marionette'
AlbumItemView = require './album-item-view'

require './album-style'

class AlbumListView extends Marionette.CollectionView.extend()
  childView: AlbumItemView

module.exports = AlbumListView
