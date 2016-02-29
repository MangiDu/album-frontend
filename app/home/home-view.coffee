Marionette = require 'backbone.marionette'
AlbumListView = require './album/album-list-view'
AlbumCollection = require './album/album-collection'

UploadDialogView = require './upload-dialog/upload-dialog-view'
AlbumtDialogView = require './create-album/create-album-view'

class HomeView extends Marionette.CompositeView.extend()
  # TODO: BaseDialogView
  template: swig.compile require './home'
  events:
    'click .action-trigger': 'actionHandler'
    'click .js-create-upload': 'showUploadDialog'
    'click .js-create-album': 'showAlbumDialog'

  serializeData: ->
    data = {}
    data.origin = window.location.origin
    data

  render: ->
    super
    @_getAlbums()

  _getAlbums: ->
    me = @
    $.ajax
      url: '/album'
      method: 'GET'
      success: (data)->
        # console.log data
        col = new AlbumCollection data
        # console.log col
        albumList = new AlbumListView(
          el: me.$('.album-list')
          collection: col
        )
        albumList.render()
        console.log albumList

      error: (err)->
        console.log err

  showUploadDialog: (e)->
    uploadDialogView = new UploadDialogView()
    uploadDialogView.show()

  showAlbumDialog: (e)->
    albumDialogView = new AlbumtDialogView()
    albumDialogView.show()

  actionHandler: (e)->
    $target = $ e.currentTarget

module.exports = HomeView
