Marionette = require 'backbone.marionette'
Util = require '../../util/util'

class AlbumItemView extends Marionette.ItemView.extend()
  template: swig.compile require './album-item'
  events:
    'click .js-album-cover': 'redirectToDetail'

  onRender: ->
    # drop extra div wrapper when render
    @$el = @$el.children();
    @$el.unwrap();
    @setElement(@$el);

  onAttach: ->
    @$('.js-album-dropdown').dropdown()

  redirectToDetail: (e)->
    Util.redirectTo "/album_detail/#{@model.id}"

module.exports = AlbumItemView
