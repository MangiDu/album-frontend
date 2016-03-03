require './dialog-style'
require '../../../node_modules/jquery-validation/dist/jquery.validate'

DialogView = require '../../component/dialog/dialog-view'
_ = require 'underscore'

class CreateAlbumView extends DialogView
  template: swig.compile require './create-album'
  events: _.extend CreateAlbumView.prototype.events, {
    # 'click .submit': 'validateAndSubmit'
  }

  render: ->
    super
    @_initValidator()


  _initValidator: ->
    me = @
    @$form = @$ 'form.js-create-album'
    @$form.validate(
      errorClass: 'text-danger'
      submitHandler: ()->
        me.submit()
      highlight: (element, errorClass, validClass)->
        $formGroup = $(element).closest('.form-group')
        $formGroup.addClass 'has-error'
      unhighlight: (element, errorClass, validClass)->
        $formGroup = $(element).closest('.form-group')
        $formGroup.removeClass 'has-error'
      errorPlacement: ($error, $element)->
        $error.appendTo $element.parent '.form-group'
    )

  submit: ()->
    dataArray = @$form.serializeArray()
    dataToSend = {}
    dataArray.forEach (item)->
      dataToSend[item.name] = item.value

    $.ajax
      url: '/album'
      method: 'POST'
      data: dataToSend
      success: (data)->
        console.log 'success'
        console.log data
      error: (err)->
        console.log err
    # 防止页面跳转
    return false

module.exports = CreateAlbumView
