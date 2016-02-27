Backbone = require 'backbone'
AlbumModel = require './album-model'

class AlbumCollection extends Backbone.Collection.extend()
  model: AlbumModel

module.exports = AlbumCollection
