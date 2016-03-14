BaseView = require '../../base/base-view'

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
      when 'cover'
        $.ajax
          data:
            cover: @model.get 'thumbnail'
          url: '/album/' + @_parent.model.id
          method: 'PUT'
          success: (data)->
            console.log data
      when 'delete'
        @model.destroy(
          success: (model, res)->
            console.log 'model destroy success'
        )
      when 'detail'
        detailDialog = new PhotoDetailDialog
          model: @model.clone()
          title: '相片详情'
          className: 'photo-detail-item'

        detailDialog.show()

      when 'rename'
        console.log 'rename'
        @_titleEditing = true
        @$('.photo-item__title').addClass 'editing'
        title = @model.get 'title'

        me = @

        @$('.js-edit-input').attr
          placeholder: title
          value: title
        .off 'keypress'
        .on 'keypress', (e)->
          inputTitle = $.trim(e.currentTarget.value)
          if inputTitle != '' && e.keyCode == 13
            me.model.set 'title', inputTitle
            me.model.save
              success: (model)->
                console.log 'title save success'
        .blur ()->
          me._titleEditing = false
          me.$('.photo-item__title').removeClass 'editing'
        .focus()

  togglePhotoChosen: ()->
    @model.isChosen = !@model.isChosen
    @$el.toggleClass 'photo-item--chosen', @model.isChosen

  onCommand: (command)->
    switch command
      when 'refresh'
        @model.fetch(
          success: (data)->
            console.log 'model fetch success'
            console.log data
        )

module.exports = PhotoView
