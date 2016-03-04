config = require '../config'
PhotoCollection = require './photo-collection'
AlbumDetailView = require './album-detail-view'
AlbumModel = require '../home/album/album-model'

module.exports = ()->
  layoutView = config.layoutView
  layoutView.getRegion('content').empty()
  console.log 'album detail need to show'
  console.log arguments[0]
  albumId = arguments[0]

  # 又来了...回调地狱
  $.ajax
    url: '/album-detail'
    method: 'GET'
    data: {
      album: albumId
    }
    success: (data)->
      col = new PhotoCollection data
      $.ajax
        url: '/album/' + albumId
        method: 'GET'
        success: (data)->
          albumModel = new AlbumModel data
          layoutView.getRegion('content').show new AlbumDetailView
            model: albumModel
            collection: col

    error: (err)->
      console.log err
