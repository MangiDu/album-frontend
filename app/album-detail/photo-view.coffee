BaseView = require '../base/base-view'

class PhotoView extends BaseView
  template: swig.compile require './photo-item'
  events:
    'click .action-trigger': 'actionHandler'

  actionHandler: (e)->
    $target = $ e.currentTarget
    action = $target.data 'action'
    switch action
      when 'edit'
        console.log 'need edit'
      when 'cover'
        console.log 'set to cover'
      when 'delete'
        @model.destroy(
          success: (model, res)->
            console.log 'model destroy success'
        )

module.exports = PhotoView
