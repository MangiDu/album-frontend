Marionette = require 'backbone.marionette'
Util = require '../../util/util'

class AlbumItemView extends Marionette.ItemView.extend()
  template: swig.compile require './album-item'
  className: 'album-item'
  events:
    'click .cover-image': 'redirectToDetail'

  redirectToDetail: (e)->
    Util.redirectTo "/album_detail/#{@model.id}"

module.exports = AlbumItemView
