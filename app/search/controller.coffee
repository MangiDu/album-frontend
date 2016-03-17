config = require '../config'
PhotoCollection = require '../album/photo/photo-collection'
AlbumDetailView = require '../album/album-detail-view'

module.exports = ->
  layoutView = config.layoutView
  unless layoutView
    console.warn 'no config.layoutView'
    return
  contentRgn = layoutView.getRegion('content')
  contentRgn.reset()

  hash = window.location.hash
  url = hash.replace '#', '/'
  console.log url

  me = @
  $.ajax
    url: url
    method: 'GET'
    success: (data)->
      console.log data
      col = new PhotoCollection data
      contentRgn.show new AlbumDetailView
        collection: col

    error: (err)->
      console.log err
