require './album-style'
require './album/album-item-style'

Marionette = require 'backbone.marionette'
AlbumCollection = require './album/album-collection'
AlbumItemView = require './album/album-item-view'

UploadDialogView = require './upload-dialog/upload-dialog-view'
AlbumtDialogView = require './create-album/create-album-view'

class HomeView extends Marionette.CompositeView.extend()
  # TODO: BaseDialogView
  template: swig.compile require './home'
  childViewContainer: '.album-list'
  childView: AlbumItemView
  events:
    'click .action-trigger': 'actionHandler'
    'click .js-create-upload': 'showUploadDialog'
    'click .js-create-album': 'showAlbumDialog'

  serializeData: ->
    data = {}
    data.origin = window.location.origin
    data

  showUploadDialog: (e)->
    uploadDialogView = new UploadDialogView()
    uploadDialogView.show()

  showAlbumDialog: (e)->
    albumDialogView = new AlbumtDialogView()
    albumDialogView.show()

  actionHandler: (e)->
    $target = $ e.currentTarget

module.exports = HomeView
