BaseView = require '../../base/base-view'

UpdatePhotoDialog = require './update-photo/update-photo-view'
PhotoDetailDialog = require './photo-detail/photo-detail-dialog'

class PhotoView extends BaseView
  template: swig.compile require './photo-item'
  events:
    'click .action-trigger': 'actionHandler'
    'click .js-choose-photo': 'togglePhotoChosen'

  render: ->
    super
    @_adjustCoverImg()
    @listenTo @model, 'change', @render

  _adjustCoverImg: ->
    return unless @model.get 'thumbnail'
    image = new Image()
    image.src = @model.get 'thumbnail'

    $ctn = @$ '.photo-item__cover'
    $coverImg = @$ '.cover-image'
    $coverImg.attr 'src', image.src

    image.onload = ->
      imgWidth = image.width
      imgHeight = image.height
      ctnWidth = $ctn.width()
      ctnHeight = $ctn.height()

      scaleRate = ctnHeight / imgHeight

      imgWidth = scaleRate * imgWidth
      imgHeight = ctnHeight

      $coverImg.css
        'margin-left': (ctnWidth - imgWidth) / 2
        'margin-top': (ctnHeight - imgHeight) / 2

  actionHandler: (e)->
    $target = $ e.currentTarget
    action = $target.data 'action'
    switch action
      when 'edit'
        console.log 'need edit'
        @dialogView = new UpdatePhotoDialog
          model: @model.clone()
          title: '编辑相片'
        @listenTo @dialogView, 'command', @onCommand
        @dialogView.show()
      when 'cover'
        console.log 'set to cover'
        $.ajax
          data:
            cover: @model.get 'thumbnail'
          url: '/album/' + @_parent.model.id
          method: 'PUT'
          success: (data)->
            console.log 'set to cover success'
            console.log data
      when 'delete'
        @model.destroy(
          success: (model, res)->
            console.log 'model destroy success'
        )
      when 'detail'
        console.log 'detail'
        detailDialog = new PhotoDetailDialog
          model: @model.clone()
          title: '相片详情'
          className: 'photo-detail-item'

        detailDialog.show()

  togglePhotoChosen: ()->
    @_isChosen = !@_isChosen
    @$el.toggleClass 'photo-item--chosen', @_isChosen

  onCommand: (command)->
    switch command
      when 'refresh'
        @model.fetch(
          success: (data)->
            console.log 'model fetch success'
            console.log data
        )

module.exports = PhotoView
