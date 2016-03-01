Marionette = require 'marionette'

class PhotoView extends Marionette.ItemView.extend()
  template: swig.compile require './photo-item'
  className: 'photo-item'

module.exports = PhotoView
