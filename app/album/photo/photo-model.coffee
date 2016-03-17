BaseModel = require '../../base/base-model'

class PhotoModel extends BaseModel
  urlRoot: '/photo'

  initialize: ()->
    @listenTo @, 'remove', ->
      console.log 'photo model id:' + @id + ' remove'
      @destroy()
    @listenTo @, 'moveto', (targetAlbumId)->
      debugger
      @set 'album', targetAlbumId
      @save
        success: (model)->
          console.log 'move to save done!'

module.exports = PhotoModel
