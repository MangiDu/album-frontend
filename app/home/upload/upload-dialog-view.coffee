require '../../../node_modules/fine-uploader/jquery.fine-uploader/fine-uploader'
require '../../../node_modules/fine-uploader/jquery.fine-uploader/jquery.fine-uploader'

DialogView = require '../../component/dialog/dialog-view'

class UploadDialogView extends DialogView
  template: swig.compile require './upload'

  render: ->
    super
    @_initUploader()


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


module.exports = UploadDialogView
