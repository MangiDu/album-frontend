DialogView = require '../../component/dialog/dialog-view'
_ = require 'underscore'

class CreateAlbumView extends DialogView
  template: swig.compile require './create-album'
  events: _.extend CreateAlbumView.prototype.events, {
    'click .submit': 'submit'
  }

  submit: (e)->
    $target = $ e.currentTarget
    $form = $target.closest 'form'
    dataArray = $form.serializeArray()
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

module.exports = CreateAlbumView
