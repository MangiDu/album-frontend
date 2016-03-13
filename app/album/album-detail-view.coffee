require './photo-style'

Marionette = require 'marionette'
PhotoView = require './photo/photo-view'

class AlbumDetailView extends Marionette.CompositeView.extend()
  template: swig.compile require './album-detail'
  childView: PhotoView
  childViewContainer: '.photo-list'
  events:
    'click .js-manage-batch': 'onManageBatchBtnClick'

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

module.exports = AlbumDetailView
