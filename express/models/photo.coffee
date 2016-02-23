mongoose = require('mongoose')
Schema = mongoose.Schema
Photo = new Schema(
  user:
    type: Schema.Types.ObjectId
    ref: 'Account'
  title: String
  description: String
  date:
    type: Date
    default: Date.now
  location: String)
module.exports = mongoose.model('Photo', Photo)
