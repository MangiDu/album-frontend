Marionette = require 'backbone.marionette'
AlbumListView = require './album/album-list-view'
AlbumCollection = require './album/album-collection'

UploadDialogView = require './upload/upload-dialog-view'

class HomeView extends Marionette.CompositeView.extend()
  # TODO: BaseDialogView
  template: swig.compile require './home'
  events:
    'click .action-trigger': 'actionHandler'
    'click .js-create-upload': 'createUploadDialog'

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

  createUploadDialog: (e)->
    console.log 'need upload'
    @uploadDialogView = new UploadDialogView()
    @uploadDialogView.show()

  actionHandler: (e)->
    $target = $ e.currentTarget

module.exports = HomeView
