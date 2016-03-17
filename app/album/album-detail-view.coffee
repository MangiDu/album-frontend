require './photo-style'

Marionette = require 'marionette'
PhotoView = require './photo/photo-view'
_ = require 'underscore'

UploadPhotoDialog = require './upload-photo-dialog'

class AlbumDetailView extends Marionette.CompositeView.extend()
  template: swig.compile require './album-detail'
  childView: PhotoView
  childViewContainer: '.photo-list'
  events:
    'click .js-manage-batch': 'onManageBatchBtnClick'
    'click .js-batch-delete': 'onBatchDelete'
    'click .js-batch-move-to': 'onBatchMoveTo'
    'click .js-create-upload-dialog': 'showuploadDialog'

  onRender: ->
    return unless @model
    me = @
    $.ajax
      url: '/album-brief'
      method: 'GET'
      success: (data)->
        data.forEach (item)->
          if item._id != me.model.id
            me.$('.other-album-list').append "<li><a class='js-batch-move-to' data-moveto='#{item._id}'>#{item.title}</a></li>"

  onManageBatchBtnClick: (e)->
    manageTextMap = {
      'true': '退出管理'
      'false': '批量管理'
    }
    @_isManaging = !@_isManaging
    $target = $ e.currentTarget
    $target.html manageTextMap[@_isManaging]

    # @$('.photo-toolbar__btns').toggleClass 'photo-toolbar__btns--hidden', @_isManaging
    @$('.photo-list').toggleClass 'photo-list--batch-management', @_isManaging

  onBatchDelete: ->
    modelsChosen = @collection.filter (model)->
      return model.isChosen

    @collection.remove modelsChosen

  onBatchMoveTo: (e)->
    $target = $ e.currentTarget
    targetAlbumId = $target.data 'moveto'
    modelsChosen = @collection.filter (model)->
      return model.isChosen
    console.log "move to #{targetAlbumId}"
    modelsChosen.forEach (model)->
      debugger
      model.trigger 'moveto', targetAlbumId

  showuploadDialog: ->
    dialog = new UploadPhotoDialog
      model: @model.clone()
    dialog.show()

module.exports = AlbumDetailView
