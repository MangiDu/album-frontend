require './dialog-style'
require '../../../../node_modules/jquery-validation/dist/jquery.validate'

DialogView = require '../../../component/dialog/dialog-view'
_ = require 'underscore'


class UpdateAlbumView extends DialogView
  template: swig.compile require './update-album'
  events: _.extend UpdateAlbumView.prototype.events, {
    'click .js-cancel': 'hideAndDestroy'
  }

  render: ->
    super

    @$('textarea')[0].defaultValue = @model.get 'description'

    @_initValidator()

  _initValidator: ->
    me = @
    @$form = @$ 'form.js-update-album'
    @$form.validate(
      rules:
        title:
          required: true
          maxlength: 10
        description:
          maxlength: 20
      messages:
        title:
          required: '必填'
          maxlength: $.validator.format('不能超过{0}个字')
        description:
          maxlength: $.validator.format('不能超过{0}个字')
      errorClass: 'text-danger bg-danger'
      errorElement: 'div'
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

  validateAndSubmit: ->
    validator = @$form.data 'validator'
    validator.form()

  submit: ()->
    dataArray = @$form.serializeArray()
    dataToSend = {}
    dataArray.forEach (item)->
      dataToSend[item.name] = item.value

    me = @
    @model.set dataToSend
    @model.save({},
      success: (model, response, options)->
        console.log 'after save'
        console.log model.attributes
        me.trigger 'command', 'refresh', model
        me.hideAndDestroy()
    )

    return false

module.exports = UpdateAlbumView
