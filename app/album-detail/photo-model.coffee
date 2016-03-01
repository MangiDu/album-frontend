Backbone = require 'backbone'

class PhotoModel extends Backbone.Model.extend()

  initialize: (options)->
    # console.log options
    @id = options._id


module.exports = PhotoModel
