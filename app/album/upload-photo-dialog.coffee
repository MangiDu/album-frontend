UploadDialogView = require '../home/upload-dialog/upload-dialog-view'

class UploadPhotoDialog extends UploadDialogView
  _getAlbums: ->
    @_resetForm()

  _resetForm: ->
    $select = @$('#album-uploadTo select')
    $select.html('')
    $select.append "<option value='#{@model.id}'>#{@model.get 'title'}</option>"

    $select.selectpicker()

module.exports = UploadPhotoDialog
