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
    'click .js-create-upload-dialog': 'showUploadDialog'
    'click .js-create-album-dialog': 'showAlbumDialog'

  serializeData: ->
    data = {}
    data.origin = window.location.origin
    data

  showUploadDialog: (e)->
    uploadDialogView = new UploadDialogView(
      title: '上传照片'
    )
    uploadDialogView.show()

  showAlbumDialog: (e)->
    albumDialogView = new AlbumtDialogView(
      title: '创建相册'
    )
    @listenTo albumDialogView, 'refresh', ->
      console.log 'need refresh'
      @collection.fetch({success: ->
        console.log 'collection fetch done'
        # console.log arguments
      })
    albumDialogView.show()

  actionHandler: (e)->
    $target = $ e.currentTarget

module.exports = HomeView
