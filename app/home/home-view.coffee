require '../../node_modules/fine-uploader/jquery.fine-uploader/fine-uploader'
require '../../node_modules/fine-uploader/jquery.fine-uploader/jquery.fine-uploader'
Marionette = require 'backbone.marionette'
AlbumListView = require './album/album-list-view'
AlbumCollection = require './album/album-collection'

DialogView = require '../component/dialog/dialog-view'

class HomeView extends Marionette.CompositeView.extend()
  # TODO: BaseDialogView
  template: swig.compile require './home'
  events:
    'click .action-trigger': 'actionHandler'

  serializeData: ->
    data = {}
    data.origin = window.location.origin
    data

  render: ->
    super
    @_getAlbums()
    @_initUploader()
    @_initDialigView()

  _initDialigView: ->
    @dialogView = new DialogView()
    @dialogView.show()

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

  _initUploader: ->
    @$('#fine-uploader-manual-trigger').fineUploader
      form:
        element: @$ '#album-uploadTo'
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

  actionHandler: (e)->
    $target = $ e.currentTarget
    $form = $target.closest 'form'
    dataArray = $form.serializeArray()
    dataToSend = {}
    dataArray.forEach (item)->
      if item.value
        dataToSend[item.name] = item.value
    console.log dataToSend

    $.ajax
      url: '/album'
      method: 'POST'
      data: dataToSend
      success: (data)->
        console.log 'yes'
        console.log data
      error: (err)->
        console.log err

module.exports = HomeView
