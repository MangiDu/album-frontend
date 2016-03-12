require './dialog-style'

DialogView = require '../../../component/dialog/dialog-view'
_ = require 'underscore'

class PhotoDetailDialog extends DialogView
  template: swig.compile require './photo-detail'
  events: _.extend PhotoDetailDialog.prototype.events, {
    'click .js-cancel': 'hideAndDestroy'
  }

module.exports = PhotoDetailDialog
