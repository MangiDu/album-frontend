Marionette = require 'backbone.marionette'
AlbumListView = require './album/album-list-view'
require '../../node_modules/fine-uploader/jquery.fine-uploader/fine-uploader.css'
require '../../node_modules/fine-uploader/jquery.fine-uploader/jquery.fine-uploader.js'

class HomeView extends Marionette.CompositeView.extend()
  # TODO: BaseDialogView
  template: swig.compile require './home'

  serializeData: ->
    data = {}
    data.origin = window.location.origin
    data

  render: ->
    super
    console.log @$('.album-list')
    albumList = new AlbumListView(
      el: @$('.album-list')
    )
    albumList.render()
    @_initUploader()

  _initUploader: ->
    @$('#fine-uploader-manual-trigger').fineUploader
      template: @$ '#fine-uploader-manual-trigger'
      request:
        endpoint: '/upload'
      thumbnails:
        placeholders:
          waitingPath: '/placeholders/waiting-generic.png'
          notAvailablePath: '/placeholders/not_available-generic.png'
      autoUpload: false

    me = @
    @$('#trigger-upload').click ->
      me.$('#fine-uploader-manual-trigger').fineUploader 'uploadStoredFiles'

module.exports = HomeView
