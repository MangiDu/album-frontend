Backbone = require 'backbone'

class PhotoModel extends Backbone.Model.extend()
  idAttribute: '_id'
  urlRoot: '/photo'

module.exports = PhotoModel
