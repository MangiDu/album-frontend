# basic photoView,uploadView都会继承这个View

Marionette = require 'backbone.marionette'

class DialogView extends Marionette.ItemView.extend()
  wrapperTemplate: swig.compile require './dialog-wrapper'
  # template: swig.compile require './test'
  events:
    'click .action-trigger': 'actionHandler'

  initialize: (options)->
    super
    @render()

  render: ->
    wrapper = @wrapperTemplate {
      modalClassName: 'dialog'
    }

    $content = super.$el

    @setElement wrapper
    @$el.find('.modal-body').append $content
    $(document.body).append @$el

    @$el.modal
      backdrop: 'static'
      keyboard: false
      show: false

  show: ->
    @$el.modal 'show'

  actionHandler: (e)->
    $target = $ e.currentTarget
    action = $target.data 'action'
    switch action
      when 'close'
        @_hideAndDestroy()

  _hideAndDestroy: ->
    @$el.modal 'hide'

    me = @
    @$el.on 'hidden.bs.modal', (e)->
      if me._contentView && me._contentView.destroy instanceof Function
        me._contentView.destroy()
      me.destroy()

module.exports = DialogView
