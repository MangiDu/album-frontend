require './photo-style'

Marionette = require 'marionette'
PhotoView = require './photo/photo-view'
_ = require 'underscore'

class AlbumDetailView extends Marionette.CompositeView.extend()
  template: swig.compile require './album-detail'
  childView: PhotoView
  childViewContainer: '.photo-list'
  events:
    'click .js-manage-batch': 'onManageBatchBtnClick'
    'click .js-batch-delete': 'onBatchDelete'

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

module.exports = AlbumDetailView
