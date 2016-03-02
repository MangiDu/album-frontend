mongoose = require('mongoose')
Schema = mongoose.Schema
Album = new Schema(
  user:
    type: Schema.Types.ObjectId
    ref: 'Account'
  title: String
  description: String
  date:
    type: Date
    default: Date.now
  photo_amount:
    type: Number
    default: 0
  cover: String
)
module.exports = mongoose.model('Album', Album)
