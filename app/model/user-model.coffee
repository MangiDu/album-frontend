Backbone = require 'backbone'

class UserModel extends Backbone.Model.extend()
  urlRoot: '/api/user/'
  initialize: (options)->
    @id = options._id

module.exports = UserModel
