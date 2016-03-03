Backbone = require 'backbone'

class AlbumModel extends Backbone.Model.extend()
  idAttribute: '_id'
  urlRoot: '/album'

module.exports = AlbumModel
