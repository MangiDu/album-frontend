config = require '../config'
HomeView = require './home-view'

module.exports = ->
  layoutView = config.layoutView
  unless layoutView
    console.warn 'no config.layoutView'
    return
  contentRgn = layoutView.getRegion('content')
  contentRgn.reset()
  contentRgn.show new HomeView
