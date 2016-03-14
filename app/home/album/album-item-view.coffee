Marionette = require 'backbone.marionette'
BaseView = require '../../base/base-view'
EnsureDeleteDialog = require './ensure-delete-dialog'
UpdateAlbumDialog = require './update-album/update-album-view'
Util = require '../../util/util'

class AlbumItemView extends BaseView
  template: swig.compile require './album-item'
  events:
    'click .js-album-cover': 'redirectToDetail'
    'click .action-trigger': 'actionHandler'

  initialize: ->
    @listenTo @model, 'change', @render

  onAttach: ->
    @$('.js-album-dropdown').dropdown()

  render: ->
    super
    @_adjustCoverImg()

  _adjustCoverImg: ->
    return unless @model.get 'cover'
    image = new Image()
    image.src = @model.get 'cover'

    $ctn = @$ '.album-item__cover'
    $coverImg = @$ '.cover-image'
    $coverImg.attr 'src', image.src

    image.onload = ->
      imgWidth = image.width
      imgHeight = image.height
      ctnWidth = $ctn.width()
      ctnHeight = $ctn.height()
      $coverImg.css
        'margin-left': (ctnWidth - imgWidth) / 2
        'margin-top': (ctnHeight - imgHeight) / 2

  redirectToDetail: (e)->
    Util.redirectTo "/album/#{@model.id}"

  actionHandler: (e)->
    $target = $ e.currentTarget
    action = $target.data 'action'
    switch action
      when 'edit'
        console.log 'need edit'
        @dialogView = new UpdateAlbumDialog
          model: @model.clone()
          title: '编辑相册'
      when 'delete'
        console.log 'need delete'
        @dialogView = new EnsureDeleteDialog()

    @listenTo @dialogView, 'command', @onCommand
    @dialogView.show()

  onCommand: (command, model)->
    switch command
      when 'refresh'
        @model.set model.attributes
        # @render()
      when 'delete'
        @model.destroy(
          success: (model, response)->
            console.log 'delete sucess'
        )
      when 'stopListening'
        @stopListening @dialogView
        delete @dialogView

module.exports = AlbumItemView
