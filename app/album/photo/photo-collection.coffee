Backbone = require 'backbone'
PhotoModel = require './photo-model'

class PhotoCollection extends Backbone.Collection.extend()
  model: PhotoModel

module.exports = PhotoCollection
