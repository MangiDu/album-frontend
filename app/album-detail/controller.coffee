config = require '../config'
PhotoCollection = require './photo-collection'
AlbumDetailView = require './album-detail-view'

module.exports = ()->
  layoutView = config.layoutView
  layoutView.getRegion('content').empty()
  console.log 'album detail need to show'
  console.log arguments[0]
  albumId = arguments[0]
  $.ajax
    url: '/album-detail'
    method: 'GET'
    data: {
      album: albumId
    }
    success: (data)->
      console.log data
      col = new PhotoCollection data
      layoutView.getRegion('content').show new AlbumDetailView
        collection: col

    error: (err)->
      console.log err
