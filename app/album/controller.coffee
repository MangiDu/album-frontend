config = require '../config'

module.exports = ()->
  layoutView = config.layoutView
  layoutView.getRegion('content').empty()
  console.log 'album detail need to show'
  console.log arguments
