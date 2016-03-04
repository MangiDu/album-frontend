BaseView = require '../base/base-view'

class PhotoView extends BaseView
  template: swig.compile require './photo-item'

module.exports = PhotoView
