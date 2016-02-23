Marionette = require 'backbone.marionette'
AlbumListView = require './album/album-list-view'

class HomeView extends Marionette.CompositeView.extend()
  # TODO: BaseDialogView
  template: swig.compile require './home'

  serializeData: ->
    data = {}
    console.log window.location
    data.origin = window.location.origin
    data

  render: ->
    super
    console.log @$('.album-list')
    albumList = new AlbumListView(
      el: @$('.album-list')
    )
    albumList.render()

module.exports = HomeView
