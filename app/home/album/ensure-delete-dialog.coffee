DialogView = require '../../component/dialog/dialog-view'

class EnsureDeleteDialog extends DialogView
  template: swig.compile require './ensure-delete'
  events:
    'click .js-ensure': 'ensureDelete'
    'click .js-cancel': 'cancelDelete'

  ensureDelete: ->
    @trigger 'command', 'delete'
    @trigger 'command', 'stopListening'
    @hideAndDestroy()

  cancelDelete: ->
    @trigger 'command', 'cancel'
    @trigger 'command', 'stopListening'
    @hideAndDestroy()

module.exports = EnsureDeleteDialog
