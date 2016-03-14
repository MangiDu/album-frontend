Backbone = require 'backbone'
PhotoModel = require './photo-model'
_ = require 'underscore'

class PhotoCollection extends Backbone.Collection.extend()
  model: PhotoModel

module.exports = PhotoCollection
