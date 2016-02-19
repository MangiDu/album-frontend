Backbone = require 'backbone'

class UserModel extends Backbone.Model.extend()
  urlRoot: '/api/user/'
  initialize: ->
    console.log @url()

module.exports = UserModel
