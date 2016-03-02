config = require '../config'
HomeView = require './home-view'
AlbumCollection = require './album/album-collection'

module.exports = ->
  layoutView = config.layoutView
  unless layoutView
    console.warn 'no config.layoutView'
    return
  contentRgn = layoutView.getRegion('content')
  contentRgn.reset()

  me = @
  $.ajax
    url: '/album'
    method: 'GET'
    success: (data)->
      col = new AlbumCollection data
      contentRgn.show new HomeView
        collection: col

    error: (err)->
      console.log err
