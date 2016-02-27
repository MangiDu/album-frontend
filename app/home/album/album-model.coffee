Backbone = require 'backbone'

class AlbumModel extends Backbone.Model.extend()

  initialize: (options)->
    # console.log options
    @id = options._id


module.exports = AlbumModel
