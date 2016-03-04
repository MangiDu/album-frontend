Marionette = require 'backbone.marionette'
EnsureDeleteDialog = require './ensure-delete-dialog'
UpdateAlbumDialog = require '../update-album/update-album-view'
Util = require '../../util/util'

class AlbumItemView extends Marionette.ItemView.extend()
  template: swig.compile require './album-item'
  events:
    'click .js-album-cover': 'redirectToDetail'
    'click .action-trigger': 'actionHandler'

  onRender: ->
    # drop extra div wrapper when render
    @$el = @$el.children();
    @$el.unwrap();
    @setElement(@$el);

  onAttach: ->
    @$('.js-album-dropdown').dropdown()

  redirectToDetail: (e)->
    Util.redirectTo "/album_detail/#{@model.id}"

  actionHandler: (e)->
    $target = $ e.currentTarget
    action = $target.data 'action'
    switch action
      when 'edit'
        console.log 'need edit'
        @dialogView = new UpdateAlbumDialog
          model: @model.clone()
      when 'delete'
        console.log 'need delete'
        @dialogView = new EnsureDeleteDialog()

    @listenTo @dialogView, 'command', @onCommand
    @dialogView.show()

  onCommand: (command)->
    switch command
      when 'delete'
        @model.destroy(
          success: (model, response)->
            console.log 'delete sucess'
        )
      when 'stopListening'
        @stopListening @dialogView
        delete @dialogView

module.exports = AlbumItemView
