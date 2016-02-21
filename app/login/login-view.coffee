Marionette = require 'backbone.marionette'

class LoginView extends Marionette.ItemView.extend()
  template: swig.compile require './login'
  events:
    'click .action-trigger': 'actionHandler'

  actionHandler: (e)->
    $target = $ e.currentTarget
    $form = $target.closest 'form'
    dataArray = $form.serializeArray()
    data = {}
    dataArray.forEach (obj)->
      data[obj.name] = obj.value
    console.log dataArray
    console.log data

module.exports = LoginView
