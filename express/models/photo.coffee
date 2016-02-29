mongoose = require('mongoose')
Schema = mongoose.Schema
Photo = new Schema(
  user:
    type: Schema.Types.ObjectId
    ref: 'Account'
  album:
    type: Schema.Types.ObjectId
    ref: 'Album'
  title: String
  description: String
  date:
    type: Date
    default: Date.now
  url: String
  thumbnail: String)
module.exports = mongoose.model('Photo', Photo)
