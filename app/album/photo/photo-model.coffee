BaseModel = require '../../base/base-model'

class PhotoModel extends BaseModel
  urlRoot: '/photo'

  initialize: ()->
    @listenTo @, 'remove', ->
      console.log 'photo model id:' + @id + ' remove'
      @destroy()

module.exports = PhotoModel
