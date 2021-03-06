require '../../../node_modules/fine-uploader/jquery.fine-uploader/fine-uploader-new'
require '../../../node_modules/fine-uploader/jquery.fine-uploader/jquery.fine-uploader'
require './upload-style'

require '../../../node_modules/bootstrap-select/dist/js/bootstrap-select'
require '../../../node_modules/bootstrap-select/dist/css/bootstrap-select'

DialogView = require '../../component/dialog/dialog-view'

class UploadDialogView extends DialogView
  template: swig.compile require './upload'

  render: ->
    super
    @_initUploader()
    @_getAlbums()

  _getAlbums: ->
    me = @
    $.ajax
      url: '/album-brief'
      method: 'GET'
      success: (data)->
        console.log data
        me._albums = data
        me._resetForm()
      error: (err)->
        console.log err

  _resetForm: ->
    $select = @$('#album-uploadTo select')
    $select.html('')
    for album in @_albums
      $select.append "<option value='#{album._id}'>#{album.title}</option>"

    $select.selectpicker()

  _initUploader: ->
    me = @
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
      # uploaderType: 'basic'
      callbacks:
        onAllComplete: ->
          console.log 'yes all uploaded'
          me.trigger 'refresh'
          me.hideAndDestroy()

    @$('#trigger-upload').click ->
      me.$('#fine-uploader-manual-trigger').fineUploader 'uploadStoredFiles'

module.exports = UploadDialogView
