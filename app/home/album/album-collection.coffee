Backbone = require 'backbone'
AlbumModel = require './album-model'

class AlbumCollection extends Backbone.Collection.extend()
  url: '/album'
  model: AlbumModel

module.exports = AlbumCollection
