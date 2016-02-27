# basic photoView,uploadView都会继承这个View

Marionette = require 'backbone.marionette'
_ = require 'underscore'

class DialogView extends Marionette.ItemView.extend()
  template: swig.compile require './dialog'
  events:
    'click .action-trigger': 'actionHandler'

  _contentView: null

# initContentView, renderContentView
  initialize: (options)->
    super
    @initContentView()
    @render()

  serializeData: ->
    data = super
    _.defaults data, {
      modalClassName: 'dialog'
    }

  render: ->
    super
    $(document.body).append @$el

    @$('.modal-body').html @renderContentView()

    @$modal = @$('.modal')
    @$modal.modal
      backdrop: 'static'
      keyboard: false
      show: false

  initContentView: ->
    return

  renderContentView: ->
    return

  show: ->
    @$modal.modal 'show'

  actionHandler: (e)->
    $target = $ e.currentTarget
    action = $target.data 'action'
    switch action
      when 'close'
        @_hideAndDestroy()

  _hideAndDestroy: ->
    @$modal.modal 'hide'

    me = @
    @$modal.on 'hidden.bs.modal', (e)->
      if me._contentView && me._contentView.destroy instanceof Function
        me._contentView.destroy()
      me.destroy()

module.exports = DialogView
