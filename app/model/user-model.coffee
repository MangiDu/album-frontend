Backbone = require 'backbone'

class UserModel extends Backbone.Model.extend()
  urlRoot: '/api/user/'

module.exports = UserModel
