Backbone = require 'backbone'

class BaseModel extends Backbone.Model.extend()
  idAttribute: '_id'

module.exports = BaseModel
