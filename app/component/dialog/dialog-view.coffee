# basic photoView,uploadView都会继承这个View

Marionette = require 'backbone.marionette'
BaseView = require '../../base/base-view'

class DialogView extends BaseView
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
    @setModalTitle()
    @setModalClass()
    $(document.body).append @$el

    @$el.modal
      backdrop: 'static'
      keyboard: false
      show: false

  setModalTitle: ()->
    if title = @getOption 'title'
      @$el.find('.modal-title').html title

  setModalClass: ()->
    if className = @getOption 'className'
      @$el.find('.modal-dialog').addClass className

  show: ->
    @$el.modal 'show'

  actionHandler: (e)->
    $target = $ e.currentTarget
    action = $target.data 'action'
    switch action
      when 'close'
        @hideAndDestroy()

  hideAndDestroy: ->
    @$el.modal 'hide'

    me = @
    @$el.on 'hidden.bs.modal', (e)->
      if me._contentView && me._contentView.destroy instanceof Function
        me._contentView.destroy()
      me.destroy()

module.exports = DialogView
